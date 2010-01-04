<?php
/**
 * This plugin allows to embed wikipages into the current page
 * In addition, parts marked with id's can be replaced.
 *
 * Inspired (and copy&pasted) from the include plugin:
 *   http://wiki.splitbrain.org/plugin:include
 *
 * For wikipage-portion-replacements, the label-plugin is required: http://wiki.splitbrain.org/plugin:label
 *
 *
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author     Pascal Bihler <bihler@iai.uni-bonn.de>
 */

// must be run within Dokuwiki
if(!defined('DOKU_INC')) die();
if(!defined('DOKU_INC')) define('DOKU_INC',realpath(dirname(__FILE__).'/../../').'/');
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');

//

class syntax_plugin_embed extends DokuWiki_Syntax_Plugin {

	function syntax_plugin_embed() {
		global $embedded_pages_by_plugin_embed;
		if (!$embedded_pages_by_plugin_embed) {
			$embedded_pages_by_plugin_embed = array(); // To avoid recursion;
		}
	}

	function getInfo(){
		return array(
			'author' => 'Pascal Bihler',
			'email'  => 'bihler@iai.uni-bonn.de',
			'date'   => '2007-05-14',
			'name'   => 'Embed',
			'desc'   => 'Allows to embed wikipages in other ones, while offering the possibility to replace parts of the original page marked with labels.',
			'url'    => 'http://wiki.splitbrain.org/plugin:embed',
		);
	}

	function getType() { return 'substition'; }

	function getSort(){ return 500; }

	function connectTo($mode) {
		$this->Lexer->addSpecialPattern('<embed\s+[^>]+\s*>.*?</embed>',$mode,'plugin_embed');
		$this->Lexer->addSpecialPattern('<embed\s+[^/]+\s*/>',$mode,'plugin_embed');
	}

	/**
	 * Handle the match
	 */
	function handle($match, $state, $pos, &$handler){
		switch ($state) {
			case DOKU_LEXER_SPECIAL:
				if (preg_match('/<embed\s+([^>]+)\s*>(.*?)<\/embed>/ms',$match,$matches))
				return array($matches[1],$matches[2]);
				else if (preg_match('/<embed\s+([^>]+)\s*\/>/',$match,$matches))
				return array($matches[1],'');
				break;
		}
		return array();
	}
	
	/**
	 * Create output
	 */
	function render($mode, &$renderer, $data) {
		global $ID;
		global $embedded_pages_by_plugin_embed;
		if ($mode == 'xhtml') {
			list($id,$replacement) = $data;
			// prevent caching (to ensure ACL conformity) (TODO sometimes: make more intelligent)
			$renderer->info['cache'] = false; 
			resolve_pageid(getNS($ID), $id, $exists); // resolve shortcuts
			// avoid circular references
			if (!(array_search($id,$embedded_pages_by_plugin_embed) === false)) return false;
			array_push($embedded_pages_by_plugin_embed,$id);
			$ins = $this->_embed_file($id,$replacement);
			$renderer->doc .= p_render('xhtml', $ins, $info);            // ptype = 'normal'
			array_pop($embedded_pages_by_plugin_embed);
			return true;
		}
		return false;
	}

	function _embed_file($id,$replacement) {
		// check permission
		$perm = auth_quickaclcheck($id);
		if ($perm < AUTH_READ) return false;
		//Read embeded page
		$page = io_readfile(wikiFN($id));
		// convert relative links
		$page = $this->_convertInstructions($page,$id);
		// do replacements (on text-base to preserve List indentation and ordering etc.):
		$page = $this->_do_replacements($page,$replacement);
		$ins = p_get_instructions($page);
		return $ins;
	}

	function _do_replacements($page,$r_str) {
		//Build up list of replacements (this needs to be done manually to allow several replacements with nesting if <label>s
		$r_list = array();
		preg_match_all('/<label\s+([a-zA-Z0-9_]+)\s*>/',$r_str, $matches_label, PREG_OFFSET_CAPTURE);
		preg_match_all('/<\/label>/',$r_str, $matches_labelx, PREG_OFFSET_CAPTURE);
		$level = 0;
		$element = array_shift($matches_label[1]);
		$end_element = array_shift($matches_labelx[0]);
		while ($element || $end_element) {
			if ($element && $element[1] < $end_element[1]) { // <label ..> before </label>
				if ($level == 0) {
					$section_name = $element[0];
					$section_start = $element[1]+strlen($section_name)+1;
				}
				$level++;
				$element = array_shift($matches_label[1]);
			} 
			else {  //</label> before <label ..>
				$level--;
				if ($level == 0) {
					$section_end = $end_element[1];
					$r_list[$section_name] = substr($r_str,$section_start,$section_end-$section_start);
				}
				$end_element = array_shift($matches_labelx[0]);
			}
		}
		// now do replacements
		foreach ($r_list as $section => $rep) {
			$page = preg_replace('/<label\s+' . $section .'\s*>.*?<\/label>/ms',$rep, $page);
		}
		return $page;
	}

	//Does not support CamelCase Links currently
	function _convert_link($link,$inclNS) {
		//Check if external:
		if (preg_match('/^(https?:\/\/|mailto:|\\\\)/',$link))
		return $link;
		//check if interwiki or email:
		if ((! strpos('>',$link) === false) || (! strpos('@',$link) === false))
		return $link;
		// convert internal links and media from relative to absolute
		// relative subnamespace
		if ($link{0} == '.') {
			// parent namespace
			if ($link{1} == '.') $link = getNS($inclNS).':'.substr($link, 2);
			// current namespace
			else $link = $inclNS.':'.substr($link, 1);
		} 
		elseif (strpos($link, ':') === false){
			$link = $inclNS.':'.$link;
		}
		return $link;
	}

	function _convertInstructions($page,$page_id) {
		global $ID;
		if (!$page) return;
		// check if embeded page is in same namespace
		$inclNS = getNS($page_id);
		if (getNS($ID) == $inclNS) return $page;
		// convert links
		$page = preg_replace("/\[\[([^\|\]]+)(\|[^\]]+)?\]\]/e", "'[[' . \$this->_convert_link('\\1','$inclNS') . '\\2]]'", $page);
		//convert embeddings
		$page = preg_replace("/<embed\s+([^>]+)\s*\/?>/e", "'<embed ' . \$this->_convert_link('\\1','$inclNS') . '>'", $page);
		//convert images
		$page = preg_replace("/{{(\s*)([^ \|}]+)(\s*)(||[^}]+)}}/e", "'{{\\1' . \$this->_convert_link('\\2','$inclNS') . '\\3\\4}}'",
		$page);
		return $page;
	}

}
//Setup VIM: ex: et ts=4 enc=utf-8 :
