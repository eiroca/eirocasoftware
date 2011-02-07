<?php
/**
 * DokuWiki Syntax Plugin Clearfloat
 *
 * Clears the floating of elements such as images.
 *
 * Syntax:  ~~CLEARFLOAT~~ or ~~CL~~
 * 
 * @license GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author  Michael Klier <chi@chimeric.de>
 */

if(!defined('DOKU_INC')) define('DOKU_INC',realpath(dirname(__FILE__).'/../../').'/');
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
if(!defined('DW_LF')) define('DW_LF',"\n");

/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */
class syntax_plugin_clearfloat extends DokuWiki_Syntax_Plugin {


    /**
     * General Info
     */
    function getInfo(){
        return array(
            'author' => 'Michael Klier',
            'email'  => 'chi@chimeric.de',
            'date'   => @file_get_contents(DOKU_PLUGIN.'clearfloat/VERSION'),
            'name'   => 'Clearfloat',
            'desc'   => 'Clears the floating of elements such as images.',
            'url'    => 'http://dokuwiki.org/plugin:clearfloat'
        );
    }

    /**
     * Syntax Type
     *
     * Needs to return one of the mode types defined in $PARSER_MODES in parser.php
     */
    function getType()  { return 'substition'; }
    function getPType() { return 'block'; }
    function getSort()  { return 308; }
    
    /**
     * Connect pattern to lexer
     */
    function connectTo($mode) {
        $this->Lexer->addSpecialPattern('~~CLEARFLOAT~~',$mode,'plugin_clearfloat');
        $this->Lexer->addSpecialPattern('~~CL~~',$mode,'plugin_clearfloat');
    }

    /**
     * Handler to prepare matched data for the rendering process
     */
    function handle($match, $state, $pos, &$handler){
        return array();
    }

    /**
     * Handles the actual output creation.
     */
    function render($mode, &$renderer, $data) {
        if($mode == 'xhtml'){
            $renderer->doc .= '<div class="clearer"></div>' . DW_LF;
            return true;
        }
        return false;
    }

}
// vim:ts=4:sw=4:et:enc=utf-8:
