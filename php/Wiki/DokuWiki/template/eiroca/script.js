/**
 * javascript functionality for the arctic template
 * copies the mothod for dokuwikis TOC functionality
 * in order to keep the template XHTML valid
 */

/**
 * Adds the toggle switch to the TOC
 */
function addSbLeftTocToggle() {
  if (!document.getElementById) return;
  var header = $('sb__left__toc__header');
  if (!header) return;
  var obj = document.createElement('span');
  obj.id = 'sb__left__toc__toggle';
  obj.innerHTML = '<span>&minus;</span>';
  obj.className = 'toc_close';
  obj.style.cursor = 'pointer';
  prependChild(header, obj);
  obj.parentNode.onclick = toggleSbLeftToc;
  try {
    obj.parentNode.style.cursor = 'pointer';
    obj.parentNode.style.cursor = 'hand';
  }
  catch (e) {
  }
}

/**
 * This toggles the visibility of the Table of Contents
 */
function toggleSbLeftToc() {
  var toc = $('sb__left__toc__inside');
  var obj = $('sb__left__toc__toggle');
  if (toc.style.display == 'none') {
    toc.style.display = '';
    obj.innerHTML = '<span>&minus;</span>';
    obj.className = 'toc_close';
  }
  else {
    toc.style.display = 'none';
    obj.innerHTML = '<span>+</span>';
    obj.className = 'toc_open';
  }
}

/**
 * Adds the toggle switch to the TOC
 */
function addSbRightTocToggle() {
  if (!document.getElementById) return;
  var header = $('sb__right__toc__header');
  if (!header) return;
  var obj = document.createElement('span');
  obj.id = 'sb__right__toc__toggle';
  obj.innerHTML = '<span>&minus;</span>';
  obj.className = 'toc_close';
  obj.style.cursor = 'pointer';
  prependChild(header, obj);
  obj.parentNode.onclick = toggleSbRightToc;
  try {
    obj.parentNode.style.cursor = 'pointer';
    obj.parentNode.style.cursor = 'hand';
  }
  catch (e) {
  }
}

/**
 * This toggles the visibility of the Table of Contents
 */
function toggleSbRightToc() {
  var toc = $('sb__right__toc__inside');
  var obj = $('sb__right__toc__toggle');
  if (toc.style.display == 'none') {
    toc.style.display = '';
    obj.innerHTML = '<span>&minus;</span>';
    obj.className = 'toc_close';
  }
  else {
    toc.style.display = 'none';
    obj.innerHTML = '<span>+</span>';
    obj.className = 'toc_open';
  }
}

// add TOC events
addInitEvent(addSbLeftTocToggle);
addInitEvent(addSbRightTocToggle);

// add AJAX index events
addInitEvent(function() {
  index.treeattach($('left__index__tree'));
});
addInitEvent(function() {
  index.treeattach($('right__index__tree'));
});

// Disable right click
var message = "Right click disabled.";
function clickIE() {
  if (document.all) {
    (message);
    return false;
  }
}
function clickNS(e) {
  if (document.layers || (document.getElementById && !document.all)) {
    if (e.which == 2 || e.which == 3) {
      (message);
      return false;
    }
  }
}
function NoClick() {
  if (document.layers) {
    document.captureEvents(Event.MOUSEDOWN);
    document.onmousedown = clickNS;
  }
  else {
    document.onmouseup = clickNS;
    document.oncontextmenu = clickIE;
  }
  document.oncontextmenu = new Function("return false");
}
function Resize(id,w,h) {
  img = document.getElementById(id);
  if (img) {
    maxwidth = screen.width-100;
    maxheight= screen.heigth-50;
    ratio = h/w;
    if (w > maxwidth){
      w = maxwidth;
      h = w * ratio;
    }
    if (h > maxheight){
      h = maxheight;
      w = h / ratio;
    }
    img.width = w;
    img.height = h; 
  }  
}