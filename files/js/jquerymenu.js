// Copied from jurta.org/sites/all/modules/jquerymenu/jquerymenu_no_animation.js
// $Id: jquerymenu_no_animation.js,v 1.4 2010/05/05 07:50:55 aaronhawkins Exp $
$( document ).ready(function() {
  $('ul.jquerymenu:not(.jquerymenu-processed)').addClass('jquerymenu-processed').each(function(){
    $(this).find("li.parent span.parent").click(function(){
      momma = $(this).parent();
      if ($(momma).hasClass('closed')){
        $(momma).removeClass('closed').addClass('open');
        $(this).removeClass('closed').addClass('open');
      }
      else{
        $(momma).removeClass('open').addClass('closed');
        $(this).removeClass('open').addClass('closed');
      }
    });
  });
});
