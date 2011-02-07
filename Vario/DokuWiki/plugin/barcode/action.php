<?php
/**
 * Plugin barcode: 2D-Barcode Implementation
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2011 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL >=3 (http://www.gnu.org/licenses/)
 * @version 1.0.2
 * @link http://www.eiroca.net
 */
/* Must be run within Dokuwiki */
if (!defined('DOKU_INC')) die();
if (!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
if (!defined('DOKU_PLUGIN_BARCODE')) define('DOKU_PLUGIN_BARCODE',DOKU_PLUGIN.'barcode/');
require_once(DOKU_PLUGIN . 'action.php');
class action_plugin_barcode extends DokuWiki_Action_Plugin {
	function register(&$controller) {
		$controller->register_hook('TOOLBAR_DEFINE', 'AFTER', $this, 'toolbar_add_button_barcode', array ());
	}
	function toolbar_add_button_barcode(&$event, $param) {
		$event->data[] = array (
			'type' => 'format',
			'title' => $this->getLang('barcode_editor'),
			'icon' => '../../plugins/barcode/editor/barcode.png',
			'open' => '~~BARCODE',
			'sample' => @file_get_contents(DOKU_PLUGIN_BARCODE.'editor/sample.txt'),
			'close' => '~~',
		);
	}
}