<?php
/**
 * @file       divalign2/syntax/justify.php
 * @brief      Enables center alignment for divalign2 plugin.
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @version    2.0
 * @author     Luis Machuca B. <luis.machuca[at]gulix.cl>
 */

/**
 *  This work is a form from previous plugin (plugin:divalign)
 *  by Jason Byrne. Check the wikipage for details.
 */ 
 
// must be run within DokuWiki
if(!defined('DOKU_INC')) die();
if(!defined('DW_LF')) define('DW_LF',"\n");
 
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
 
/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */
class syntax_plugin_divalign2_justify extends DokuWiki_Syntax_Plugin {
 
    function getInfo(){
        return array(
            'author' => 'Luis Machuca B.',
            'email'  => 'luis.machuca[at]gulix.cl',
            'date'   => @file_get_contents(DOKU_PLUGIN.'divalign2/VERSION'),
            'name'   => 'divalign2',
            'desc'   => 'Set justify alignment with ### content ###',
            'url'    => 'http://www.dokuwiki.org/plugin:divalign2',
        );
    }
 
    function getSort() { 
      return 157; 
    }
    function getType() { 
      return 'container'; 
    }
    function getAllowedTypes() { 
      return array( 
             'container', 'substition', 'protected', 
             'disabled', 'formatting', 'paragraphs'); 
    }
    
    function getPType() {
      return 'block';
    }
 
    function connectTo($mode) {
        $this->Lexer->addEntryPattern('###(?=.+\n###)',    
               $mode,'plugin_divalign2_justify');
    }
    function postConnect() {
        $this->Lexer->addExitPattern('\n###','plugin_divalign2_justify');
    }
 
    function handle($match, $state, $pos, &$handler){
        switch ( $state ) {
          case DOKU_LEXER_ENTER: {
            $align = 'justify';
            break;
            }
          case DOKU_LEXER_UNMATCHED: {
            $handler->_addCall('cdata', array($match), $pos);
            break;          
            }
        }
        return array($align,$state,$pos);
    }
 
    function render($mode, &$renderer, $data) {
 
        if ($mode == 'xhtml'){
 
          list($align,$state,$pos) = $data;
          switch ($state) {
            case DOKU_LEXER_ENTER: {
              if ($align) { 
                $renderer->doc .= '<div class="divalign-'.$align.'">'; 
                }
              break;
              }
            case DOKU_LEXER_EXIT : {
              $renderer->doc .= '</div>'. DW_LF;
              break;
              }
          } // end switch
          return true;
        } // end if ($mode == 'xhtml')
        if ($mode == 'odt' ){
          list($align,$state,$pos) = $data;
          static $center_defined= false;
          $st = '
          <style:style style:name="Text.Divalign.Justify" style:display-name="Text.Divalign.Justify" style:family="paragraph" style:parent-style-name="Text_20_body">
               <style:paragraph-properties fo:text-align="justify" style:justify-single-word="false"/>
          </style:style>';
          $renderer->autostyles['Text.Divalign.Justify']= $st;
          $center_defined= true;
          switch ($state) {
            case DOKU_LEXER_ENTER: {
              $renderer->doc.= '<text:p ';
              $renderer->doc.= 'text:style-name="Text.Divalign.Justify">';
              break;
              }
            case DOKU_LEXER_EXIT: {
              $renderer->doc.= '</text:p>';
              break;
              }

            } // end switch
          return true;
        }
        if ($mode == 'text' ) {
          list($align,$state,$pos) = $data;
          switch ($state) {
            case DOKU_LEXER_ENTER: {
              $renderer->doc .= DW_LF;
              }
            case DOKU_LEXER_EXIT : {
              $renderer->doc .= DW_LF;
              break;
              }
          } // end switch
          return true;
        } // end if ($mode == 'text')
 
        return false;
    }
 
}
 
