$("document").ready(function(){
  var stickyNav = $("nav").offset().top;
  $(window).scroll(function() {
    if ($(window).scrollTop() > stickyNav){
      $("nav").addClass("sticky");
    }
    else {
      $("nav").removeClass("sticky");
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
});
