<?php
/**
 * Plugin Label: Allows to mark parts of the wikipage with labels in order to 
 * be qualified for special use in other plugins
 *
 * Sytnax: <label [a-zA-Z0-9_]+>...</label>
 * 
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author     Pascal Bihler <bihler@iai.uni-bonn.de>
 */
 
// must be run within Dokuwiki
if(!defined('DOKU_INC')) die();
 
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
 
class syntax_plugin_label extends DokuWiki_Syntax_Plugin {

		var $last_label = array();
		var $LABEL_PATTERN = "[a-zA-Z0-9_]+";
 
    /**
     * return some info
     */
    function getInfo(){
        return array(
            'author' => 'Pascal Bihler',
            'email'  => 'bihler@iai.uni-bonn.de',
            'date'   => '2007-05-14',
            'name'   => 'Label Plugin',
            'desc'   => 'Allows to mark parts of the wikipage with labels',
            'url'    => 'http://wiki.splitbrain.org/plugin:label',
        );
    }
 
    function getType(){ return 'substition'; }
    function getPType(){ return 'normal'; }
    function getSort(){ return 100; }
    function connectTo($mode) { 
						 $this->Lexer->addSpecialPattern('</label>',$mode,'plugin_label');
						 $this->Lexer->addSpecialPattern('<label\s+' . $this->LABEL_PATTERN . '\s*>',$mode,'plugin_label');
	  }
		

    /**
     * Handle the match
     */
    function handle($match, $state, $pos, &$handler){
        switch ($state) {
          case DOKU_LEXER_SPECIAL : 
					    if (preg_match('/<label\s+(' . $this->LABEL_PATTERN . ')\s*>/',$match,$matches)) {
								 $labek = $matches[1];		
								 array_push($this->last_label,$label);				 
					    	 return array("start", $label);
						  } else if ($match == "</label>") {		
							   $label = array_pop($this->last_label);	 
					    	 return array("end", $label);
							}
        }
        return array();
    }
 
    /**
     * Create output
     */
    function render($mode, &$renderer, $data) { //doesn't do much, since label is something internal
        return true;
    }
}
 
//Setup VIM: ex: et ts=4 enc=utf-8 :