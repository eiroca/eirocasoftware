<?php
/**
 * Plugin orgapp: OrgApp applet integration - GPL>=3 - See licence COPYING file
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2011 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL >=3 (http://www.gnu.org/licenses/)
 * @version 1.0.0
 * @link http://www.eiroca.net
 */
class QR_inigma extends QRProvider {
	// http://encode.i-nigma.com/
	function render(&$p) {
		$first= true;
		if ($p['mode']==1) { $mode="DMtrx"; } else { $mode="QRCode"; }
		$size = $p['size'];
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
}
?>