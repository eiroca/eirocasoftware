<?php
/*
 http://qrcode.kaywa.com/
 http://de.wikipedia.org/wiki/QR_Code
 Und hier der Code:
 URL:
 <img src="http://qrcode.kaywa.com/img.php?s=6&d=http%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F" alt="qrcode"  />
 Tel:
 <img src="http://qrcode.kaywa.com/img.php?s=6&d=TEL%3A%2B491632575970" alt="qrcode"  />
 Text:
 <img src="http://qrcode.kaywa.com/img.php?s=6&d=DuDa" alt="qrcode"  />
 SMS:
 <img src="http://qrcode.kaywa.com/img.php?s=6&d=SMSTO%3A%2B491632575970%3ADuDa" alt="qrcode"  />
 Groessen:
 s=5 : S
 s=6 : M
 s=8 : L
 s=12 : XL
 */

/**
 * Plugin qrcode: 2D-Barcode Implementation
 *
 * @license  GNU
 * @author   Juergen A.Lamers <jaloma.ac@googlemail.com>
 */

if (!defined('DOKU_INC'))
define('DOKU_INC', realpath(dirname( __FILE__ ).'/../../../').'/');
if (!defined('DOKU_PLUGIN'))
define('DOKU_PLUGIN', DOKU_INC.'lib/plugins/');
require_once (DOKU_PLUGIN.'syntax.php');

/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */

class syntax_plugin_qrcode_qrcode extends DokuWiki_Syntax_Plugin {

  /**
   * return some info
   */
  function getInfo() {
    return array (
    'author'=>'Juergen A.Lamers',
    'email'=>'jaloma.ac@googlemail.com',
    'date'=>@file_get_contents(DOKU_PLUGIN . 'qrcode/VERSION'),
    'name'=>'qrcode -- 2D-Barcode Plugin',
    'desc'=>'2D-Barcode Plugin using http://qrcode.kaywa.com/ ~~QRCODE~text~~',
    'url'=>'http://wiki.splitbrain.org/plugin:qrcode',
    );
  }

  /**
   * What kind of syntax are we?
   */
  function getType() {
    return 'substition';
  }

  /**
   * What about paragraphs? (optional)
   */
  function getPType() {
    return 'inline';
  }

  /**
   * Where to sort in?
   */
  function getSort() {
    return 999;
  }

  /**
   * Connect pattern to lexer
   */
  function connectTo($mode)
  {
    $this->Lexer->addSpecialPattern('~~QRCODE.*?~~', $mode, 'plugin_qrcode_qrcode');
  }

  function addParam(&$first, $param) {
    if (!$first) {
      return "&".$param;
    }
    $first = false;
    return $param;
  }
  
  /**
   * Handle the match
   */
  function handle($match, $state, $pos, &$handler) {
    global $conf;
    $resultStr = '';
    $paramsArr = explode('~', $match);
    $align = "";//"middle";
    $last = count($paramsArr);
    $first=true;
    for ($i = 0; $i < $last; $i++) {
      $currentParam = $paramsArr[$i];
      if ($i == 3 && $currentParam[0] == ' ') {
        $align = 'align="left"';//"top";
        $currentParam = substr($currentParam, 1);
      } 
      elseif ($currentParam[strlen($currentParam)-1] == ' ' && $i == ($last-3)) {
        // Habe ich schon am Anfang ein ' ' gehabt, schalte ich jetzt auf 'center' um
        if ($align == 'align="left"') {
          $align = 'align="center"';
        } 
        else {
          $align = 'align="right"';//"bottom";
        }
        $currentParam = substr($currentParam, 1, sizeof($currentParam)-1);
      }
      $paramPairArr = explode('=', $currentParam);
      switch($paramPairArr[0]) {
        case 'QRCODE':
          break;
        case '':
          break;
        case 'size':
          $size = $paramPairArr[1];
          /*
           s=5 : S
           s=6 : M
           s=8 : L
           s=12 : XL
           */
          switch($size) {
            case 'S':
              $resultStr .= $this->addParam($first, "s=5");
              break;
            case 'M':
              $resultStr .= $this->addParam($first, "s=6");
              break;
            case 'L':
              $resultStr .= $this->addParam($first, "s=8");
              break;
            case 'XL':
              $resultStr .= $this->addParam($first, "s=12");
              break;
            default:
              $resultStr .= $this->addParam($first, "s=15");
              break;
          }
          break;
        case 'url':
          /*
            URL: <img src="http://qrcode.kaywa.com/img.php?s=6&d=http%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F" alt="qrcode"  />
          */
          $url=substr($currentParam,3);
          $resultStr .= $this->addParam($first, "d=".urlencode($url));
          break;
        case 'tel':
          /*                            
            Tel: <img src="http://qrcode.kaywa.com/img.php?s=6&d=TEL%3A%2B491632575970" alt="qrcode"  />
          */
          $resultStr .= $this->addParam($first, "d=TEL".urlencode($paramPairArr[1]));
          break;
        case 'text':
          /*                            
            Text: <img src="http://qrcode.kaywa.com/img.php?s=6&d=DuDa" alt="qrcode"  />
          */
          $resultStr .= $this->addParam($first, "d=".urlencode($paramPairArr[1]));
          break;
        case 'sms':
          /*                            
            SMS: <img src="http://qrcode.kaywa.com/img.php?s=6&d=SMSTO%3A%2B491632575970%3ADuDa" alt="qrcode"  />
          */
          $resultStr .= $this->addParam($first, "d=SMSTO".urlencode($paramPairArr[1]));
          break;
        default:
          // $resultStr .= ' ' . $paramPairArr[0] . '="' . $paramPairArr[1] . '"';
          break;
      }
    }
    /*
     Don't have barcode reader ? click here http://www.freewarepocketpc.net/ppc-tag-barcode.html
     QRcode generated by Tec-it http://www.tec-it.com/online-demos/tbarcode/barcode-generator.aspx
     qrcode.kaywa.com
     <a href="http://www.freewarepocketpc.net/ppc-download-i-nigma-barcode-reader-v1-4.html">Download i-nigma barcode reader v1.40</a>
    */
    return '<img src="http://qrcode.kaywa.com/img.php?'.$resultStr.'" '.$align.' style="valign:top;" alt="qrcode" />';
  }


  /**
   * Create output
   */
  function render($mode, &$renderer, $data) {
    if ($mode == 'xhtml') {
      $renderer->doc .= $data;
      if ($this->getConf('qrcodeshowfooter')) {
        $txt = "Don't have barcode reader? Click <a href=\"http://www.i-nigma.com/Downloadi-nigmaReader.html\">here</a>.";
        $renderer->doc .= $txt;
      }
      return true;
    }
    return false;
  }
  
} // Class

//Setup VIM: ex: et ts=4 enc=utf-8 :
