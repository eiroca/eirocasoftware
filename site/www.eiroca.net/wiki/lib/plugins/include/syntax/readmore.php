<?php
/**
 * Include plugin (editbtn header component)
 *
 * @license GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author  Michael Hamann <michael@content-space.de>
 */

class syntax_plugin_include_readmore extends DokuWiki_Syntax_Plugin {

 function getType() {
  return 'formatting';
 }

 function getSort() {
  return 50;
 }

 function handle($match, $state, $pos, &$handler) {
  // this is a syntax plugin that doesn't offer any syntax, so there's nothing to handle by the parser
 }

 var $msgs = null;           // array to hold language dependent strings, best accessed via ->getLang()
 var $curID = null;
 function loadLocale($langID) {
  global $ID;
  if ($curID===$langID) return;
  global $conf;
  $path = DOKU_PLUGIN.$this->getPluginName().'/lang/';
  $lang = array();
  // don't include once, in case several plugin components require the same language file
  @include($path.'en/lang.php');
  if ($langID != 'en') @include($path.$langID.'/lang.php');
  $this->msgs = $lang;
  $this->curID = $langID;
 }

 function render($mode, &$renderer, $data) {
  global $ID;
  list($page) = $data;
  if ($mode == 'xhtml') {
   $renderer->doc .= DOKU_LF.'<p class="include_readmore">'.DOKU_LF;
  } else {
   $renderer->p_open();
  }
  /** @var helper_plugin_tag $tag */
  if (plugin_isdisabled('translation') || (!$translation = plugin_load('helper', 'translation'))) {
   $message = $this->getLang('readmore');
  }
  else {
   $this->loadlocale($translation->getLangPart($ID));
   $message = $this->msgs['readmore'];
  }
  $renderer->internallink($page, $message);
  if ($mode == 'xhtml') {
   $renderer->doc .= DOKU_LF.'</p>'.DOKU_LF;
  } else {
   $renderer->p_close();
  }

  return true;
 }
}
// vim:ts=4:sw=4:et:
