<?php
/**
 * @file       divalign2/common.php
 * @brief      Common functions for the divalign2 plugin.
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @version    2.3
 * @date       2010-11-11
 * @author     Luis Machuca Bezzaza <luis [dot] machuca [at] gulix [dot] cl>
 */

if(!defined('DOKU_INC')) die();
if(!defined('DOKU_PLUGIN')) die();

/**
 * @class DW_common_divalign2
 * @brief Common interface and functionality for divalign2.
 * @attention This file must be loaded from syntax/[mode].php
 */
class DW_common_divalign2 {

static public function getInfo ($mode=false) {
    $component = ($mode === false) ? "?" : $mode;
    return array(
      'author' => 'Luis Machuca Bezzaza',
      'email'  => 'luis.machuca[at]gulix.cl',
      'date'   => @file_get_contents(DOKU_PLUGIN.'divalign2/VERSION'),
      'name'   => 'divalign2',
      'desc'   => "Paragraph alignment for DokuWiki [$component component].",
      'url'    => 'http://www.dokuwiki.org/plugin:divalign2',
      );
    }

static public function getSort () {
    return 180;
    }

static public function getType () {
    return 'container';
    }

static public function getAllowedTypes() { 
    return array( 
         'container', 'substition', 'protected', 
         'disabled', 'formatting', 'paragraphs'); 
    }

/**
In DokuWiki versions previous to 2010-11-17 "Anteater", 'stack' mode is 
broken, leading to the generation of invalid XHTML code as well as breaking 
of consecutive related syntax modes. This version of the plugin is intended 
to be run with the old versions affected by this bug.

As of this version (2.2B), the only fix with regards to the code seems to be 
explicitly tag and fix the affected areas of code in the renderer output 
between each invocation of the syntax modes.

 @see http://github.com/splitbrain/dokuwiki/commit/f4daa9a18d9c09a1bac0696d92e2bceef8a6800f
 @see http://www.dokuwiki.org/devel:syntax_plugins#PType

**/
static public function getPType () {
    return 'stack';
    }

static public function render ($mode, &$renderer, $data) {
    list($align,$state,$pos) = $data;
    if ($mode == 'xhtml') {
        $epos= strlen($renderer->doc)-10;
        switch ($state) {
        case DOKU_LEXER_ENTER: {
            
            if ($align) { 
                $renderer->doc .= '<div class="divalign-'.$align.'">'; 
                }
            break;
        }
        case DOKU_LEXER_EXIT : {
            $renderer->doc .= '</div><!--divalign-->';
            //DW_common_divalign2::iterFixRenderStack($renderer->doc, $epos);
            break;
        }
        } // end switch
        return true;
    } // end if ($mode == 'xhtml')

    else if ($mode == 'odt' ) {
        $Align = ucfirst ($align);
        static $center_defined= false;
        $st = <<<EOF
<style:style style:name="Text.Divalign.$Align" style:display-name="Text.Divalign.$Align" style:family="paragraph" style:parent-style-name="Text_20_body">
    <style:paragraph-properties fo:text-align="$align" style:justify-single-word="false" />
    </style:style>

EOF;

        $renderer->autostyles["Text.Divalign.$Align"]= $st;
        $center_defined= true;
        switch ($state) {
        case DOKU_LEXER_ENTER: {
            $renderer->doc.= "<text:p text:style-name=\"Text.Divalign.$Align\">";
            break;
        }
        case DOKU_LEXER_EXIT: {
            $renderer->doc.= '</text:p>';
            break;
        }
        } // end switch
    return true;
    }

    else if ($mode == 'text' ) {
        switch ($state) {
        case DOKU_LEXER_ENTER: {
            $renderer->doc .= DW_LF;
            break;
        }
        case DOKU_LEXER_EXIT : {
            $renderer->doc .= DW_LF;
            break;
        }
        } // end switch
        return true;
    } // end if ($mode == 'text')

    return false;
    } // end function

static public function FixRenderStack (&$doc, $pos) {
    $done= false;
    $times= preg_match_all('#<p>\s+?<div class="divalign-.+?">#ms', $doc, $matches);
    $doc= preg_replace('#<p>\s+?<div class="divalign-(.+?)">#ms', '<div class="divalign-$1">', $doc, $times);
    $doc= preg_replace('#</div><!--divalign-->\s+?</p>#ms', '</div>', $doc, $times);
    return $times;
    }


} // end class
