/*jslint bitwise: true, eqeqeq: true, immed: true, newcap: true, nomen: false,
 onevar: false, plusplus: false, regexp: true, undef: true, white: true, indent: 2
 browser: true */

/*global jQuery: true Drupal: true window: true */

(function ($) {
  /**
   * custom object is created if it doesn't exist.
   */
  Drupal.behaviors.custom = Drupal.behaviors.custom || {};
  
  /**
  * Attach handler.
  */
  Drupal.behaviors.custom = {
    attach: function (context, settings) {

      //Drupal.behaviors.custom.positionFooter();
      $(window)
       //.scroll(Drupal.behaviors.custom.positionFooter)
       //.resize(Drupal.behaviors.custom.positionFooter);
    }
  };
  
  /**
   */
  Drupal.behaviors.custom.positionFooter = function() {
    var $footer = $("#section-footer");
    var footerHeight = $footer.height();
    var footerTop = ($(window).scrollTop()+$(window).height()-footerHeight)+"px";
    
    if ( ($(document.body).height()+footerHeight) < $(window).height()) {
      $footer.css({
        position: "absolute"
      }).animate({
        top: footerTop
      })
    } else {
      $footer.css({
        position: "static"
      })
    }
  };
})(jQuery);