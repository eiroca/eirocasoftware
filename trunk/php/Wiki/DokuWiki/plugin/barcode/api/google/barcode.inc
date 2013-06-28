<?php
/**
 * Plugin orgapp: OrgApp applet integration - GPL>=3 - See licence COPYING file
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2011 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL >=3 (http://www.gnu.org/licenses/)
 * @version 1.0.0
 * @link http://www.eiroca.net
 */
class QR_google extends QRProvider {
	// http://code.google.com/intl/it-IT/apis/chart/types.html#qrcodes
	function render(&$p) {
		$first= true;
		$size = $p['size'];
		$text = $p['text'];
		$caption = $p['caption'];
		$resultStr = 'http://chart.apis.google.com/chart?';
		$resultStr .= $this->addParam($first, 'cht=qr');
		switch($size) {
			case 'S':
				$resultStr .= $this->addParam($first, 'chs=120x120');
				break;
			case 'M':
				$resultStr .= $this->addParam($first, 'chs=240x240');
				break;
			case 'L':
				$resultStr .= $this->addParam($first, 'chs=350x350');
				break;
			case 'XL':
				$resultStr .= $this->addParam($first, 'chs=500x500');
				break;
			default:
				$resultStr .= $this->addParam($first, 'chs=240x240');
				break;
		}
		$resultStr .= $this->addParam($first, 'chl='.urlencode($text));
		return $this->_IMG($resultStr, $p['id'], $p['class']);
	}
}
?>