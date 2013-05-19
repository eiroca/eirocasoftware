<?php
// must be run from within DokuWiki
if (!defined('DOKU_INC')) die();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<?php
global $__name; $nam = tpl_pagetitle($ID, true); $pos = strpos($nam, ":");
global $__lang;
if ($pos===false) { $__name = $nam; $__lang = "";} else { $__name = substr($nam, $pos+1); $__lang = substr($nam, 0, $pos).":"; }
$nam = hsc(tpl_img_getTag('IPTC.Headline',$IMG));
$pos = strrpos($nam, ":"); $pos2 = strrpos($nam, ".");
if ($pos!==false) {$__name = $__name." ".substr($nam, $pos+1, $pos2-$pos-1);}
$__name = ucwords(str_replace(":", " ", str_replace("_", " ", $__name)));
echo "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"" . $conf['lang'] . "\" lang=\"" . $conf['lang'] . "\" dir=\"" . $lang['direction'] ."\">\n";
?>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title><?php global $__name; echo strip_tags($conf['title']) ." - ". $__name; ?></title>
  <?php tpl_metaheaders()?>
  <link rel="shortcut icon" href="<?php echo DOKU_TPL?>images/eiroca.ico" />
</head>
<body>
<div class="dokuwiki">
  <?php html_msgarea()?>
  <div class="header">
   <div class="logo"><a href="/wiki/" accesskey="h" title="[ALT+H]"><img src="/static/eiroca.gif" alt="eIrOcA"/></a></div>
   <div class="pagename"><?php global $__name; tpl_link(wl($ID,'do=backlink'),$__name); ?></div>
   <div class="translate"><?php $translation = &plugin_load('helper','translation'); echo $translation->showTranslations(); ?></div>
  </div>
  <?php if($ERROR){ print $ERROR; }else{ ?>
   <div class="page_img">
    <div class="img_big"><a href="#" onclick="history.go(-1)"><?php tpl_img(0,0,false,array(id=>"img_id")) ?></a></div>
   </div>
   <div class="img_detail">
    <p>&larr; <?php echo $lang['img_backto']?> <?php tpl_pagelink($ID)?></p>
   </div>
  <?php } ?>
  <div align="center" class="footerinc">
   <?php global $__lang; tpl_pagelink($__lang."copyright", "Copyright (c) eIrOcA 2002-2010") ?><br/>
   <a target="_blank" href="<?php echo DOKU_BASE?>feed.php" title="Recent changes RSS feed"><img src="<?php echo DOKU_TPL?>images/button-rss.png" width="80" height="15" alt="Recent changes RSS feed" border="0" /></a>
   <a target="_blank" href="http://wiki.splitbrain.org/wiki:dokuwiki" title="Driven by DokuWiki"><img src="<?php echo DOKU_TPL?>images/button-dw.png" width="80" height="15" alt="Driven by DokuWiki" border="0" /></a>
   <a target="_blank" href="http://www.firefox-browser.de" title="do yourself a favour and use a real browser - get firefox"><img src="<?php echo DOKU_TPL?>images/button-firefox.png" width="80" height="15" alt="do yourself a favour and use a real browser - get firefox!!" border="0" /></a>
   <a target="_blank" href="http://jigsaw.w3.org/css-validator/check/referer" title="Valid CSS"><img src="<?php echo DOKU_TPL?>images/button-css.png" width="80" height="15" alt="Valid CSS" border="0" /></a>
   <a target="_blank" href="http://validator.w3.org/check/referer" title="Valid XHTML 1.0"><img src="<?php echo DOKU_TPL?>images/button-xhtml.png" width="80" height="15" alt="Valid XHTML 1.0" border="0" /></a>
   <a target="_blank" href="http://www.ohloh.net"><img src="http://www.ohloh.net/images/badges/mini.gif" width="80" height="15" alt="Ohloh" /></a>
  </div>
</div>
<script type="text/javascript" ><!--//--><![CDATA[//><!--
NoClick();
<?php
	$w = tpl_img_getTag('File.Width');
	$h = tpl_img_getTag('File.Height');
  echo 'Resize("img_id",'.$w.','.$h.');'; ?>
//--><!]]></script>
</body>
</html>

