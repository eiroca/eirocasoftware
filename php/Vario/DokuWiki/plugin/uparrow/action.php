<?php
/**
 * DokuWiki Action Plugin Uparrow
 *
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author     Michael Klier <chi@chimeric.de>
 */
// must be run within Dokuwiki
if(!defined('DOKU_INC')) die();
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN', DOKU_INC.'lib/plugins/');
if(!defined('DOKU_LF')) define('DOKU_LF', "\n");
require_once(DOKU_PLUGIN.'action.php');

/**
 * All DokuWiki plugins to extend the admin function
 * need to inherit from this class
 */
class action_plugin_uparrow extends DokuWiki_Action_Plugin {

	function getInfo() {
		return array(
			'author' => 'Michael Klier',
			'email'  => 'chi@chimeric.de',
			'date'   => @file_get_contents(DOKU_PLUGIN.'uparrow/VERSION'),
			'name'   => 'UpArrow Plugin (action component)',
			'desc'   => 'Automatically adds an arrow which links to the top of the page after each section.',
			'url'    => 'http://dokuwiki.org/plugin:uparrow',
		);
	}

	// register hook
	function register(&$controller) {
		$controller->register_hook('PARSER_HANDLER_DONE', 'BEFORE', $this, 'insert_uparrow');
	}

	/**
	 * Modifies the final instruction list of a page and adds instructions for
	 * an uparow link.
	 *
	 * Michael Klier <chi@chimeric.de>
	 */
	function insert_uparrow(&$event, $param){
		if(!$this->getConf('auto')) return;
		$image = $this->getConf('image');
		if(!@file_exists(DOKU_PLUGIN.'uparrow/images/' . $image)) {
			$image = DOKU_URL.'lib/plugins/uparrow/images/tango-big.png';
		} 
		else {
			$image = DOKU_URL.'lib/plugins/uparrow/images/' . $image;
		}
		// uparrow plugin instructions
		$uparrow = array('plugin', array('uparrow', array($image), 1, '~~UP~~'));
		$ins_new = array();
		$ins = &$event->data->calls;
		$num = count($ins);
		for ($i=0;$i<$num;$i++) {
			if ($ins[$i][0] == 'section_close') {
				array_push($ins_new, $uparrow);
			}
			array_push($ins_new, $ins[$i]);
		}
		$ins = $ins_new;
	}
}

// vim:ts=4:sw=4:et:enc=utf-8:
