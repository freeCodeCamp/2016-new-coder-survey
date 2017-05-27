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
            _top          = $t.offset().top+150, //+150 coz of css offset for nav
            _bottom       = _top + $t.height()-100, //-100 coz of css offset for nav
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
    allBarCharts.init(ID);
    allBarCharts.preloader(ID);
  });
  //preloaderMap sets the height of the map so DOM if fixed
  //for proper anchor when share links like https://.../#Podcast
  preloaderMap();

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
    preloaderMap();
    allMods.each(function(i, el) {
      var ID = $(el).attr('id');
      allBarCharts.resize(ID);
    });
  });

  (function(i,s,o,g,r,a,m){ i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
             (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
         m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-55446531-1', 'auto');
  ga('require', 'displayfeatures');
  ga('send', 'pageview');
});
