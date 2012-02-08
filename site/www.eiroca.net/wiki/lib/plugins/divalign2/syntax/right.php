<?php
/**
 * @file       divalign2/syntax/right.php
 * @brief      Right alignment component for divalign2 plugin.
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @version    2.3
 * @date       2010-11-11
 * @author     Luis Machuca Bezzaza <luis [dot] machuca [at] gulix [dot] cl>
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
require_once(DOKU_PLUGIN. 'divalign2/common.php'); // for common functions

/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */
class syntax_plugin_divalign2_right extends DokuWiki_Syntax_Plugin {
    var $DIVALIGN= 'right';

    function getInfo() {
        return DW_common_divalign2::getInfo($this->DIVALIGN);
    }

    function getSort() { 
        return DW_common_divalign2::getSort(); 
    }

    function getType() { 
        return DW_common_divalign2::getType(); 
    }

    function getAllowedTypes() { 
        return DW_common_divalign2::getAllowedTypes();
    }

    function getPType() {
        return DW_common_divalign2::getPType();
    }
 
    function connectTo($mode) {
        $this->Lexer->addEntryPattern(';;#(?=.+\n;;#)',
            $mode,'plugin_divalign2_'.$this->DIVALIGN);
    }

    function postConnect() {
        $this->Lexer->addExitPattern('\n;;#',
            'plugin_divalign2_'.$this->DIVALIGN);
    }

    function handle($match, $state, $pos, &$handler){
        switch ( $state ) {
          case DOKU_LEXER_ENTER: {
            $align = $this->DIVALIGN;
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
        DW_common_divalign2::render ($mode, $renderer, $data);
    }
}
