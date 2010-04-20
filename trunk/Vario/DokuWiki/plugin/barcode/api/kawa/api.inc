<?php
/**
 * Plugin orgapp: OrgApp applet integration - GPL>=3 - See licence COPYING file
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2010 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL >=3 (http://www.gnu.org/licenses/)
 * @version 1.0.0
 * @link http://www.eiroca.net
 */
class QR_kawa extends QRProvider {
	// http://qrcode.kaywa.com/
	function render(&$p) {
		$first= true;
		$size = $p['size'];
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
}
?>