<?php
/**
 * Plugin orgapp: OrgApp applet integration - GPL>=3 - See licence COPYING file
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2011 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL >=3 (http://www.gnu.org/licenses/)
 * @version 1.0.0
 * @link http://www.eiroca.net
 */
if (!defined('DOKU_INC')) die();
if (!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
if (!defined('DOKU_PLUGIN_BARCODE')) define('DOKU_PLUGIN_BARCODE',DOKU_PLUGIN.'barcode/');
class QRProvider {
	public static function getService($provider){
		require_once DOKU_PLUGIN_BARCODE."api/$provider/barcode.inc";
		$provider = "QR_".$provider;
		return new $provider();
	}
	function addParam(&$first, $param) {
		if (!$first) { return "&".$param; }
		$first = false;
		return $param;
	}
	function _IMG($url,$id,$class) {
		$out = '<img src="'.$url.'" alt="barcode"';
		if ($id) {$out .= ' id="'.$id.'"';}
		if ($class) {$out .= ' class="'.$class.'"';}
		$out .= ' />';
		return $out;
	}
	function render(&$p) {
		return "";
	}
}
?>