<?php
// must be run from within DokuWiki
if (!defined('DOKU_INC')) die();
// include custom arctic template functions
require_once(dirname(__FILE__).'/tpl_functions.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?php
global $__name; $nam = tpl_pagetitle($ID, true); $pos = strpos($nam, ":"); 
global $__lang;
if ($pos===false) { $__name = $nam; $__lang = "";} else { $__name = substr($nam, $pos+1); $__lang = substr($nam, 0, $pos).":"; }
$__name = ucwords(str_replace(":", " ", str_replace("_", " ", $__name)));
echo "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"" . $conf['lang'] . "\" lang=\"" . $conf['lang'] . "\" dir=\"" . $lang['direction'] ."\">\n"; 
?>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>  
    <?php global $__name; echo strip_tags($conf['title']) ." - ". $__name; ?>
  </title>
  <?php tpl_metaheaders()?>
  <link rel="shortcut icon" href="<?php echo DOKU_TPL?>images/eiroca.ico" />
</head>
<body>
 <div id="wrapper">
  <div class="dokuwiki">
   <?php html_msgarea()?>
   <div class="header">
    <div class="logo"><a href="/wiki/" accesskey="h" title="[ALT+H]"><img src="/static/eiroca.png" alt="eIrOcA" width="180" height="35" /></a></div>
    <div class="pagename"><?php global $__name; tpl_link(wl($ID,'do=backlink'),$__name); ?></div>
    <div class="translate"><?php $translation = &plugin_load('helper','translation'); echo $translation->showTranslations(); ?></div>
   </div>
   <div class="commands">
    <div class="breadcrumbs"><?php ($conf['youarehere'] != 1) ? tpl_breadcrumbs() : tpl_youarehere(); ?></div>
    <div class="bar" id="bar__top">
     <?php if (isset($_SERVER['REMOTE_USER'])) { tpl_actionlink('edit'); tpl_actionlink('recent'); tpl_actionlink('index'); tpl_actionlink('history'); tpl_actionlink('admin'); tpl_actionlink('profile'); tpl_actionlink('login'); } 
      else { tpl_actionlink('recent'); tpl_actionlink('index'); tpl_actionlink('login'); } ?>
    </div>
   </div>
   <div class="clearer"></div>
   <div class="sidebar"><?php tpl_sidebar('left'); tpl_searchform(); ?></div>
   <div class="page"><?php tpl_content(false) ?></div>
   <div class="clearer"></div>
   <div class="meta">
    <div class="user"><?php tpl_userinfo()?></div>
    <div class="doc"><?php tpl_pageinfo()?></div>
   </div>
   <div class="clearer"></div>
   <div align="center" class="footerinc">
   <?php global $__lang; tpl_pagelink($__lang."copyright", "Copyright (c) eIrOcA 2001-2010") ?>
   </div>
  </div>
 </div>
 <div class="no"><?php tpl_indexerWebBug()?></div>
</body>
</html>
