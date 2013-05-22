<?php
/*
 http://encode.i-nigma.com/
 URL: (QRCode)
 <img src="http://encode.i-nigma.com/QRCode/img.php?d=URL%3Ahttp%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F&c=WanderWiki&s=3" alt="" />
 <img src="http://encode.i-nigma.com/QRCode/img.php?d=URL%3Ahttp%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F&c=WanderWiki&s=4" alt="" />
 <img src="http://encode.i-nigma.com/QRCode/img.php?d=URL%3Ahttp%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F&c=WanderWiki&s=6" alt="" />
 Groessen:
 s=3 : Small
 s=4 : Medium
 s=6 : Large
 c := Caption
 d := Befehl
 URL: (DataMatrix)
 <img src="http://encode.i-nigma.com/DMtrx/img.php?d=URL%3Ahttp%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F&c=WanderWiki&s=6" alt="" />
 Message:
 <img src="http://encode.i-nigma.com/DMtrx/img.php?d=Das%20Wandern%20ist%20des%20M%C3%BCllers%20Lust.&c=WanderWiki&s=6" alt="" />
 Personal Info:
 Name - Phone - EMail
 <img src="http://encode.i-nigma.com/DMtrx/img.php?d=BEGIN%3AVCARD%0AN%3ANName%2C%20VName%0ATEL%3A0241112%0AEMAIL%3Aschrott%40trash-mail.com%0AEND%3AVCARD&c=WanderWiki&s=6" alt="" />
 */

/**
 * Plugin qrcode: 2D-Barcode Implementation
 *
 * @license    GNU
 * @author     Juergen A.Lamers <jaloma.ac@googlemail.com>
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

class syntax_plugin_qrcode_i_nigmacode extends DokuWiki_Syntax_Plugin
{

    /**
     * return some info
     */
    function getInfo()
    {
        return array (
        'author'=>'Juergen A.Lamers',
        'email'=>'jaloma.ac@googlemail.com',
        'date'=>@file_get_contents(DOKU_PLUGIN . 'qrcode/VERSION'),
        'name'=>'i-nigma -- 2D-Barcode Plugin',
        'desc'=>'2D-Barcode Plugin using http://encode.i-nigma.com/ ~~INIGMACODE~text~~',
        'url'=>'http://www.dokuwiki.org/plugin:qrcode',
        );
    }

    /**
     * What kind of syntax are we?
     */
    function getType()
    {
        return 'substition';
    }

    /**
     * What about paragraphs? (optional)
     */
    function getPType()
    {
        return 'inline';
    }

    /**
     * Where to sort in?
     */
    function getSort()
    {
        return 999;
    }

    /**
     * Connect pattern to lexer
     */
    function connectTo($mode)
    {
        $this->Lexer->addSpecialPattern('~~INIGMACODE.*?~~', $mode, 'plugin_qrcode_i_nigmacode');
    }

    /**
     * Handle the match
     */
    function handle($match, $state, $pos, & $handler)
    {
        $paramsArr = explode('~', $match);
        return $paramsArr;
    }

    /**
     * Create output
     */
    function render($mode, & $renderer, $data)
    {
        $align = "";
        if ($mode == 'xhtml')
        {
            $resultStr = '';
            $mode = 'QRCode';
            $paramsArr = $data;
			$last = count($paramsArr);
            for ($i = 0; $i < $last; $i++)
            {
                $currentParam = $paramsArr[$i];
                if ($i == 3 && $currentParam[0] == ' ')
                {
                    $align = 'align="left"';//"top";
                    $currentParam = substr($currentParam, 1);
                } elseif ($currentParam[strlen($currentParam)-1] == ' ' && $i == ($last-3))
                {
                	// Habe ich schon am Anfang ein ' ' gehabt, schalte ich jetzt auf 'center' um
                    if ($align == 'align="left"')
                    {
                        $align = 'align="center"';
                    } else
                    {
                        $align = 'align="right"';//"bottom";
                    }

                    $currentParam = substr($currentParam, 1, sizeof($currentParam)-1);
                }
                $paramPairArr = explode('=', $currentParam);
                switch($paramPairArr[0])
                {
                    case 'INIGMACODE':
                        break;
                    case '':
                        break;
                    case 'mode':
                        $mode = $paramPairArr[1];
                        break;
                    case 'caption':
                        if ('' != $resultStr)
                        {
                            $resultStr .= '&amp';
                        }
                        $resultStr .= 'c='.htmlspecialchars($paramPairArr[1], ENT_QUOTES, 'UTF-8');
                    break;
                    case 'size':
                        $size = $paramPairArr[1];
                        /*
                         s=3 : Small S
                         s=4 : Medium M
                         s=6 : Large L
                         */
                        if ('' != $resultStr)
                        {
                            $resultStr .= '&amp';
                        }
                        switch($size)
                        {
                            case 'S':
                                $resultStr .= 's=3';
                                break;
                            case 'M':
                                $resultStr .= 's=4';
                                break;
                            case 'L':
                                $resultStr .= 's=6';
                                break;
                            default:
                                $resultStr .= 's=4';
                                break;

                        }
                    break;
                    case 'url':
                        /*
                         URL:
                         <img src="http://qrcode.kaywa.com/img.php?s=6&d=http%3A%2F%2Fwww.ich-bin-am-wandern-gewesen.de%2F" alt="qrcode"  />
                         */
                        //					$resultStr .= '&amp;d=URL%3Ahttp%3A%2F%2F' . htmlspecialchars($paramPairArr[1], ENT_QUOTES, 'UTF-8');
                        if ('' != $resultStr)
                        {
                            $resultStr .= '&amp';
                        }
                        $resultStr .= 'd=URL%3Ahttp%3A%2F%2F'.$paramPairArr[1];
                    break;
                    case 'contact':
                        /*				
                         Contact
                         <img src="http://encode.i-nigma.com/DMtrx/img.php?d=BEGIN%3AVCARD%0AN%3ANName%2C%20VName%0ATEL%3A0241112%0AEMAIL%3Aschrott%40trash-mail.com%0AEND%3AVCARD&c=WanderWiki&s=6" alt="" />
                         */
                        $paramContactArr = explode(':', $paramPairArr[1]);
                        if ('' != $resultStr)
                        {
                            $resultStr .= '&amp';
                        }

                        $resultStr .= 'd=BEGIN%3AVCARD%0AN%3A'.
                        htmlspecialchars($paramContactArr[0], ENT_QUOTES, 'UTF-8').
                        '%2C%20'.htmlspecialchars($paramContactArr[1], ENT_QUOTES, 'UTF-8').
                        '%0ATEL%3A'.htmlspecialchars($paramContactArr[2], ENT_QUOTES, 'UTF-8').
                        '%0AEMAIL'.htmlspecialchars($paramContactArr[3], ENT_QUOTES, 'UTF-8').
                        '%0AEND%3AVCARD'
                        ;
                    break;
                    case 'message':
                    case 'text':
                        /*				
                         Text:
                         Message:
                         <img src="http://encode.i-nigma.com/DMtrx/img.php?d=Das%20Wandern%20ist%20des%20M%C3%BCllers%20Lust.&c=WanderWiki&s=6" alt="" />
                         */
                        if ('' != $resultStr)
                        {
                            $resultStr .= '&amp';
                        }
                        $resultStr .= 'd='.htmlspecialchars($paramPairArr[1], ENT_QUOTES, 'UTF-8');
                    break;

                    default:
                        //					$resultStr .= ' ' . $paramPairArr[0] . '="' . $paramPairArr[1] . '"';
                        break;
            }
        }
        /*
         Don't have barcode reader ? click here http://www.freewarepocketpc.net/ppc-tag-barcode.html
         QRcode generated by Tec-it http://www.tec-it.com/online-demos/tbarcode/barcode-generator.aspx
         qrcode.kaywa.com
         <a href="http://www.freewarepocketpc.net/ppc-download-i-nigma-barcode-reader-v1-4.html">Download i-nigma barcode reader v1.40</a>
         */

        if ($resultStr == '')
        {
            return false;
        }
        //	print($resultStr.'<br>');
        $renderer->doc .= '<a href="http://www.i-nigma.com/personal/Default.asp">';
        $renderer->doc .= '<img src="http://encode.i-nigma.com/'.$mode.'/img.php?'.$resultStr.'" '.$align.' border="0"/>';
        $renderer->doc .= '</a>';
        return true;
    }
    return false;
}
} // Class


