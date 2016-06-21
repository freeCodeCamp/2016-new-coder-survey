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

// All Topics(in same order as in HTML)
// Gender
barCharts("Gender", "H4", "65", "45");
// FinanciallySupporting
barCharts("IsReceiveDiabilitiesBenefits", "H4", "35", "45");
// HasServedInMilitary
barCharts("HasServedInMilitary", "H4", "35", "45");
// Age
barCharts("Age" ,"H4", "75", "45"); //4
// SchoolDegree
barCharts("SchoolDegree", "H4d", "225", "60");
// SchoolMajor
barCharts("SchoolMajor", "H4d", "175", "60");
// MaritalStatus
barCharts("MaritalStatus", "H4", "165", "45");
// HasChildren
barCharts("HasChildren", "H4", "35", "45");
// ChildrenNumber
barCharts("ChildrenNumber", "H4", "35", "45");
// Income
barCharts("Income","H4", "95", "45"); //5
// HasDebt
barCharts("HasDebt","H4", "35", "45"); //2
// HasFinancialDependents
barCharts("HasFinancialDependents","H4", "35", "45"); //2
// HasStudentDebt
barCharts("HasStudentDebt","H4", "35", "45"); //2
// StudentDebtOwe
barCharts("StudentDebtOwe","H4", "90", "45"); //5
// FinanciallySupporting
barCharts("FinanciallySupporting","H4", "35", "45"); //2
// HasHomeMortgage
barCharts("HasHomeMortgage","H4", "35", "45"); //2
// HomeMortgageOwe
barCharts("HomeMortgageOwe","H4", "95", "45"); //5
// HasHighSpdInternet
barCharts("HasHighSpdInternet","H4", "35", "45"); //2
// IsSoftwareDev
barCharts("IsSoftwareDev", "H4", "35", "45"); //2
// JobRelocateYesNo
barCharts("JobRelocateYesNo", "H4", "35", "45"); //2
// IsUnderEmployed
barCharts("IsUnderEmployed","H4", "35", "45"); //2
// EmploymentStatus
barCharts("EmploymentStatus","H4d", "220", "60"); //10
// EmploymentField
barCharts("EmploymentField","H4d", "190", "60"); //15
// CountryLive
barCharts("CountryLive", "H4d", "165", "60"); //15
// IsEthnicMinority
barCharts("IsEthnicMinority","H4", "35", "45"); //2
// CityPopulation
barCharts("CityPopulation","H4", "200", "45"); //3
// LanguageAtHome
barCharts("LanguageAtHome","H4d", "95", "60"); //15
// JobWherePref
barCharts("JobWherePref","H4", "180", "45"); //3
// JobPref
barCharts("JobPref", "H4", "170", "45");
// JobRoleInterest
barCharts("JobRoleInterest", "H4", "195", "50");
// JobApplyWhen
barCharts("JobApplyWhen","H4", "210", "45"); //5
// ExpectedEarning
barCharts("ExpectedEarning","H4", "95", "45"); //5
// BootcampYesNo (AttendedBootcamp)
barCharts("BootcampYesNo","H4", "35", "45"); //2 //AttendedBootcamp
// BootcampFinish
barCharts("BootcampFinish", "H4", "35", "45"); //2
// BootcampName
barCharts("BootcampName", "H4d", "200", "60");
// BootcampMonthsAgo 
barCharts("BootcampMonthsAgo", "H4", "100", "45"); //4
// BootcampRecommend 
barCharts("BootcampRecommend", "H4", "35", "45");
// BootcampFullJobAfter
barCharts("BootcampFullJobAfter", "H4", "35", "45");
// BootcampPostSalary 
barCharts("BootcampPostSalary","H4", "95", "45"); //5
// BootcampLoan 
barCharts("BootcampLoan","H4", "35", "45"); //2
// MonthsProgramming 
barCharts("MonthsProgramming","H4", "110", "45"); //3
// HoursLearning 
barCharts("HoursLearning","H4", "95", "45"); //3
// MoneyForLearning
barCharts("MoneyForLearning","H4", "70", "45"); //5
// Resources
barCharts("Resources","H4", "135", "45"); //15
// CodeEvent
barCharts("CodeEvent","H4d", "150", "60"); //15
});