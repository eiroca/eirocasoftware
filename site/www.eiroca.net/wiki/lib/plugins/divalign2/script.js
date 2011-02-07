/**
 * @file    divalign2/script.js
 * @brief   Adds alignment picker to Edit Toolbar
 * @author  Luis Machuca <luis.machuca@gulix.cl>
 * @license GPL 2
 */

/* array[key]= insertion string , value = icon filename. */



var align_da2_arr = new Array(); 
align_da2_arr['#;;\\n#;;\\n']    = 'pleft.png';
align_da2_arr[';#;\\n;#;\\n']    = 'pcenter.png';
align_da2_arr[';;#\\n;;#\\n']    = 'pright.png';

if(window.toolbar!=undefined){
  toolbar[toolbar.length] = { "type":"picker",
                    "title":"Alignment",
                    "icon":"../plugins/divalign2/images/pleft.png",
                    "key":"",
                    "list": align_da2_arr,
                    /* subdir of lib/images/ where images found.*/
                    "icobase":"../plugins/divalign2/images"};
 }


