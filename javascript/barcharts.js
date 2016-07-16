// Author: SamAI (@SamAI-Software)
// http://samai-software.github.io/

var renderBarCharts = (function(data, place, totalWidth, leftMargin, rightMargin, topic, format, totalBars, xColumn, yColumn, special) {

  ///////////////////////////////
  // -------- FORMATS -------- //
  ///////////////////////////////
  var formats = {
      //  H4 - labels & titles outside the bar (for short bars)
      H4: {
        name: "H4",
        //bar value
        labels: {
          color: "black", // #006400 #008400 #7ED321
          position: {
            x: 5,
            y: 5,
            anchor: "" //"end" //"middle" //""
          }
        },
        //bar name
        titles: {
          color: "black",
          position: {
            x: -5,
            y: 5,
            anchor: "end" //"end" //"middle" //""
          }
        }
      },

      //  H4d - same as H4, but with decimal number (for very short bars)
      H4d: {
        name: "H4d",
        //bar value
        labels: {
          color: "black", // #006400 #008400 #7ED321
          position: {
            x: 5,
            y: 5,
            anchor: "" //"end" //"middle" //""
          },
          format: d3.format(".1%")
        },
        //bar name
        titles: {
          color: "black",
          position: {
            x: -5,
            y: 5,
            anchor: "end" //"end" //"middle" //""
          }
        }
      },

      //  H5 - labels & titles inside the bar (for long bars)
      H5: {
        name: "H5",
        // bar value
        labels: {
          color: "white",
          position: {
            x: -5,
            y: 5,
            anchor: "end" //"end" //"middle" //""
          }
        },
        //bar name
        titles: {
          color: "white",
          position: {
            x: 5,
            y: 5,
            anchor: "" //"end" //"middle" //""
          }
        }
      }
    };   

  ////////////////////////////////////////
  // ------------ SETTINGS ------------ //
  ////////////////////////////////////////
  // -These are configurable variables -//
  // -------- GENERAL SETTINGS -------- //
  var format = formats[format];

  var bars = {
    total: totalBars + 1, // n + 1 blank bar //(5) = 6
    height: 25, // can be changed without problems
    padding: 5, // can be changed, but Y axis (left) might drift if displayed, so use it cautiously
    animation: {
      duration: 2000,
      delay: 50
    }
  };

  // -------- SPECIFIC SETTINGS ------- //
  var margin = {
      top: 20,
      right: rightMargin, // rightMargin is passed value
      bottom: 0,
      left: leftMargin // leftMargin is passed value
    },
    width = totalWidth - margin.left - margin.right, // totalWidth is passed value
    // width = "100%", //can't use "100%" because of left titles with const px size
    height = 20 - margin.top - margin.bottom + bars.total * (bars.height + bars.padding); //height generates automatically

  var yAxisLabel = ""; // CSS .y.axis { display: none }

  var formatPercent = format.labels.format? format.labels.format : d3.format(".0%");

  var y = d3.scale.ordinal()
    .rangeRoundBands([height + 0, 0]);

  var x = d3.scale.linear()
    .range([0, width]);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")
    .outerTickSize(0)
    .tickFormat(formatPercent);

  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

  // preloader() sets all containers to their expected height
  // so they don't change size on scroll when render bar charts
  function preloader(place) {
    console.log("renderBarCharts.preloader() called");
    // +24 to fix bug, not sure where it comes from
    $(place).height(height+24);
  }

  function render() {
    console.log("renderBarCharts.render() called");

    // height "auto" to rewrite preloader to avoid bugs
    $(place).height("auto");

    var svg = d3.select(place).append("svg")
      .attr("width", "100%")
      .attr("height", height + margin.top + margin.bottom)
      .attr("class", format.name)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.csv(data, type, function(error, data) {
      console.log("d3.csv called");

      // Hide Y ticks labels if the value is 0 and Y axis is displayed
      yAxis.tickFormat(function(d) {
        var val = 0;
        data.forEach(function(item) {
          if (item[yColumn] == d) val = item[xColumn];
        });
        return val == 0 ? "" : d; // '=== 0' doesn't work, coz val might be not int
      });

      y.domain(data.map(function(d) {
        return d[yColumn];
      }).reverse());
      x.domain([0, d3.max(data, function(d) {
        return d[xColumn];
      })]);

      svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

      svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("x", -5)
        .attr("y", -20)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text(yAxisLabel);

      svg.selectAll(".bar")
        .data(data)
        .enter()
        .append("rect")
        .attr("width", 0)
        .attr("x", 0)
        // .attr("x", 800) // for fancy animation
        .transition().duration(bars.animation.duration)
        .delay(function(d, i) {
          return i * bars.animation.delay;
        })
        .attr("class", "bar")
        // .attr("x", 0) // for fancy animation
        .attr("width", function(d) {
          return ((x(d[xColumn])) / totalWidth) * 100 + "%";
        })
        .attr("y", function(d) {
          return (y(d[yColumn]) + bars.padding);
        })
        .attr("height", bars.height)
        .filter(function(d) {
          return d[xColumn] == 0; // '=== 0' doesn't work, coz xColumn not int
        }).remove();

      // Bar labels
      svg.selectAll(".text")
        .data(data)
        .enter()
        .append("text")
        .attr("class", "barLabel")
        .style("fill", "white") // fill: white; is not a good approach coz bckgr can be not white //NEED FIX
        .transition()
        .duration(300)
        .delay(function(d, i) {
          return i * bars.animation.delay + bars.animation.duration - 400;
        })
        .text(function(d, i) {
          return formatPercent(d[xColumn]);
        })
        .attr('x', function(d) {
          return ((x(d[xColumn]) + format.labels.position.x) / totalWidth) * 100 + "%";
        })
        .attr('y', function(d) {
          return y(d[yColumn]) + bars.height / 2 + format.labels.position.y + bars.padding;
        })
        .style("fill", format.labels.color)
        .style("display", function(d) {
          if (!x(d[xColumn])) {
            return "none";
          }
        })
        .style("text-anchor", format.labels.position.anchor)
        .filter(function(d) {
          return d[xColumn] == 0; // '=== 0' doesn't work, coz xColumn not int
        }).remove();

      // Bar titles
      svg.selectAll(".text")
        .data(data)
        .enter()
        .append('text')
        .attr('class', 'barTitle')
        .text(function(d) {
          return d[yColumn];
        })
        .attr('x', function(d) {
          return format.titles.position.x;
        })
        .attr('y', function(d) {
          return y(d[yColumn]) + bars.height / 2 + format.titles.position.y + bars.padding;
        })
        .style("fill", format.titles.color)
        .style("text-anchor", format.titles.position.anchor)
        .filter(function(d) {
          return d[xColumn] == 0; // '=== 0' doesn't work, coz xColumn not int
        }).remove();

    });

    function type(d) {
      // d.Age = +d.Age;
      return d;
    }
  }

  if (special == "preloader") {
    preloader(place);
  } else {
    render(place);
  }

  return {
    //API
  };

});

var allBarCharts = {

  init: function(ID) {
    this[ID] = false;
  },

  preloader: function(ID) {
    if (!this[ID]) { 
      prepareBarCharts(ID, "preloader")
    }
  },

  check: function(ID) {
    if (!this[ID]) { 
      this[ID] = true;
      prepareBarCharts(ID);
    }
  },

  resize: function(ID) {
    if (this[ID]) { 
      setTimeout(function() {
        //clean previous bar charts and render new
        $("#"+ID).html("");
        prepareBarCharts(ID);
      }, 1000);
    }
  }
};

//  prepareBarCharts() prepares all variables to be passed into renderBarCharts()
var prepareBarCharts = (function(topic, special) {

  // List of variables and settings
  // topic: [totalBars, format, leftMargin, rightMargin]
  var listOfTopics = {
    Age: [4, "H4", "70", "45"],//4,
    BootcampFinish: [2, "H4", "35", "45"], //2
    BootcampFullJobAfter: [2, "H4", "35", "45"],
    BootcampLoan: [2, "H4", "35", "45"], //2
    BootcampMonthsAgo: [4, "H4", "100", "45"], //4
    BootcampName: [15, "H4d", "200", "60"],
    BootcampPostSalary: [7, "H4", "95", "45"], //5
    BootcampRecommend: [2,  "H4", "35", "45"],
    BootcampYesNo: [2, "H4", "35", "45"], //2 //AttendedBootcamp
    ChildrenNumber: [3, "H4", "35", "45"],
    CityPopulation: [3, "H4", "200", "45"], //3
    CodeEvent: [14, "H4d", "175", "60"], //15
    CountryLive: [15, "H4d", "165", "60"], //15
    EmploymentField: [15, "H4d", "190", "60"], //15
    EmploymentStatus: [10, "H4d", "220", "60"], //10
    ExpectedEarning: [7, "H4", "95", "45"], //5
    FinanciallySupporting: [2, "H4", "35", "45"], //2
    Gender: [3, "H4", "70", "45"],
    HasChildren: [2,  "H4", "35", "45"],
    HasDebt: [2, "H4", "35", "45"], //2
    HasFinancialDependents: [2, "H4", "35", "45"], //2
    HasHighSpdInternet: [2, "H4", "35", "45"], //2
    HasHomeMortgage: [2, "H4", "35", "45"], //2
    HasServedInMilitary: [2, "H4", "35", "45"],
    HasStudentDebt: [2, "H4", "35", "45"], //2
    HomeMortgageOwe: [5, "H4", "95", "45"], //5
    HoursLearning: [3, "H4", "95", "45"], //3
    Income: [7, "H4", "95", "45"], //5
    IsEthnicMinority: [2, "H4", "35", "45"], //2
    IsReceiveDiabilitiesBenefits: [2, "H4", "35", "45"],
    IsSoftwareDev: [2,  "H4", "35", "45"], //2
    IsUnderEmployed: [2, "H4", "35", "45"], //2
    JobApplyWhen: [5, "H4", "210", "45"], //5
    JobPref: [5,  "H4", "170", "45"],
    JobRelocateYesNo: [2,  "H4", "35", "45"], //2
    JobRoleInterest: [9,  "H4", "195", "50"],
    JobWherePref: [3, "H4", "180", "45"], //3
    LanguageAtHome: [15, "H4d", "95", "60"], //15
    MaritalStatus: [2, "H4", "165", "45"],
    MoneyForLearning: [5, "H4", "70", "45"], //5
    MonthsProgramming: [3, "H4", "110", "45"], //3
    Podcast: [14, "H4d", "175", "60"], //14
    Resources: [15, "H4", "175", "45"], //15
    SchoolDegree: [10, "H4d", "225", "60"],
    SchoolMajor: [14, "H4d", "225", "60"],
    StudentDebtOwe: [5, "H4", "90", "45"], //5
  };

  ///////////////////////////////////////////////////////////
  // renderBarCharts(data, place, totalWidth,              //
  //               leftMargin, rightMargin, topic, format, //
  //               totalBars, xColumn, yColumn, special);  //
  ///////////////////////////////////////////////////////////

  //place       - DOM container             //e.g. "#JobPref"
  //totalWidth  - width of a DOM container  //e.g. "500"
  //leftMargin  - adjust left titles in H4  //e.g. "200"
  //rightMargin - adjust right labels in H4 //e.g. "40"
  //topic       - column name in .csv file  //e.g. "JobPref"
  //format      - "H4"/"H4d"/"H5"
  //https://files.gitter.im/SamAI-Software/UO6O/BarChartsHorizontal_H5H4.jpg
  //special     - define if call is preloader

  var dataBC      = './data/2016-New-Coder-Survey-Data-Summary.csv',
      place       = "#" + topic,
      totalWidth  = $("#" + topic).width(),
      xColumn     = topic + "Perc", // + "Perc" because of special format of a current .csv file
      yColumn     = topic,
      totalBars   = listOfTopics[topic][0],
      format      = listOfTopics[topic][1],
      leftMargin  = listOfTopics[topic][2],
      rightMargin = listOfTopics[topic][3],
      special     = special;

  renderBarCharts(dataBC, place, totalWidth, 
                  leftMargin, rightMargin, topic, format, 
                  totalBars, xColumn, yColumn, special);

});