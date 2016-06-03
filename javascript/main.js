$("document").ready(function(){
  $(".raw-data").hide();
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

  $(".get-raw-data").on("click", function(){
    $(".raw-data").fadeIn();
    return false;
  });
  $(".close").on("click", function(){
    $(".raw-data").fadeOut();
    return false;
  });

barCharts("JobPref", "H4", "270", "50");
barCharts("JobRelocateYesNo", "H5", "5", "5");
barCharts("IsSoftwareDev", "H5", "5", "5");
barCharts("JobRoleInterest", "H4", "225", "50");
barCharts("Gender", "H4", "60", "40");
barCharts("SchoolDegree", "H4", "290", "40");
barCharts("SchoolMajor", "H4", "270", "40");
barCharts("HasServedInMilitary", "H4", "30", "40");
barCharts("FinanciallySupporting", "H4", "30", "40");
barCharts("MaritalStatus", "H5", "0", "0");
barCharts("HasChildren", "H5", "0", "0");
barCharts("ChildrenNumber", "H5", "0", "0");

// 01_IsSoftwareDev: 2,
// 02_JobPref: 5,
// 03_JobRoleInterest: 9,
// 06_JobRelocateYesNo: 2
// 51_MaritalStatus: 2(5),
// 52_HasChildren: 2,
// 53_ChildrenNumber: 3(14),

});