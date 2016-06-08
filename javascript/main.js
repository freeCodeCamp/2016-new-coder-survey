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
barCharts("IsReceiveDiabilitiesBenefits", "H4", "30", "40");
// HasServedInMilitary
barCharts("HasServedInMilitary", "H4", "30", "40");
// Age
barCharts("Age" ,"H5", "5", "5"); //4 (15)
// SchoolDegree
barCharts("SchoolDegree", "H4d", "255", "60");
// SchoolMajor
barCharts("SchoolMajor", "H4d", "175", "60");
// MaritalStatus
barCharts("MaritalStatus", "H5", "5", "5");
// HasChildren
barCharts("HasChildren", "H5", "5", "5");
// ChildrenNumber
barCharts("ChildrenNumber", "H5", "5", "5");
// Income
barCharts("Income","H4", "140", "45"); //5 (15)
// DebtAmount //BUG FIX! WHERE IS DebtAmount???
barCharts("HasDebt","H5", "5", "5"); //2
// HasFinancialDependents
barCharts("HasFinancialDependents","H5", "5", "5"); //2
// HasStudentDebt
barCharts("HasStudentDebt","H5", "5", "5"); //2
// StudentDebtOwe
barCharts("StudentDebtOwe","H4", "140", "45"); //5 (15)
// FinanciallySupporting
barCharts("FinanciallySupporting","H5", "5", "5"); //2 SOME BUG! WHY NOTHING???
// HasHomeMortgage
barCharts("HasHomeMortgage","H5", "5", "5"); //2
// HomeMortgageOwe
barCharts("HomeMortgageOwe","H4", "145", "45"); //5 (15)
// HasHighSpdInternet
barCharts("HasHighSpdInternet","H4", "35", "45"); //2
// IsSoftwareDev
barCharts("IsSoftwareDev", "H5", "5", "5"); //2
// JobRelocateYesNo
barCharts("JobRelocateYesNo", "H5", "5", "5"); //2
// IsUnderEmployed
barCharts("IsUnderEmployed","H5", "5", "5"); //2
// EmploymentStatus
barCharts("EmploymentStatus","H4d", "244", "60"); //10
// EmploymentField
barCharts("EmploymentField","H4d", "240", "60"); //15
// CountryLive
barCharts("CountryLive", "H4d", "165", "60"); //15
// IsEthnicMinority
barCharts("IsEthnicMinority","H5", "5", "5"); //2
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
barCharts("ExpectedEarning","H4", "140", "45"); //5 (15)
// BootcampYesNo
barCharts("BootcampYesNo","H4", "40", "45"); //2
// BootcampFinish
barCharts("BootcampFinish", "H5", "5", "5"); //2
// BootcampName
barCharts("BootcampName", "H4d", "200", "60");
// BootcampMonthsAgo 
barCharts("BootcampMonthsAgo", "H4", "100", "45"); //4 (15)
// BootcampRecommend 
barCharts("BootcampRecommend", "H5", "5", "5");
// BootcampFullJobAfter
barCharts("BootcampFullJobAfter", "H5", "5", "5");
// BootcampPostSalary 
barCharts("BootcampPostSalary","H4", "140", "45"); //5 (15)
// BootcampLoan 
barCharts("BootcampLoan","H5", "5", "5"); //2
// MonthsProgramming 
barCharts("MonthsProgramming","H4", "110", "45"); //3
// HoursLearning 
barCharts("HoursLearning","H4", "95", "45"); //3
// MoneyForLearning
barCharts("MoneyForLearning","H4", "125", "45"); //5 (15)
// Resources
barCharts("Resources","H4", "135", "45"); //15
// CodeEvent
barCharts("CodeEvent","H4d", "150", "60"); //15

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