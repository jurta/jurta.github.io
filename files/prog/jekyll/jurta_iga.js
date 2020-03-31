/*
 * jurta_iga.js -- Image GAllery support for http://www.jurta.org/
 * Copyright (C) 2003-2006  Juri Linkov <juri@jurta.org>
 * Version: 2006-03-01
 */

var igaImage = 0;

function igaImageNavigate(iAbs, iRel) {
    if (iRel == 0) {
        igaImage = iAbs;
    } else {
        igaImage = (igaImage + iRel + iga.images.length) % iga.images.length;
    }
    document.getElementById('igaImage').src = iga.images[igaImage].src;
}

function igaImageFirst() { igaImageNavigate(0,0) }
function igaImagePrev()  { igaImageNavigate(0,-1) }
function igaImageNext()  { igaImageNavigate(0,1) }
function igaImageLast()  { igaImageNavigate(iga.images.length-1,0) }

function igaImageSetSize(iWidth, iHeight) {
    document.getElementById('igaImage').width = iWidth;
    document.getElementById('igaImage').height = iHeight;
}

function igaWindowWidth() {
    if (window.innerWidth) {
        return window.innerWidth;
    } else if (document.documentElement.clientWidth) {
        return document.documentElement.clientWidth;
    } else {
        return document.body.clientWidth;
    }
}

function igaWindowHeight() {
    if (window.innerHeight) {
        return window.innerHeight;
    } else if (document.documentElement.clientHeight) {
        return document.documentElement.clientHeight;
    } else {
        return document.body.clientHeight;
    }
}

function igaImageFitToWindow() {
    var windowWidth  = igaWindowWidth();
    var windowHeight = igaWindowHeight();

    var imagewidth  = iga.images[igaImage].width;
    var imageheight = iga.images[igaImage].height;
    var imageratio  = imagewidth/imageheight;

    var newwidth  = imagewidth;
    var newheight = imageheight;

    var marginLeft = iga.marginLeft;
    var marginTop  = iga.marginTop;

    if (imagewidth > (windowWidth - marginLeft)) {
	newwidth = windowWidth - marginLeft;
	newheight = parseInt(newwidth / imageratio);
    }

    if (newheight > (windowHeight - marginTop)) {
	newheight = windowHeight - marginTop;
	newwidth = parseInt( newheight * imageratio);
    }

    igaImageSetSize(newwidth, newheight)
}

function igaImageFullSize() {
    igaImageSetSize(iga.images[igaImage].width, iga.images[igaImage].height)
}

/* Local Variables: */
/* mode: java */
/* time-stamp-format: "%:y-%02m-%02d" */
/* time-stamp-start: "Version: " */
/* time-stamp-end: "\n" */
/* End: */
