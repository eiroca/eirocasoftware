<?php
/**
 * DokuWiki Syntax Plugin Uparrow
 *
 * Shows an arrow image which links to the top of the page.
 * The image can be defined via the configuration manager.
 *
 * Syntax:  ~~UP~~
 *
 * @license GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author  Michael Klier <chi@chimeric.de>
 */
// must be run within DokuWiki
if(!defined('DOKU_INC')) die();
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
if(!defined('DW_LF')) define('DW_LF',"\n");
require_once(DOKU_PLUGIN.'syntax.php');

/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */
class syntax_plugin_uparrow extends DokuWiki_Syntax_Plugin {

	/**
	 * return some info
	 */
	function getInfo(){
		return array(
			'author' => 'Michael Klier',
			'email'  => 'chi@chimeric.de',
			'date'   => @file_get_contents(DOKU_PLUGIN.'uparrow/VERSION'),
			'name'   => 'Plugin UpArrow (syntax component)',
			'desc'   => 'Shows an arrow image which links to top of the page.',
			'url'    => 'http://dokuwiki.org/plugin:uparrow',
		);
	}

	/**
	 * Syntax Type
	 *
	 * Needs to return one of the mode types defined in $PARSER_MODES in parser.php
	 */
	function getType()  { return 'substition'; }
	function getPType() { return 'block'; }
	function getSort()  { return 304; }

	/**
	 * Connect pattern to lexer
	 */
	function connectTo($mode) { $this->Lexer->addSpecialPattern('~~UP~~',$mode,'plugin_uparrow'); }

	/**
	 * Handle the match
	 */
	function handle($match, $state, $pos, &$handler){
		if ($match == '~~UP~~') {
			$image = $this->getConf('image');
			if(!@file_exists(DOKU_PLUGIN.'uparrow/images/' . $image)) {
				$src = DOKU_URL.'lib/plugins/uparrow/images/tango-big.png';
			} 
			else {
				$src = DOKU_URL.'lib/plugins/uparrow/images/' . $image;
			}
			return array($src);
		}
	}

	/**
	 * Create output
	 */
	function render($mode, &$renderer, $data) {
		global $lang;
		if ($mode == 'xhtml'){
			$renderer->doc .= '<div class="plugin_uparrow">' . DW_LF;
			$renderer->doc .= '  <a href="#" title="' . $lang['btn_top'] . '">' . DW_LF;
			$renderer->doc .= '    <img src="' . $data[0] . '" alt="' . $lang['btn_top'] . '"/>' . DW_LF;
			$renderer->doc .= '  </a>' . DW_LF;
			$renderer->doc .= '</div>' . DW_LF;
			return true;
		} 
		else {
			return false;
		}
	}
}
