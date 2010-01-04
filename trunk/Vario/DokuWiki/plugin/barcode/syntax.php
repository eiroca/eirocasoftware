<?php
/**
 * Plugin qrcode: 2D-Barcode Implementation
 *
 * @license  GNU
 * @author   Juergen A.Lamers <jaloma.ac@googlemail.com>
 * @author   Juergen A.Lamers <jaloma.ac@googlemail.com>
 */

if (!defined('DOKU_INC'))    define('DOKU_INC', realpath(dirname( __FILE__ ).'/../../../').'/');
if (!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN', DOKU_INC.'lib/plugins/');
require_once (DOKU_PLUGIN.'syntax.php');

/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
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
			'desc'=>'2D-Barcode Plugin. Syntax: ~~BARCODE~mode=0~size=M~caption=x~url=http://myurl.com~~'
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

	function addParam(&$first, $param) {
		if (!$first) {
			return "&".$param;
		}
		$first = false;
		return $param;
	}

	/**
	 * Handle the match
	 */
	function handle($match, $state, $pos, &$handler) {
		global $conf;
		$paramsArr = explode('~', $match);
		$p['mode'] = 0;
		$p['align'] = 0;
		$p['size']  = "M";
		$p['text']  = "";
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
					$p['text'] = "BEGIN:VCARD\nN:".$paramPairArr[1]."\nTEL:".$paramPairArr[2]."\nEMAIL".$paramPairArr[3]."\nEND:VARD";
					break;
				default:
					$p['text'] = substr($currentParam,5);
					break;
			}
		}
		$provider = $this->getConf('provider');
		switch ($provider) {
			case 1:
				$out = $this->QR_inigma($p);
				break;
			default:
				$out = $this->QR_kaywa($p);
				break;
		}
		return $out;
	}

	function getAlign($align) {
		switch($align) {
			case 1:
				$align_mode='align="left"';
				break;
			case 2:
				$align_mode='align="right"';
				break;
			case 3:
				$align_mode='align="center"';
				break;
			default:
				break;
		}
		return $align_mode;
	}

	/*
	 http://qrcode.kaywa.com/
	 http://de.wikipedia.org/wiki/QR_Code
	 URL: <img src="http://qrcode.kaywa.com/img.php?s=6&d=http%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F" alt="qrcode"  />
	 Tel: <img src="http://qrcode.kaywa.com/img.php?s=6&d=TEL%3A%2B491632575970" alt="qrcode"  />
	 Text:<img src="http://qrcode.kaywa.com/img.php?s=6&d=DuDa" alt="qrcode"  />
	 SMS: <img src="http://qrcode.kaywa.com/img.php?s=6&d=SMSTO%3A%2B491632575970%3ADuDa" alt="qrcode"  />
	 Size: s=5 : S s=6 : M s=8 : L s=12 : XL
	 */
	function QR_kaywa($p) {
		$first= true;
		$size = $p['size'];
		$align= $p['align'];
		$type = $p['type'];
		$text = $p['text'];
		$align_mode = $this->getAlign($align);
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
		return '<img src="http://qrcode.kaywa.com/img.php?'.$resultStr.'" '.$align_mode.' style="valign:top;" alt="barcode" />';
	}

	function QR_inigma($p) {
		$first= true;
		if ($p['mode']==1) {
			$mode="DMtrx";
		}
		else {
			$mode="QRCode";
		}
		$size = $p['size'];
		$align= $p['align'];
		$type = $p['type'];
		$text = $p['text'];
		$caption = $p['caption'];
		$align_mode = $this->getAlign($align);
		if ($caption){
			$resultStr .= $this->addParam($first, "c=".$caption);
		}
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
		return '<img src="http://encode.i-nigma.com/'.$mode.'/img.php?'.$resultStr.'" '.$align_mode.' style="valign:top;" alt="barcode" />';
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

}
