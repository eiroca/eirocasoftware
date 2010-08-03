<?php
/**
 * Extension: Slides (presentation) WikiMedia extension
 * base upon Slides.php Copyright (C) 2006 by Tels http://bloodgate.com
 * @author Enrico Croce & Simona Burzio (staff@eiroca.net)
 * @copyright Copyright (C) 2009-2010 eIrOcA - Enrico Croce & Simona Burzio
 * @license GPL v2 (http://www.gnu.org/licenses/)
 * @version 1.0.0
 * @link http://www.eiroca.net
 */
$wgExtensionFunctions[] = "wfSlidesExtension";
function wfSlidesExtension() {
	global $wgParser;
	$wgParser->setHook( "slides", "renderNavigation" );
}
# for Special::Version:
$wgExtensionCredits['parserhook'][] = array(
  'name' => 'Slides (presentation) extension',
  'author' => 'eIrOcA',
  'url' => 'http://www.eiroca.net/',
  'version' => 'v1.0.0',
);
# The callback function for outputting the HTML code
function renderNavigation($sInput, $sParams, $parser=null) {
	global $wgArticlePath;
	global $wgScript;
	# if we didn't get the parser passed in, we are running under an older mediawiki
	if (!$parser) $parser = &$_GLOBALS['wgParser'];
	# Find out whether we are currently rendering for a preview, or the final
	# XXX TODO: unreliable and unused yet
	global $action;
	if ($action == 'submit') { $bPreview = true; } else { $bPreview = false; }
	# all the entries in the navbar
	$aLinks = array();
	# the presentation name
	$sIndex  = '';
	# prefix for presentation slides
	$sPrefix = '';
	# stopped parsing options?
	$bArticles = false;
	# set a new font size for the body?
	$sFontSize = '';
	# hide first-level headline?
	$bHideHeading = true;
	# hide left menu-column?
	$bHideMenu = true;
	# hide footer?
	$bHideFooter = true;
	# show nav buttons (|< << >> >|)
	$bShowButtons = true;
	# show only the current page (not the full index)
	$bCompact = false;
	$sPresID = null;
	global $_REQUEST;
	$sReqID = $_REQUEST["_E_PID"];
	$sSmall = '85%';
	$sDivStyle = "background: #ffffe0; border: 1px dashed black; padding: 0.2em 0.2em 0.2em 0.5em; margin: 0.5em 0 1em 0;";
	# Parse the parameters, stop at first "Invalid" looking one
	$aParams = explode("\n", $sInput);
	foreach ($aParams as $sCur) {
		$sCur = trim($sCur);
		# skip empty lines
		if ($sCur == '') { continue; }
		$aCur = explode("=", $sCur);
		if (count($aCur) == 2) {
			$sType = trim($aCur[0]);
			$sVal = trim($aCur[1]);
			switch ($sType) {
				case 'index': $lIndex = $sVal; break;
				case 'style': $sDivStyle = $sVal; break;
				case 'id': $sPresID = $sVal; break;
				case 'name': $sPrefix = $sVal; break;
				case 'prefix': $sPrefix = $sVal; break;
				case 'fontsize': if (preg_match('/^\d+%$/',$sVal)) { $sFontSize = $sVal; } break;
				case 'showButtons': if ($sVal == 'false') { $bShowButtons = false; } break;
				case 'hideMenu': if ($sVal == 'false') { $bHideMenu = false; } break;
				case 'compact': if ($sVal == 'true') { $bCompact = true; } break;
				case 'hideFooter': if ($sVal == 'false') { $bHideFooter = false; } break;
				case 'hideHeading': if ($sVal == 'false') { $bHideHeading = false; } break;
				case 'hideAll':
					# true is the default
					if ($sVal == 'false') {
						$bHideMenu = false;
						$bHideFooter = false;
						$bHideHeading = false;
					}
					else if ($sVal == 'true') {
						$bHideMenu = true;
						$bHideFooter = true;
						$bHideHeading = true;
					}
					break;
				default:
					$bArticles = true;
			}
		}
		# Not exactly one "=", so stop parsing options and begin with articles
		else { $bArticles = true; }
		# store the Article reference as-is (e.g. '*Name|Foo|Click here')
		if ($bArticles) { $aLinks[] = $sCur; }
	}
	if ($sReqID!=null) {
		// This is not the wanted presentation
		if ($sPresID!=$sReqID) { return; }
	}
	if ($sPresID!=null) {
		$_REQUEST["_E_PID"] = $sPresID;
		$sReqID = $sPresID;
		$param = "_E_PID=".$sPresID;
	}
	# build the path for article links
	$sBasePath = $wgArticlePath;
	if ($sBasePath == '') { $sBasePath = $wgScript . '/'; }
	# "index.php?title=$1" => "index.php?title="
	$sBasePath = preg_replace('/\$1/', '', $sBasePath);
	# the page we are currently on from the Parser member mTitle, to make it different
	$sCurrent = $parser->getTitle();
	# turn spaces into underscores
	$sCurrent = preg_replace('/ /', '_', $sCurrent);
	$sPrefix = preg_replace('/ /', '_', $sPrefix);
	$sTitlePrefix = $sPrefix;
	if ($sTitlePrefix!='') { $iColPos = strpos(':', $sTitlePrefix); }
	if ($iColPos>0) { $sTitlePrefix = substr($sTitlePrefix, $iColPos+1); }
	# 'My presentation - Start' => 'Start'
	if ($sPrefix!='') { $sCurrent = preg_replace('/^' . preg_quote($sTitlePrefix) . '/', '', $sCurrent); }
	# "/wiki/index.php?title="  =>  "/wiki/index.php?title=My_Presentation"
	$sPath = $sBasePath . $sPrefix;
	# finally generate the HTML output
	# the lower nav bar with the subtopics
	$sSubTopics = '';
	# the last seen topic was the current one
	$bCurrent = false;
	# we see currently a subtopic
	$bSubtopic = false;
	# Format the navbar as table (would love to do that as CSS, tho)
	$output = '<table style="font-size:'.$sSmall.';border:none;background:transparent"><tr>';
	if ($lIndex) { $output .= '<td style="vertical-align:top">'._build_link($sBasePath, $lIndex, $param).':&nbsp;</td>'; }
	$output .= '<td>';
	# we need two passes, in the first one we find the curren topic and subtopic:
	$sCurTopic = '';
	$sCurSubTopic = '';
	$sLastTopic = '';
	# index of current topic
	$iCurr = -1;
	# find the current topic
	for ($i=0; $i<count($aLinks); $i++) {
		# convert all spaces to underscores
		$aTitle = _explode($aLinks[$i]);
		if (preg_match('/^\*/', $aTitle[0])) {
			# subtopic equals current article?
			if (strcmp('*'.$sCurrent, $aTitle[0]) == 0) {
				# remove the leading '*'
				$sCurTopic = $sLastTopic;
				$sCurSubTopic = preg_replace('/^\*/', '', $aTitle[0]);
				$iCurr = $i;
			}
		}
		else {
			# topic equals current article?
			if (strcmp($sCurrent, $aTitle[0]) == 0) {
				$sCurTopic = $aTitle[0];
				$sCurSubTopic = '';
				$iCurr = $i;
			}
			$sLastTopic = $aTitle[0];
		}
	}
	#No current item, disable compact mode
	if ($iCurr==-1) {
		$bCompact=false;
		$iCurr=0;
	}
	# second pass, build the output
	$iFirstSub = 0;
	for ($i=0; $i<count($aLinks); $i++) {
		$sLink = $aLinks[$i];
		$bSubtopic = false;
		if (preg_match('/^\*/', $sLink)) {
			$bSubtopic = true;
			# if we aren't in the current topic, supress the subtopic
			if (!$bCurrent) { continue; }
			# for each subtopic, count up
			$iFirstSub++;
			# remove the leading '*'
			$sLink = preg_replace('/^\*/', '', $sLink);
		}
		else {
			# reset
			$iFirstSub = 0;
			$bCurrent=false;
		}
		# Article name|Navbar name|Mouseover
		$aTitle = _explode($sLink);
		# for topics, compare against $sCurTopic
		$sCmp = $sCurTopic;
		if ($bSubtopic)  { $sCmp = $sCurSubTopic; }
		$sBold = '';
		$sBold1 = '';
		$bBuildLink = true;
		if (strcmp($aTitle[0], $sCmp) == 0) {
			$sBold = '<b>';
			$sBold1 = '</b>';
			# the current page is a topic header?
			if ($bSubtopic || $sCurSubTopic == '') { $bBuildLink = false; }
			if (!$bSubtopic) { $sSubTopics = '<span style="font-size: 90%">'; }
			$bCurrent = true;
		}
		else if (!$bSubtopic) { $bCurrent = false; }
		if (!$bBuildLink) { $sOut = '<b>' . $aTitle[1] . '</b>'; }
		else { $sOut = $sBold . _build_link($sPath, $sLink, $param) . $sBold1; }
		if ($i != 0 && $iFirstSub != 1 && !$bCompact) { $sOut = '&nbsp;- ' . $sOut; }
		# and add it to the navbar
		if ($bSubtopic) { $sSubTopics .= $sOut; }
		else if ((!$bCompact)||($i == $iCurr)) { $output .= $sOut; }
	}
	if ($sSubTopics != '') { $sSubTopics = '<br />' . $sSubTopics . '</span>'; }
	$aTitle = _explode($aLinks[0]);
	$bOnFirstPage = false;
	if (strcmp($sCurrent,$aTitle[0]) == 0) { $bOnFirstPage = true; }
	$aTitle = _explode($aLinks[count($aLinks)-1]);
	$bOnLastPage = false;
	if (strcmp($sCurrent,$aTitle[0]) == 0) { $bOnLastPage = true; }
	# generate next/prev links
	$sButtons = '';
	# only include buttons if not editing the template
	if (($sCurTopic != '') && $bShowButtons) {
		if (!$bOnFirstPage) { $sButtons = _build_link($sPath, $aLinks[0], $param, '|&lt;', 'First page') . '&nbsp;' . _build_link($sPath, $aLinks[$iCurr-1], $param, '&lt;&lt;', 'Previous page');  }
		if (!$bOnLastPage) { $sButtons .= '&nbsp;&nbsp;' . _build_link($sPath, $aLinks[$iCurr+1], $param, '&gt;&gt;', 'Next page', ' ') . '&nbsp;' . _build_link($sPath, $aLinks[count($aLinks)-1], $param, '&gt;|', 'Last page'); }
		if ($sButtons != '') { $sButtons = "<span style=\"float:right;\">$sButtons&nbsp;</span>"; }
	}
	# generate style to suppress the different elements
	$aStyles = array();
	$sMoreStyles = '';
	if ($bHideMenu) {
		$aStyles[] = '#p-logo,#p-navigation,#p-search,#p-tb';
		$sMoreStyles = '#column-content{ margin: 0 0 0.6em -1em}#content{margin: 2.8em 0 0 1em;}#p-actions{margin-left: 1em;}';
	}
	if ($bHideFooter)  { $aStyles[] = '#footer'; }
	$sStyles = '';
	# on the first page, or if no topic (like when editing the template), do not hide anything
	if ( $bOnFirstPage || ($sCurTopic == '') ) {
		$aStyles = array();
		$sMoreStyles = '';
	}
	# hide the heading, even on the first page
	if ($bHideHeading)  { $aStyles[] = '.firstHeading'; }
	# maybe we need to set the fontsize
	if (($sFontSize != '') && ($sCurTopic != '')) { $sMoreStyles .= "#bodyContent{font-size: $sFontSize}"; }
	# do we need to set some styles?
	if ( (count($aStyles) > 0) || ($sMoreStyles != '') ) {
		# and we are not in preview ($bPrewview) )
		if (count($aStyles) > 0) { $sStyles = join(',',$aStyles) . "{display:none}"; }
		$sStyles = '<style type="text/css">' . "$sStyles$sMoreStyles</style>";
	}
	return "<div id=\"slides-navbar\" style=\"$sDivStyle\">$sStyles$sButtons$output$sSubTopics</td></tr></table></div>";
}
function _build_link($sPath, $sTheLink, $param='', $sOptionalText = '', $sOptionalTitle = '', $sAccessKey = '') {
	# build a link from the prefix and one entry in the link-array
	$aTitle = _explode($sTheLink);
	$sLink = _escape($aTitle[0], true);
	$sText = _escape($aTitle[1], false);
	$sTitle = _escape($aTitle[2], false);
	if ($sOptionalText != '') { $sText = $sOptionalText; }
	if ($sOptionalTitle != '') { $sTitle = $sOptionalTitle; }
	# remove the leading '*' from article names
	$sLink = preg_replace('/^\*/', '', $sLink);
	if ($sTitle != '') { $sTitle = ' title="' . $sTitle . '"'; }
	if ($sAccessKey != '') { $sAccessKey = ' accesskey="' . $sAccessKey . '"'; }
	# build the link
	$url = $sPath.$sLink;
	if ($param!='') {
		if (strpos("?", $url)>=0) { $url = $url."?".$param; }
		else { $url = $url."&".$param; }
	}
	return "<a href=\"$url\"$sTitle$sAccessKey>$sText</a>";
}
function _explode($sLink) {
	# split into the three components, with defaults (page_name|page name|)
	# Article page_name|display name|Mouseover text
	$aTitle = explode('|',$sLink);
	if (count($aTitle) == 0) { $aTitle[0] = $sLink; }
	$aTitle[0] = preg_replace('/ /', '_', $aTitle[0]);
	if (count($aTitle) < 2) { $aTitle[1] = preg_replace('/_/', ' ',$aTitle[0]); }
	if (count($aTitle) < 3) { $aTitle[2] = ''; }
	return $aTitle;
}
function _escape($sName, $bFull = false) {
	# escape important HTML special chars
	$sName = preg_replace('/</', '&lt;',   $sName);
	$sName = preg_replace('/>/', '&gt;',   $sName);
	$sName = preg_replace('/&/', '&amp;',  $sName);
	$sName = preg_replace('/"/', '&quot;', $sName);
	if ($bFull) {
		$sName = preg_replace('/=/',  '%3D',   $sName);
		$sName = preg_replace('/\?/', '%3F',   $sName);
	}
	return $sName;
}
?>