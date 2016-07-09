$("document").ready(function(){
  $(".raw-data").hide();
  var stickyNav = $("nav").offset().top;
  $(window).scroll(function() {
    if ($(window).scrollTop() > stickyNav){
      $("nav").addClass("sticky");
      $("body").css("padding-top", $("nav").height());
    }
    else {
      $("nav").removeClass("sticky");
      $("body").css("padding-top", "0");
    }
  });
  $(".moveTo").on("click", function(){
    var clicked = $(this).attr('href');
    scrolling(clicked);
    return false;
  });
  function scrolling(clicked) {
    $('html, body').animate({
      scrollTop: $(clicked).offset().top - 80
    }, 100);
  }

  $(".get-raw-data").on("click", function(){
    $(".raw-data").fadeIn();
    return false;
  });
  $(".close").on("click", function(){
    $(".raw-data").fadeOut();
    return false;
  });

  // ---- For Bar Charts ---- //
  // ---------SCROLL--------- //  
  (function($) {
    /**
     * Copyright 2012, Digital Fusion
     * Licensed under the MIT license.
     * http://teamdf.com/jquery-plugins/license/
     *
     * @author Sam Sehnert
     * @desc A small plugin that checks whether elements are within
     *     the user visible viewport of a web browser.
     *     only accounts for vertical position, not horizontal.
     */
    $.fn.visible = function(partial) {

        var $t            = $(this),
            $w            = $(window),
            viewTop       = $w.scrollTop(), 
            viewBottom    = viewTop + $w.height(),
            _top          = $t.offset().top,
            _bottom       = _top + $t.height(),
            compareTop    = partial === true ? _bottom : _top,
            compareBottom = partial === true ? _top : _bottom;

      return ((compareBottom <= viewBottom) && (compareTop >= viewTop));

    };

  })(jQuery);

  var win = $(window);

  var allMods = $(".chart-graphic");

  // PRELOADER
  // preloader(ID) sets all containers to their expected height
  // so they don't change size on scroll when render bar charts  
  allMods.each(function(i, el) {
    var ID = $(el).attr('id');
    allBarCharts.preloader(ID);
  });

  // CHECK
  // render bar charts when they appear on screen
  win.scroll(function(event) {

    allMods.each(function(i, el) {
      var el = $(el);
      if (el.visible(true)) {
        var ID = $(el).attr('id');
        allBarCharts.check(ID);
      } 
    });

  });
  // ---------SCROLL-END----- //

  // RESIZE
  // rerender bar charts on window.resize
  win.resize(function() {
    allMods.each(function(i, el) {
      var ID = $(el).attr('id');
      allBarCharts.resize(ID);
    });
  });
});
