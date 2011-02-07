<?php
/**
 * Plugin Color: Sets new colors for text and background.
 * 
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author     Christopher Smith <chris@jalakai.co.uk>
 */
 
// must be run within DokuWiki
if(!defined('DOKU_INC')) define('DOKU_INC',realpath(dirname(__FILE__).'/../../').'/');
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
 
/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */
class syntax_plugin_color extends DokuWiki_Syntax_Plugin {
 
    var $odt_styles = array();
    /**
     * return some info
     */
    function getInfo(){
        return array(
            'author' => 'Christopher Smith',
            'email'  => 'chris@jalakai.co.uk',
            'date'   => '2009-06-24',
            'name'   => 'Color Plugin with ODT',
            'desc'   => 'Changes text colour and background',
            'url'    => 'http://www.dokuwiki.org/plugin:tutorial',
        );
    }
 
    function getType(){ return 'formatting'; }
    function getAllowedTypes() { return array('formatting', 'substition', 'disabled'); }   
    function getSort(){ return 158; }
    function connectTo($mode) { $this->Lexer->addEntryPattern('<color.*?>(?=.*?</color>)',$mode,'plugin_color'); }
    function postConnect() { $this->Lexer->addExitPattern('</color>','plugin_color'); }
 
 
    /**
     * Handle the match
     */
    function handle($match, $state, $pos, &$handler){
        switch ($state) {
          case DOKU_LEXER_ENTER :
                list($color, $background) = preg_split("/\//u", substr($match, 6, -1), 2);
                $color = $this->_isValid($color); 
                $background = $this->_isValid($background); 
                return array($state, array($color, $background));
 
          case DOKU_LEXER_UNMATCHED :  return array($state, $match);
          case DOKU_LEXER_EXIT :       return array($state, '');
        }
        return array();
    }
 
    /**
     * Create output
     */
    function render($mode, &$renderer, $data) {
        if($mode == 'xhtml'){
            list($state, $match) = $data;
            switch ($state) {
              case DOKU_LEXER_ENTER :
                list($color, $background) = $match;
                $color = $color?"color:$color;":"";
                $background = $background?"background-color:$background;":"";
                $renderer->doc .= "<span style='$color $background'>";
                break;
 
              case DOKU_LEXER_UNMATCHED :  $renderer->doc .= $renderer->_xmlEntities($match); break;
              case DOKU_LEXER_EXIT :       $renderer->doc .= "</span>"; break;
            }
            return true;
        }
        if($mode == 'odt'){
          list($state, $match) = $data;
            switch ($state) {
              case DOKU_LEXER_ENTER :
                list($color, $background) = $match;
                $style_index = $color.'/'.$background;
                if(empty($this->odt_styles[$style_index]))
                {
                  $stylename = "ColorizedText".count($this->odt_styles);
                  $this->odt_styles[$style_index] = $stylename;
                  $color = $color?'fo:color="'.$this->_color2hex($color).'" ':'';
                  $background = $background?'fo:background="'.$this->_color2hex($background).'" ':'';
                  $renderer->autostyles[$stylename] = '
                  <style:style style:name="'.$stylename.'" style:family="text">
                      <style:text-properties '.$color.$background.'/>
                  </style:style>';
                }
                $renderer->doc .= '<text:span text:style-name="'.$this->odt_styles[$style_index].'">';
                break;
 
              case DOKU_LEXER_UNMATCHED :  $renderer->doc .= $renderer->_xmlEntities($match); break;
              case DOKU_LEXER_EXIT :       $renderer->doc .= "</text:span>"; break;
            }
            return true;
        }
        return false;
    }
 
    // validate color value $c
    // this is cut price validation - only to ensure the basic format is correct and there is nothing harmful
    // three basic formats  "colorname", "#fff[fff]", "rgb(255[%],255[%],255[%])"
    function _isValid($c) {
        $c = trim($c);
 
        $pattern = "/^\s*(
            ([a-zA-z]+)|                                #colorname - not verified
            (\#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}))|        #colorvalue
            (rgb\(([0-9]{1,3}%?,){2}[0-9]{1,3}%?\))     #rgb triplet
            )\s*$/x";
 
        if (preg_match($pattern, $c)) return $c;
 
        return "";
    }
    /**
     * Translate color names and RGB to hex values
     */
    function _color2hex($name)
    {
      static $colornames = null;
      if(is_null($colornames))
      {
        include dirname(__FILE__).'/colornames.php';
      }
      if(!preg_match('/^(#|rgb)/', $name) && array_key_exists($name, $colornames))
        return $colornames[$name];
      elseif(preg_match('/rgb\(([0-9]{1,3}%?),([0-9]{1,3}%?),([0-9]{1,3}%?)\)/', $name, $matches))
      {
        $colors = array();
        for($i=1;$i<4;$i++)
        {
          $percent = substr($matches[$i], -1, 1) == '%';
          $colors[$i] = $percent?(substr($matches[$i],0,-1)/100)*256:$matches[$i];
        }
        return sprintf('#%02X%02X%02X', $colors[1], $colors[2], $colors[3]);
      }
      else
        return $name;
    }
}
?>