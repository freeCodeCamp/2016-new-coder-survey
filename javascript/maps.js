/***
      Maps for 2016 New Coder Survey
      Author: Kris Gesling
      Contact: krisgesling@gmail.com
***/


/* CONFIGURATION */
var mapID = '#Map';
var mapsData = './data/maps-data.json';
var worldJSON = './data/world-geo3-min.json';
var minFillSize = 20;
var colorsDefault = ['#C4EDC7', '#6FCF75', '#39993F', '#185E1C', '#102A12']; //['#C4EDC7', '#6FCF75', '#39993F', '#185E1C', '#102A12']

// defines the [type, [breakpoints between colors for map fill], description for legend, [country.properties keys for global stats], [descriptors for global stats], [keys for tooltip stats if diff from global], [descriptors for tooltip stats]
var mapFill = {
  all: ['num', [20, 100, 500, 1000],'Number of new coders per country.', ['North America', 'Europe', 'Asia', 'South America', 'Africa', 'Oceania'], ['North America', 'Europe', 'Asia', 'South America', 'Africa', 'Oceania'], ['citizen', 'nonCitizen'], ['Citizen', 'Non-Citizen']],
  gender: ['percent', [0.1, 0.15, 0.2, 0.25], 'Proportion of female, trans*, agender and genderqueer new coders.', ['male', 'female', 'ATQ', 'NR'], ['Male', 'Female', 'Trans*, Genderqueer or Agender', 'No response']],
  ethnicity: ['percent', [0.1, 0.15, 0.2, 0.35], 'Proportion of new coders who are from an ethnic minority in their country.', ['ethnicMajority', 'ethnicity'], ['Ethnic Majority', 'Ethnic minority']],
  age: ['num', [24, 26, 28, 30], 'Average age of new coders per country.', [0, 1, 2, 3, 4, 5], [' - 0-25', ' - 25-26', ' - 27-28', ' - 29-30', ' - 31+', ' no response'], [0, 1, 2, 3, 4, 5], [' - 0-21', ' - 22-25', ' - 26-29', ' - 30-33', ' - 34+', ' no response']]
    };
// Color assignment
var colors = {
  all: {
    spectrum: colorsDefault,//['#c9df8a','#77ab59','#36802d','#234d20', '#112610'],
    Africa: '#17becf',
    Asia: '#ff7f0e',
    Europe: '#bcbd22',
    'North America': '#1f77b4',
    'South America': '#e377c2',
    Oceania: '#8c564b',
    citizen: '#c5b0d5',
    nonCitizen: '#d62728'
  },
  gender: {
    // spectrum: ['#E8C0DF', '#C167AE', '#8D357A', '#571649', '#270F21'],//['#D9A6DB', '#D266CD', '#BC23B5', '#93008D', '#550051'],//['#A777A8','#8B2A8F','#500A76','#3A0358','#1D002C'],
    spectrum: colorsDefault,
    female: colorsDefault[4], //'#FF1493',
    ATQ: colorsDefault[3], //'#FFFF00',
    male: colorsDefault[1], //'#000050',
    NR: '#fff'
  },
  ethnicity: {
    // spectrum: ['#F9CFD7', '#EF8096', '#B5435A', '#6F1C2C', '#321319'],//['#FFAEAE', '#FF4A4A', '#EE0000', '#AA0000', '#640000'],//['#DE6862', '#FE0D00', '#C40900', '#840500', '#220200'],
    spectrum: colorsDefault,
    'ethnicity': colorsDefault[4], //'#640500',
    'ethnicMajority': colorsDefault[1],//'#DE6862'
  },
  age: {
    // spectrum: ['#BECFE1', '#6589B1', '#36587F', '#18324E', '#0F1823'],//['#FFB86B','#FF9420','#E67800','#7F4200', '#170C00'],
    spectrum: colorsDefault,
    0: colorsDefault[0], //'#1f77b4',
    1: colorsDefault[1], //'#2ca02c',
    2: colorsDefault[2], //'#d62728',
    3: colorsDefault[3], //'#9467bd',
    4: colorsDefault[4], //'#bcbd22',
    5: '#fff'
  },
  NR: '#fff',
  water: '#fff',
  path: ['#333','0.2px'],
};

var width = 900;
var height = function(num) {
  if (!num) { num = width; }
  return num/7*4
};

/* FUNCTIONS */
function pieChart(dataSet, selector, chartColors) {
  // General use function to create a pie chart
  // config variables
  var pieWidth = 100;
  var outerRadius = pieWidth / 2;
  var innerRadius = 0;
  var color = d3.scale.category10();

  // drawing the chart
  var pie = d3.layout.pie()
              .sort(null);
  var arc = d3.svg.arc()
                  .innerRadius(innerRadius)
                  .outerRadius(outerRadius);
  var svg = d3.select(selector)
              .append('svg')
              .attr({
                width: pieWidth,
                height: pieWidth
              });
  var arcs = svg.selectAll('g.arc')
                .data(pie(dataSet))
                .enter()
                .append('g')
                .attr('class','arc')
                .attr('transform','translate(' + outerRadius + ', ' + outerRadius + ')');
  arcs.append('path')
      .attr('fill', function(d,i) {
        if (typeof(chartColors) !== 'object') {
          return color(i);
        } else {
          return chartColors[i];
        }
      })
      .attr('d',arc);
} // END pieChart function

function percentify(num,total) {
  // Just returns a number as a percentage oftype string
  var percent = Math.round( num / total * 100);
  if (percent < 10) {
    percent = Math.round( num / total * 1000) / 10;
  }
  return percent + '%';
}
// END FUNCTION percentify

function sizeChange(activeGraph) {
  if (!activeGraph) { activeGraph = 'all'; }
  var graphWidth = document.getElementById('Map').offsetWidth;
  d3.select('#' + activeGraph + '-map-svg g')
    .attr('transform', 'scale(' + graphWidth/width + ")");
  d3.select('#' + activeGraph + '-map-svg')
    .attr('height', height(graphWidth));
}
// END FUNCTION sizeChange

//preloaderMap sets the height of the map so DOM if fixed
//for proper anchor when share links like https://.../#Podcast
function preloaderMap() {
  var width = document.getElementById('Map').offsetWidth;
  var heightNew = height(width)+70; //70 for legend
  $('#Map').height(heightNew);
}

function renderMap(activeGraph, json, graphData) {
      // pulls loaded data into worldJSON
      json.features.forEach(function(e,i,arr) {
        for (var key in graphData[e.properties.name]) {
          e.properties[key] = graphData[e.properties.name][key];
        }
      });
      function zoomed() {
        svg.attr('transform','translate(' + d3.event.translate + ')scale(' + d3.event.scale + ')');
      }
      var totalRespondents = 0;
      // Rendering and display
      var projection = d3.geo.miller()
                             .scale(width/6)
                             .center([0,30])
      ;
      var path = d3.geo.path()
                       .projection(projection);

      var color = d3.scale.quantize()
                          .range([colors.gender.female, colors.gender.ATQ, colors.gender.male]);

      var zoom = d3.behavior.zoom()
                   .scale(1)
                   .scaleExtent([1,12])
                   .on('zoom', zoomed);


      var winWidth = window.innerWidth;
      if ( winWidth < 900 ) {
        var svg = d3.select(mapID)
                  .append('svg')
                  .attr('width', '100%')
                  .attr('height', height(width))
                  .attr('id', activeGraph + '-map-svg')
                  .style('background', colors.water)
                  .append('g');
      } else {
        var svg = d3.select(mapID)
                  .append('svg')
                  .attr('width', '100%')
                  .attr('height', height(width))
                  .attr('id', activeGraph + '-map-svg')
                  .style('background', colors.water)
                  .append('g')
                  .call(zoom)
                  .append('g');
      }

      var legend = d3.select(mapID)
                     .append('div')
                     .attr('width', width + 'px')
                     .attr('class', 'map-legend')
                     .attr('id', activeGraph + '-map-legend');


      // Create map legend colors and labels
      var legendColors = legend.append('div')
                     .attr('class','legend-colors');
      if (mapFill[activeGraph][0] === 'percent') {
        var legendText = ['0-' + mapFill[activeGraph][1][0] *100 + '%', mapFill[activeGraph][1][0] *100 +1 + '-' + mapFill[activeGraph][1][1] *100 + '%', mapFill[activeGraph][1][1] *100 +1 + '-' + mapFill[activeGraph][1][2] *100 + '%', mapFill[activeGraph][1][2] *100 +1 + '-' + mapFill[activeGraph][1][3] *100 + '%', mapFill[activeGraph][1][3] *100 +1 + '+%'];
      } else if (mapFill[activeGraph][0] === 'num') {
        var legendText = ['0-' + mapFill[activeGraph][1][0], mapFill[activeGraph][1][0]+1 + '-' + mapFill[activeGraph][1][1], mapFill[activeGraph][1][1]+1 + '-' + mapFill[activeGraph][1][2], mapFill[activeGraph][1][2]+1 + '-' + mapFill[activeGraph][1][3], mapFill[activeGraph][1][3]+1 + '+'];
      }

      for (var i = 0; i < colors[activeGraph].spectrum.length; i++) {
        legendColors.append('div')
              .style('background', colors[activeGraph].spectrum[i])
              .text(legendText[i]);
      }

      // Map description
      legend.append('p')
            .attr('class','description')
            .text(mapFill[activeGraph][2]);

      if (activeGraph !== "all") {
      legend.append('p')
            .attr('class', 'footnote')
            .text('For countries with at least 20 responses.')
      }

      svg.append('rect')
         .attr({
            class: 'overlay',
            width: width,
            height: height()
         });

            svg.selectAll('path')
               .data(json.features)
               .enter()
               .append('path')
               .attr('d', path)
               .attr('stroke', colors['path'][0])
               .attr('stroke-width', colors['path'][1])
               .attr('id', function(d) {
                 return d.id;
               })
                // Define country fill rules
               .style('fill', function(d){
                  totalRespondents = d.properties.ATQ + d.properties.female + d.properties.male + d.properties.NR;

                  switch (activeGraph) {
                    case 'all':
                      var fillTest = totalRespondents;
                      break;
                    case 'gender':
                      var fillTest = (totalRespondents < minFillSize) ? 'na' : (d.properties.female + d.properties.ATQ)/totalRespondents;
                      break;
                    case 'ethnicity':
                      var fillTest = (totalRespondents < minFillSize) ? 'na' : d.properties.ethnicity / totalRespondents;
                      break;
                    case 'age':
                      var fillTest = (totalRespondents < minFillSize) ? 'na' : parseInt(d.properties.avgAge);
                      break;
                  }

                  if (fillTest <= mapFill[activeGraph][1][0]) {
                    return colors[activeGraph].spectrum[0];
                  } else if (fillTest <= mapFill[activeGraph][1][1]) {
                    return colors[activeGraph].spectrum[1];
                  } else if (fillTest <= mapFill[activeGraph][1][2]) {
                    return colors[activeGraph].spectrum[2];
                  } else if (fillTest <= mapFill[activeGraph][1][3]) {
                    return colors[activeGraph].spectrum[3];
                  } else if (fillTest > mapFill[activeGraph][1][3]) {
                    return colors[activeGraph].spectrum[4];
                  } else {
                    return colors['NR'];
                  }
               })
            // Everything for tooltips
            .on('mouseover',function(d) {
              var scrollTop     = $(window).scrollTop(),
                elementOffset = $(mapID).offset().top,
                distance      = (elementOffset - scrollTop);
              var graph = d3.select(mapID).node();
              var mousePos = d3.mouse(graph);
              mousePos[0] += window.innerWidth/10;
              mousePos[0] = mousePos[0] < (window.innerWidth/2) ? mousePos[0] : mousePos[0] - 200;//window.innerWidth/4;

              var displayName = d.properties.displayName ? d.properties.displayName : d.properties.name.replace(/([A-Z])/g, ' $1').trim();
              totalRespondents = d.properties.ATQ + d.properties.female + d.properties.male + d.properties.NR;
              totalRespondents = totalRespondents ? totalRespondents : 0;

              if (typeof(d.properties.ratio) === "undefined" || (activeGraph === 'age' && d.properties.totalAges == 0)) {
                // then custom message for no data
                var tooltipData = 'No survey responses from '+displayName;
                d3.select('#em-graph')
                  .style('display','none');
              } else {
                // create pie chart and legend
                var tooltipChartItems = [];
                var tooltipChartColors = [];
                switch (activeGraph) {
                  case 'all':
                    var tooltipArrIndex = 5;
                    break;
                  default:
                    var tooltipArrIndex = 3;
                    break;
                }
                for (var i = 0; i < mapFill[activeGraph][tooltipArrIndex].length; i++) {
                  if (activeGraph == 'age') {
                    tooltipChartItems.push(d.properties.age[i]);
                  } else {
                    tooltipChartItems.push(d.properties[mapFill[activeGraph][tooltipArrIndex][i]]);
                  }
                  tooltipChartColors.push(colors[activeGraph][mapFill[activeGraph][tooltipArrIndex][i]]);
                }
                pieChart(tooltipChartItems, '#gender-graph', tooltipChartColors);
                var tooltipData = '<ul>';
                for (var i = 0; i < mapFill[activeGraph][tooltipArrIndex].length; i++) {
                  tooltipData += '<li style="color: ' + colors[activeGraph][mapFill[activeGraph][tooltipArrIndex][i]] + '"><span>' + percentify(tooltipChartItems[i], totalRespondents) + ' ' + mapFill[activeGraph][tooltipArrIndex + 1][i] + '</span></li>';
                }
                tooltipData += '</ul>';
              }

              d3.select('#tooltip-title')
                  .text(displayName + ' (' + totalRespondents + ')');
              d3.select('#gender-data')
                .html(tooltipData);

              if (winWidth < 900) {
                mousePos[0] = 20;
              }
              d3.select('#tooltip').style('left', mousePos[0]+'px')
                  .style('top', distance + mousePos[1] +'px');
              // Show tooltip
              d3.select('#tooltip').classed('hidden', false);
            })
            .on('mouseout', function() {
              // Hide tooltip
              d3.select('#tooltip').classed('hidden', true);
              d3.select('#gender-graph').select('svg').remove();
              d3.select('#em-graph').select('div').remove();
              d3.select('#em-data').select('ul').remove();
            });
            // END TOOLTIPS
      sizeChange(); // Dynamically resizes map after rendering

}
// END FUNCTION renderMap

/* PRIMARY CALLS */
/* Load JSON data */
d3.json(mapsData,function(graphData) {
  d3.json(worldJSON,function(geoData) {
    renderMap('all', geoData, graphData);
    renderMap('gender', geoData, graphData);
    renderMap('ethnicity', geoData, graphData);
    renderMap('age', geoData, graphData);
  });
});

d3.select(window).on("resize", sizeChange);

window.onload = function() {
  var tabs = document.getElementsByClassName('tab');
  for (var i = 0; i < tabs.length; i++) {
    var tab = tabs[i];
    tab.onclick = function() {
      var lastTab = document.getElementById('active-tab');
      var lastGraph = lastTab.innerHTML == 'Location' ? 'all' : lastTab.innerHTML;
      lastGraph = lastGraph.toLowerCase();
      lastTab.removeAttribute('id');
      var activeGraph = this.className.replace('tab ','');
      this.setAttribute('id','active-tab');
      d3.select('#' + lastGraph + '-map-svg').style('display','none');
      d3.select('#' + lastGraph + '-map-legend').style('display','none');
      d3.select('#' + activeGraph + '-map-svg').style('display','block');
      d3.select('#' + activeGraph+'-map-legend').style('display','block');
      sizeChange(activeGraph);
    }
  }
};
