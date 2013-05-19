<?php
/**
 * Plugin orgapp: OrgApp applet integration - GPL>=3 - See licence COPYING file
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2011 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL >=3 (http://www.gnu.org/licenses/)
 * @version 1.0.0
 * @link http://www.eiroca.net
 */
class QR_qrserver extends QRProvider {
	// http://qrserver.com/api/documentation/create-qr-code/
	function render(&$p) {
		$first= true;
		$size = $p['size'];
		$text = $p['text'];
		$resultStr = "http://api.qrserver.com/v1/create-qr-code/?";
		switch($size) {
			case 'S':
				$resultStr .= $this->addParam($first, "size=120x120");
				break;
			case 'M':
				$resultStr .= $this->addParam($first, "size=240x240");
				break;
			case 'L':
				$resultStr .= $this->addParam($first, "size=350x350");
				break;
			case 'XL':
				$resultStr .= $this->addParam($first, "size=500x500");
				break;
			default:
				$resultStr .= $this->addParam($first, "size=240x240");
				break;
		}
		$resultStr .= $this->addParam($first, "data=".urlencode($text));
		foreach(array("charset-source", "charset-target", "ecc", "color", "bgcolor", "margin", "qzone") as $optional) {
			if ($p[$optional]) $resultStr .= $this->addParam($first, $optional."=".$p[$optional]);
		}
		return $this->_IMG($resultStr, $p['id'], $p['class']);
	}
}
?>