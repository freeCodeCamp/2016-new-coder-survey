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

// 01_IsSoftwareDev: 2,
// 02_JobPref: 5,
// 03_JobRoleInterest: 9,
// 06_JobRelocateYesNo: 2
// 51_MaritalStatus: 2(5),
// 52_HasChildren: 2,
// 53_ChildrenNumber: 3(14),


// FinanciallySupporting: 2,




// All Topics(in same order as in HTML)
// Gender
barCharts("Gender", "H4", "60", "40");
// FinanciallySupporting
barCharts("FinanciallySupporting", "H4", "30", "40");
// HasServedInMilitary
barCharts("HasServedInMilitary", "H4", "30", "40");
// Age
// SchoolDegree
barCharts("SchoolDegree", "H4", "252", "45");
// SchoolMajor
barCharts("SchoolMajor", "H4", "175", "45");
// MaritalStatus
barCharts("MaritalStatus", "H5", "0", "0");
// HasChildren
barCharts("HasChildren", "H5", "0", "0");
// ChildrenNumber
barCharts("ChildrenNumber", "H5", "0", "0");
// Income
// DebtAmount
// HasFinancialDependents
// HasStudentDebt
// StudentDebtOwe
// HasFinancialDependents
// barCharts("HasFinancialDependents","H5","0","0");
// HasHomeMortgage
// HasHighSpdInternet
// IsSoftwareDev
barCharts("IsSoftwareDev", "H5", "5", "5");
// JobRelocateYesNo
barCharts("JobRelocateYesNo", "H5", "5", "5");
// IsUnderEmployed
// EmploymentStatus
// EmploymentField
// CountryLive
barCharts("CountryLive", "H4", "195", "45"); //15
// IsEthnicMinority
// CityPopulation
// LanguageAtHome
// JobWherePref
// JobPref
barCharts("JobPref", "H4", "170", "45");
// JobRoleInterest
barCharts("JobRoleInterest", "H4", "190", "45");
// JobApplyWhen
// ExpectedEarning
// BootcampYesNo
// BootcampFinish
barCharts("BootcampFinish", "H5", "5", "5"); //2
// BootcampName
barCharts("BootcampName", "H4", "195", "45");
// BootcampMonthsAgo 
barCharts("BootcampMonthsAgo", "H5", "5", "5");
// BootcampRecommend 
barCharts("BootcampRecommend", "H5", "5", "5");
// BootcampFullJobAfter
barCharts("BootcampFullJobAfter", "H5", "5", "5");
// BootcampPostSalary 
// BootcampLoan 
// MonthsProgramming 
// HoursLearning 
// MoneyForLearning
// Resources


// All Topics(in same order as in HTML)
// Gender
// FinanciallySupporting
// HasServedInMilitary
// Age
// SchoolDegree
// SchoolMajor
// MaritalStatus
// HasChildren
// ChildrenNumber
// Income
// DebtAmount
// HasFinancialDependents
// HasStudentDebt
// StudentDebtOwe
// FinanciallySupporting
// HasHomeMortgage
// HasHighSpdInternet
// IsSoftwareDev
// JobRelocateYesNo
// IsUnderEmployed
// EmploymentStatus
// EmploymentField
// CountryLive
// IsEthnicMinority
// CityPopulation
// LanguageAtHome
// JobWherePref
// JobPref
// JobRoleInterest
// JobApplyWhen
// ExpectedEarning
// BootcampYesNo
// BootcampFinish
// BootcampName
// BootcampMonthsAgo 
// BootcampRecommend 
// BootcampFullJobAfter
// BootcampPostSalary 
// BootcampLoan 
// MonthsProgramming 
// HoursLearning 
// MoneyForLearning
// Resources

});