<?php
  /**
   * Info Alphaindex: Displays the alphabetical index of a specified namespace.
   *
   * Version: 1.3
   * last modified: 2008-08-31
   * @license     GPL 2 (http://www.gnu.org/licenses/gpl.html)
   * @author      Hubert Molière  <hubert.moliere@alternet.fr>
   * Modified by  Nicolas H. <prog@a-et-n.com>
   * Modified by  Jonesy <jonesy@oryma.org>
   * Modified by  Samuele Tognini <samuele@netsons.org>
   */
 

if(!defined('DOKU_INC')) define('DOKU_INC',realpath(dirname(__FILE__).'/../../').'/');
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
require_once(DOKU_INC.'inc/search.php');

/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */
class syntax_plugin_alphaindex extends DokuWiki_Syntax_Plugin {

  /**
   * return some info
   */
  function getInfo(){
    return array(
		 'author' => 'Hubert Moliere',
		 'email'  => 'takashi@natural-design.net',
		 'date'   => '2008-10-28',
		 'name'   => 'Alphaindex',
		 'desc'   => 'Insert the alphabetical index of a specified namespace.',
		 'url'    => 'http://wiki.splitbrain.org/plugin:alphaindex'
		 );
  }

  function getType(){ return 'substition';}
  function getAllowedTypes() { return array('baseonly', 'substition', 'formatting', 'paragraphs', 'protected'); }

  /**
   * Where to sort in?
   */
  function getSort(){
    return 139;
  }

  /**
   * Connect pattern to lexer
   */
  function connectTo($mode) {
    $this->Lexer->addSpecialPattern('{{alphaindex>.+?}}',$mode,'plugin_alphaindex');
  }

  /**
   * Handle the match
   */
  function handle($match, $state, $pos, &$handler){
    global $ID;

    $level = 0;
    $nons = true;
    $match = substr($match,13,-2);
    //split namespaces
    $match = preg_split('/\|/u', $match, 2);
    //split level
    $ns_opt = preg_split('/\#/u', $match[0], 2);
    //namespace name
    $ns = $ns_opt[0];
    // add @NS@ option
    if(empty($ns) || $ns == '@NS@') {
      $pos = strrpos($ID,':');
      if($pos!=false){
	$ns = substr($ID,0,$pos);
      }else{
	$ns = '.';
      }
    }
    //level;
    if (is_numeric($ns_opt[1])) {
      $level=$ns_opt[1];
    }
    $match = explode(" ", $match[1]);
    // namespaces option
    $nons = in_array('nons', $match);
    // multi-columns option
    $incol = in_array('incol', $match);
    return array($ns,array('level' => $level,'nons' => $nons,'incol' => $incol));
  }

  /**
   * Render output
   */
  function render($mode, &$renderer, $data) {
    global $ID;
    global $conf;

    if($mode == 'xhtml'){
      // Never cache to get fresh info
      $renderer->info['cache'] = false;
      // Remove Section Edit Buttons
      $oldmaxecl = $conf['maxseclevel'];
      $conf['maxseclevel'] = 0;
      // To see the TOC, to not use ~~NOTOC~~
      if ($renderer->info['toc']) {
	$oldmaxtoc = $conf['maxtoclevel'];
	$conf['maxtoclevel'] = 3;
      }
      else {
	$oldmaxtoc = -1;
      }

      $alpha_data = $this->_alpha_index($data, $renderer);
      if ((!@$n)) {
	$n = $this->getConf('empty_msg');
      }
      $alpha_data = str_replace('{{ns}}',cleanID($data[0]),$alpha_data);

      $alpha_data = p_render('xhtml', p_get_instructions($alpha_data), $info);

      $renderer->doc .= '<div id="alphaindex">' ;
      $renderer->doc .= $ns_data;
      $renderer->doc .= '<hr />';
      $renderer->doc .= $alpha_data;
      $renderer->doc .= '</div>' ;

      $conf['maxseclevel'] = $oldmaxecl;
      if ( $oldmaxtoc == -1 ) $conf['maxtoclevel'] = $oldmaxtoc;
      return true;
    }
    return false;
  }

  /**
   * Return the alphabetical index
   * @author Hubert MOLIERE <hubert.moliere@alternet.fr>
   *
   * This function is a hack of Indexmenu _tree_menu($ns)
   * @author Samuele Tognini <samuele@cli.di.unipi.it>
   *
   * This function is a simple hack of Dokuwiki html_index($ns)
   * @author Andreas Gohr <andi@splitbrain.org>
   */
  function _alpha_index($myns, &$renderer) {
    global $conf;
    global $ID;

    $ns = $myns[0];
    $opts = $myns[1];

    // Articles deletion configuration
    $articlesDeletionPatterns = explode('|', $this->getConf('articles_deletion'));
    // Hide pages configuration
    $hidepages = explode('|', $this->getConf('hidepages'));

    // template configuration
    $titleTpl = $this->getConf('title_tpl');
    $beginLetterTpl = $this->getConf('begin_letter_tpl');
    $entryTpl = $this->getConf('entry_tpl');
    $endLetterTpl = $this->getConf('end_letter_tpl');

    if($ns == '.') {
      $ns = dirname(str_replace(':','/',$ID));
      if ($ns == '.') $ns = '';
    } else {
      $ns = cleanID($ns);
    }

    $ns  = utf8_encodeFN(str_replace(':','/',$ns));
    $data = array();
    search($data,$conf['datadir'],'alphaindex_search_index',$opts,"/".$ns);
    $nb_data = count($data);
    $alpha_data = array();

    // alphabetical ordering
    for($cpt=0; $cpt<$nb_data; $cpt++) {
      $tmpData = $data[$cpt]['id'];

      $pos = strrpos(utf8_decode($tmpData), ':');
      if($conf['useheading']) {
	$pageName = p_get_first_heading($tmpData);
	if($pageName == NULL) {
	  if($pos != FALSE) {
	    $pageName = utf8_substr($tmpData, $pos+1, utf8_strlen($tmpData));
	  } else {
	    $pageName = $tmpData;
	  }
	  $pageName = str_replace('_', ' ', $pageName);
	}
      } else {
	if($pos != FALSE) {
	  $pageName = utf8_substr($tmpData, $pos+1, utf8_strlen($tmpData));
	} else {
	  $pageName = $tmpData;
	}
	$pageName = str_replace('_', ' ', $pageName);
      }
      $pageNameArticle = '';

      // Otherwise,hhidepages doesn't work with useheading
      if($pos != FALSE) {
	$pageNameNS = utf8_substr($tmpData, $pos+1, utf8_strlen($tmpData));
      } else {
	$pageNameNS = $tmpData;
      }

      // if the current page is not a page to hide
      if(!in_array($pageNameNS, $hidepages)) {
	if($this->getConf('metadata_title')) {
	  $tmp = p_get_metadata($data[$cpt]['id']);
	  if(isset($tmp['title']))
	    $pageName = $tmp['title'];
	}
	      
	// Articles deletion
	if(is_array($articlesDeletionPatterns)) {
	  foreach($articlesDeletionPatterns as $pattern) {
	    if(!empty($pattern) && eregi($pattern, $pageName, $result)) {
	      $pageName = eregi_replace($pattern, '', $pageName);
	      $pageNameArticle = ucfirst(trim($result[0]));
	    }
	  }
	}
	      
	// Récupération de la première lettre du mot et classement 
	$firstLetter = utf8_deaccent(utf8_strtolower(utf8_substr($pageName, 0, 1)));
	if(is_numeric($firstLetter)) {
	  $firstLetter_tmp=$this->getConf('numerical_index');
	  if (!empty($firstLetter_tmp)) {
	    $firstLetter = $firstLetter_tmp;
	  }
	}
		
	$articleMoving= $this->getConf('articles_moving');
	if($articleMoving == 0) {
	  $pageName = $pageNameArticle.' '.$pageName;
	} else if (($articleMoving == 1)&&($pageNameArticle != '')) {
	  $pageName = $pageName.' ('.$pageNameArticle.')';
	}

	$data[$cpt]['id2'] = ucfirst($pageName);
	$alpha_data[$firstLetter][] = $data[$cpt];
      }
    }

    // array sorting by key
    ksort($alpha_data);

    // Display of results

    // alphabetical index
    $alphaOutput .= $titleTpl."\n";
    $nb_data = count($alpha_data);
    foreach($alpha_data as $key => $currentLetter) {
      // Sorting of $currentLetter array
      usort($currentLetter, create_function('$a, $b', "return strnatcasecmp(\$a['id2'], \$b['id2']);"));

      $begin = str_replace("{{letter}}" ,utf8_strtoupper($key), $beginLetterTpl);
      $alphaOutput .= $begin."\n";
      foreach($currentLetter as $currentLetterEntry) {
	$link = str_replace("{{link}}" ,":".$currentLetterEntry['id'], $entryTpl);
	$alphaOutput .= str_replace("{{name}}" ,$currentLetterEntry['id2'], $link);
	$alphaOutput .= "\n";
      }
      $end = str_replace("{{letter}}" ,utf8_strtoupper($key), $endLetterTpl);
      $alphaOutput .= $end."\n";
    }

    return $alphaOutput;
  }

} //Alphaindex class end

  /**
   * Build the browsable index of pages
   *
   * $opts['ns'] is the current namespace
   *
   * @author  Andreas Gohr <andi@splitbrain.org>
   * modified by Samuele Tognini <samuele@cli.di.unipi.it>
   */
function alphaindex_search_index(&$data,$base,$file,$type,$lvl,$opts){
  $return = true;

  $item = array();

  if($type == 'd'){
    if ($opts['level'] == $lvl) $return=false;
    if ($opts['nons']) return $return;
  }elseif($type == 'f' && !preg_match('#\.txt$#',$file)){
    //don't add
    return false;
  }

  $id = pathID($file);

  //check hidden
  if($type=='f' && isHiddenPage($id)){
    return false;
  }

  //check ACL
  if($type=='f' && auth_quickaclcheck($id) < AUTH_READ){
    return false;
  }

  //Set all pages at first level
  if ($opts['nons']) {
    $lvl=1;
  }

  $data[]=array( 'id'    => $id,
		 'type'  => $type,
		 'level' => $lvl,
		 'open'  => $return );
  return $return;
}

?>
