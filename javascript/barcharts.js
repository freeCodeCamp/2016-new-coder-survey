// Author: SamAI (@SamAI-Software)
// http://samai-software.github.io/

var drawBarCharts = (function(data, place, totalWidth, leftMargin, rightMargin, topic, format) {

  ///////////////////////////////
  // -------- FORMATS -------- //
  ///////////////////////////////
  var formats = {
      //  H4 - labels & titles outside the bar (for short bars) //
      H4: {
        //bar value
        labels: {
          color: "#006400", //black //white //#006400
          position: {
            x: 5,
            y: 5,
            anchor: "" //"end" //"middle" //""
          }
        },
        //bar name
        titles: {
          color: "black", //black //white //#006400
          position: {
            x: -5,
            y: 5,
            anchor: "end" //"end" //"middle" //""
          }
        }
      },

      //  H5 - labels & titles inside the bar (for long bars) //
      H5: {
        // bar value
        labels: {
          color: "white", //black //white //#006400
          position: {
            x: -5,
            y: 5,
            anchor: "end" //"end" //"middle" //""
          }
        },
        //bar name
        titles: {
          color: "white", //black //white //#006400
          position: {
            x: 5,
            y: 5,
            anchor: "" //"end" //"middle" //""
          }
        }
      }
    }   

  ////////////////////////////////
  // -------- SETTINGS -------- //
  ////////////////////////////////
  var surveyDataSumm = data;
 
  // These are configurable variables //

  // -------- GENERAL SETTINGS -------- //
  var format = formats[format]; // ask about this line????????
  // var topic = topic;  // topic is passed value // ask about this line????????

  //List of variables and amount of bars
  var listOfTopics = {
    IsSoftwareDev: 2,
    JobPref: 5,
    JobRoleInterest: 9,
    JobRelocateYesNo: 2,
    Gender: 3,
    SchoolDegree: 10,
    SchoolMajor: 14,
    HasServedInMilitary: 2,
    FinanciallySupporting: 2,
    MaritalStatus: 2, //5
    HasChildren: 2,
    ChildrenNumber: 3 //14
  }

  var bars = {
    total: listOfTopics[topic] + 1, // n + 1 blank bar //(5) = 6 //ask about blank bar????????
    height: 25, // can be changed without problems
    padding: 5, // can be changed, but Y axis (left) might drift if displayed, so use it cautiously
    animation: {
      duration: 2000,
      delay: 50
    }
  };

  // -------- SPECIFIC SETTINGS -------- //
  var margin = {
      top: 20,
      right: rightMargin, // rightMargin is passed value
      bottom: 0,
      left: leftMargin // leftMargin is passed value
    },
    width = totalWidth - margin.left - margin.right, // totalWidth is passed value
    // width = "100%", //can't use "100%" because of left titles with const px size
    height = 20 - margin.top - margin.bottom + bars.total * (bars.height + bars.padding); //height generates automatically

  var xColumn = topic + "Perc"; // "Perc" is added because of special format of a current .csv file
  var yColumn = topic; // topic is passed value

  var yAxisLabel = "This is the best Y label ever"; // CSS .y.axis { display: none }

  var formatPercent = d3.format(".0%");

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

  function render() {
    console.log("function render() called")

    var svg = d3.select(place).append("svg")
      .attr("width", "100%")
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.csv(surveyDataSumm, type, function(error, data) {
      console.log("d3.csv called");

      // Hide Y ticks labels if the value is 0 and Y axis is displayed
      yAxis.tickFormat(function(d) {
        var val = 0;
        data.forEach(function(item) {
          if (item[yColumn] == d) val = item[xColumn];
        });
        return val == 0 ? "" : d;
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
          return i * bars.animation.delay
        })
        .attr("class", "bar")
        // .attr("x", 0) // for fancy animation
        .attr("width", function(d) {
          return ((x(d[xColumn])) / totalWidth) * 100 + "%";
          var test = 0;
        })
        .attr("y", function(d) {
          return (y(d[yColumn]) + bars.padding);
        })
        .attr("height", bars.height)
        .filter(function(d) {
          return d[yColumn] == 0;
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
          return i * bars.animation.delay + bars.animation.duration - 400
        })
        .text(function(d, i) {
          return formatPercent(d[xColumn])
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
            return "none"
          }
        })
        .style("text-anchor", format.labels.position.anchor)
        .filter(function(d) {
          return d[yColumn] == 0;
        }).remove();

      // Bar titles
      svg.selectAll(".text")
        .data(data)
        .enter()
        .append('text')
        .attr('class', 'barTitle')
        .text(function(d) {
          return d[yColumn]
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
          return d[yColumn] == 0;
        }).remove();

    });

    function type(d) {
      // d.Age = +d.Age; //is it necessary to convert or not????????
      return d;
    }
  }

  render();

  return {
    //API
  };

});

//  barCharts() prepares all variables to be passed into drawBarCharts()
var barCharts = (function(topic, format, leftMargin, rightMargin) {

  //data for bar charts
  var dataBC = './data/2016-New-Coder-Survey-Data-Summary.csv';

  /////////////////////////////////////////////////////////////////////////////////////
  // drawBarCharts(data, place, totalWidth, leftMargin, rightMargin, topic, format); //
  /////////////////////////////////////////////////////////////////////////////////////

  //place - DOM container                   //e.g. "#JobPref"
  //totalWidth - width of a DOM container   //e.g. "500"
  //leftMargin - adjust left titles in H4   //e.g. "200"
  //rightMargin - adjust right labels in H4 //e.g. "40"
  //topic - column name in .csv file        //e.g. "JobPref"
  //format - "H4"/"H5" https://files.gitter.im/SamAI-Software/UO6O/BarChartsHorizontal_H5H4.jpg

  drawBarCharts(dataBC, "#" + topic, $("#" + topic).width(), leftMargin, rightMargin, topic, format);

});


//examples how to call barCharts()
//barCharts("JobPref", "H4", "270", "50");
//barCharts("JobRelocateYesNo", "H5", "5", "5");
//barCharts("IsSoftwareDev", "H5", "5", "5");