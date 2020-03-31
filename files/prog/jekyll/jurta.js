/*
 * Main JavaScript file for http://www.jurta.org/
 * Copyright (C) 2003-2006  Juri Linkov <juri@jurta.org>
 * Version: 2006-03-01
 */

/* Support category trees */

function toggleTree(o) {
    o.parentNode.className =
    (o.parentNode.className == "ctopen") ? "ctclosed" : "ctopen";
    return false;
}

function changeBodyColor(color, bgcolor) {
    document.body.style.backgroundColor = bgcolor;
    document.body.style.color = color;
    return false;
}

/* Local Variables: */
/* mode: java */
/* time-stamp-format: "%:y-%02m-%02d" */
/* time-stamp-start: "Version: " */
/* time-stamp-end: "\n" */
/* End: */
