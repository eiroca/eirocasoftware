<?php
/**
 * Plugin barcode: 2D-Barcode Implementation
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2010 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL >=3 (http://www.gnu.org/licenses/)
 * @version 1.0.1
 * @link http://www.eiroca.net
 */
if (!defined('DOKU_INC')) die();
if (!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once (DOKU_PLUGIN.'syntax.php');
class QRProvider {
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
class syntax_plugin_barcode extends DokuWiki_Syntax_Plugin {
	function getType() { return 'substition'; }
	function getPType() { return 'normal'; }
	function getSort() { return 999; }
	function connectTo($mode) { $this->Lexer->addSpecialPattern('~~BARCODE.*?~~', $mode, 'plugin_barcode'); }
	function handle($match, $state, $pos, &$handler) {
		global $conf;
		global $ID;
		$paramsArr = explode('~', $match);
		$p['mode'] = 0;
		$p['size']  = "M";
		$p['text']  = wl($ID, '', true);
		$last = count($paramsArr);
		for ($i = 3; $i < $last; $i++) {
			$currentParam = $paramsArr[$i];
			$param = explode('=', $currentParam);
			switch(trim($param[0])) {
				case '':
					break;
				case 'url':
					$p['text'] = substr($currentParam,4);
					break;
				case 'tel':
					$p['text'] = "TEL:".substr($currentParam,4);
					break;
				case 'sms':
					$p['text'] = "SMSTO:".$param[1].":".$param[2];
					break;
				case 'contact':
					$p['text'] = "BEGIN:VCARD\nN:".$param[1]."\nTEL:".$param[2]."\nEMAIL".$param[3]."\nEND:VCARD";
					break;
				case 'text':
					$p['text'] = substr($currentParam,5);
					break;
				default:
					$p[$param[0]] =$param[1];
					break;
			}
		}
		$provider = $this->getConf('provider');
		require_once DOKU_PLUGIN."barcode/api/$provider/api.inc";
		$provider = "QR_".$provider;
		$service = new $provider();
		$out .= $service->render($p);
		return $out;
	}
	/**
	 * Create output
	 */
	function render($mode, &$renderer, $data) {
		global $conf;
		if ($mode == 'xhtml') {
			$renderer->doc .= $data;
			if ($this->getConf('showfooter')) {
				$lang = $conf["lang"];
				$fn = DOKU_PLUGIN . "barcode/footer_".$lang.".txt";
				if (!file_exists($fn)) $fn = DOKU_PLUGIN . 'barcode/footer.txt';
				$renderer->doc .= @file_get_contents($fn);
			}
			return true;
		}
		return false;
	}
}
?>