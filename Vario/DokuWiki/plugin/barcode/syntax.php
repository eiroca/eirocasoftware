<?php
/**
 *
 * Plugin barcode: 2D-Barcode Implementation
 * Copyright (C) 2009-2010 eIrOcA - Enrico Croce & Simona Burzio
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2010 eIrOcA - Enrico Croce & Simona Burzio
 * @version 1.0.0
 * @link http://www.eiroca.net
 */
if (!defined('DOKU_INC'))    define('DOKU_INC', realpath(dirname( __FILE__ ).'/../../../').'/');
if (!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN', DOKU_INC.'lib/plugins/');
require_once (DOKU_PLUGIN.'syntax.php');
/**
 * All DokuWiki plugins to extend the parser/rendering mechanism need to inherit from this class
 */
class syntax_plugin_barcode extends DokuWiki_Syntax_Plugin {
	/**
	 * return some info
	 */
	function getInfo() {
		return array (
			'author'=>'eIrOcA',
			'email'=>'staff@eiroca.net',
			'date'=>@file_get_contents(DOKU_PLUGIN . 'barcode/VERSION'),
			'name'=>'barcode -- 2D-Barcode Plugin',
			'url'=>'http://www.eiroca.net',
			'desc'=>'2D-Barcode Plugin. Syntax: ~~BARCODE~id=css_id~class=css_class~mode=0~size=M~caption=x~url=http://myurl.com~~'
			);
	}
	/**
	 * What kind of syntax are we?
	 */
	function getType() { return 'substition'; }
	/**
	 * What about paragraphs? (optional)
	 */
	function getPType() { return 'normal'; }
	/**
	 * Where to sort in?
	 */
	function getSort() { return 999; }
	/**
	 * Connect pattern to lexer
	 */
	function connectTo($mode) {
		$this->Lexer->addSpecialPattern('~~BARCODE.*?~~', $mode, 'plugin_barcode');
	}
	/**
	 * Handle the match
	 */
	function handle($match, $state, $pos, &$handler) {
		global $conf;
		global $ID;
		$paramsArr = explode('~', $match);
		$p['mode'] = 0;
		$p['align'] = 0;
		$p['size']  = "M";
		$p['text']  = wl($ID, '', true);
		$last = count($paramsArr);
		for ($i = 0; $i < $last; $i++) {
			$currentParam = $paramsArr[$i];
			if ($i == 3 && $currentParam[0] == ' ') {
				$p['align'] = 1;//"top";
				$currentParam = substr($currentParam, 1);
			}
			elseif ($currentParam[strlen($currentParam)-1] == ' ' && $i == ($last-3)) {
				$p['align'] = $p['align'] + 2;
				$currentParam = substr($currentParam, 0, strlen($currentParam)-1);
			}
			$paramPairArr = explode('=', $currentParam);
			switch($paramPairArr[0]) {
				case 'BARCODE':
					break;
				case '':
					break;
				case 'id':
					$p['id'] = $paramPairArr[1];
					break;
				case 'class':
					$p['class'] = $paramPairArr[1];
					break;
				case 'mode':
					$p['mode'] = $paramPairArr[1];
					break;
				case 'size':
					$p['size'] = $paramPairArr[1];
					break;
				case 'caption':
					$p['caption'] = $paramPairArr[1];
					break;
				case 'url':
					$p['text'] = substr($currentParam,4);
					break;
				case 'tel':
					$p['text'] = "TEL:".substr($currentParam,5);
					break;
				case 'sms':
					$p['text'] = "SMSTO:".$paramPairArr[1].":".$paramPairArr[2];
					break;
				case 'contact':
					$p['text'] = "BEGIN:VCARD\nN:".$paramPairArr[1]."\nTEL:".$paramPairArr[2]."\nEMAIL".$paramPairArr[3]."\nEND:VCARD";
					break;
				default:
					$p['text'] = substr($currentParam,5);
					break;
			}
		}
		$provider = $this->getConf('provider');
		switch ($provider) {
			case 2:
				$out = $this->QR_inigma($p);
				break;
			case 1:
				$out = $this->QR_kaywa($p);
				break;
			default:
				$out = $this->QR_google($p);
				break;
		}
		return $out;
	}
	/**
	 * Create output
	 */
	function render($mode, &$renderer, $data) {
		if ($mode == 'xhtml') {
			$renderer->doc .= $data;
			if ($this->getConf('showfooter')) {
				$txt = @file_get_contents(DOKU_PLUGIN . 'barcode/footer.txt');
				$renderer->doc .= $txt;
			}
			return true;
		}
		return false;
	}
	/**
	 * Add parameter to the url
	 */
	function addParam(&$first, $param) {
		if (!$first) {
			return "&".$param;
		}
		$first = false;
		return $param;
	}
	/**
	 http://qrcode.kaywa.com/
	 */
	function QR_kaywa($p) {
		$first= true;
		$size = $p['size'];
		$align= $p['align'];
		$text = $p['text'];
		$resultStr=	'http://qrcode.kaywa.com/img.php?';
		switch($size) {
			case 'S':
				$resultStr .= $this->addParam($first, "s=4");
				break;
			case 'M':
				$resultStr .= $this->addParam($first, "s=6");
				break;
			case 'L':
				$resultStr .= $this->addParam($first, "s=8");
				break;
			case 'XL':
				$resultStr .= $this->addParam($first, "s=10");
				break;
			default:
				$resultStr .= $this->addParam($first, "s=15");
				break;
		}
		$resultStr .= $this->addParam($first, "d=".urlencode($text));
		return $this->_IMG($resultStr, $p['id'], $p['class']);
	}
	/**
	 http://encode.i-nigma.com/
	 */
	function QR_inigma($p) {
		$first= true;
		if ($p['mode']==1) { $mode="DMtrx"; } else { $mode="QRCode"; }
		$size = $p['size'];
		$align= $p['align'];
		$text = $p['text'];
		$caption = $p['caption'];
		$resultStr = 'http://encode.i-nigma.com/'.$mode.'/img.php?';
		if ($caption){ $resultStr .= $this->addParam($first, "c=".$caption); }
		switch($size) {
			case 'S':
				$resultStr .= $this->addParam($first, "s=3");
				break;
			case 'M':
				$resultStr .= $this->addParam($first, "s=4");
				break;
			case 'L':
				$resultStr .= $this->addParam($first, "s=5");
				break;
			case 'XL':
				$resultStr .= $this->addParam($first, "s=6");
				break;
			default:
				$resultStr .= $this->addParam($first, "s=4");
				break;
		}
		$resultStr .= $this->addParam($first, "d=".urlencode($text));
		return $this->_IMG($resultStr, $p['id'], $p['class']);
	}
	/**
	 http://code.google.com/intl/it-IT/apis/chart/types.html#qrcodes
	 */
	function QR_google($p) {
		$first= true;
		$size = $p['size'];
		$align= $p['align'];
		$text = $p['text'];
		$caption = $p['caption'];
		$resultStr = "http://chart.apis.google.com/chart?";
		$resultStr .= $this->addParam($first, "cht=qr");
		switch($size) {
			case 'S':
				$resultStr .= $this->addParam($first, "chs=120x120");
				break;
			case 'M':
				$resultStr .= $this->addParam($first, "chs=240x240");
				break;
			case 'L':
				$resultStr .= $this->addParam($first, "chs=350x350");
				break;
			case 'XL':
				$resultStr .= $this->addParam($first, "chs=500x500");
				break;
			default:
				$resultStr .= $this->addParam($first, "chs=240x240");
				break;
		}
		$resultStr .= $this->addParam($first, "chl=".urlencode($text));
		return $this->_IMG($resultStr, $p['id'], $p['class']);
	}
	function _IMG($url,$id,$class) {
		$first= true;
		$out = '<img alt="barcode" src="'.$url.'"';
		if ($id) {$out .= ' id="'.$id.'"';}
		if ($class) {$out .= ' class="'.$class.'"';}
		$out .= ' />';
		return $out;
	}
}
?>