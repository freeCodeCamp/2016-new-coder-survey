/***
      Maps for 2016 New Coder Survey
      Author: Kris Gesling
      Contact: krisgesling@gmail.com
***/


/* CONFIGURATION */
var mapID = '#GenderMap';
var mapsData = './data/maps-data.json';
var worldJSON = './data/world-geo3-min.json';

// defines the [type, [breakpoints between colors for map fill], description for legend, [country.properties keys for global stats], [descriptors for global stats], [keys for tooltip stats if diff from global], [descriptors for tooltip stats]
var mapFill = {
  all: ['num', [20, 100, 500, 1000],'Number of survey respondents per country of citizenship.', ['North America', 'Europe', 'Asia', 'South America', 'Africa', 'Oceania'], ['North America', 'Europe', 'Asia', 'South America', 'Africa', 'Oceania'], ['citizen', 'nonCitizen'], ['Citizen', 'Non-Citizen']],
  gender: ['percent', [0.15,0.25,0.35,0.45],'Proportion of female, trans*, agender and genderqueer respondents.', ['male', 'female', 'ATQ', 'NR'], ['Male', 'Female', 'Trans*, Genderqueer or Agender', 'No response']],
  ethnicity: ['percent', [0.20,0.3,0.4,0.6], 'Proportion of respondents who are members of an ethnic minority in their country.', ['ethnicMajority', 'ethnicity'], ['Ethnic Majority', 'Ethnic minority']],
  age: ['num', [21, 25, 29, 33], 'Average age of respondents per country.', [0, 1, 2, 3, 4, 5], [' aged 0-21', ' aged 22-25', ' aged 26-29', ' aged 30-33', ' aged 34+', ' no response']]
    };
// Color assignment - remember to also change sass variables // TODO Shift all modifiable colors to JS
var colors = {
  all: {
    spectrum: ['#c9df8a','#77ab59','#36802d','#234d20', '#112610'],
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
    spectrum: ['#9777A8','#6B2A8F','#500A76','#3A0358','#1D002C'],
    female: '#FF1493',
    ATQ: '#FFFF00',
    male: '#000050',
    NR: '#fff'
  },
  ethnicity: {
    spectrum: ['#DE6862', '#FE0D00', '#B40900', '#640500', '#220200'],
    'ethnicity': '#640500',
    'ethnicMajority': '#DE6862'
  },
  age: {
    spectrum: ['#FFB86B','#FF9420','#E67800','#7F4200', '#170C00'],
    0: '#1f77b4',
    1: '#2ca02c',
    2: '#d62728',
    3: '#9467bd',
    4: '#bcbd22',
    5: '#fff'
  },
  NR: '#fff',
  water: '#add8e6',
  path: ['#333','0.2px'],
};

var activeGraph = 'all';
var width = 900;
var height = function(num) {
  if (!num) { num = width; }
  return num/7*4
};


function pieChart(dataSet, selector, chartColors) {
  // General use function to create a pie chart
  // config variables
  var pieWidth = 100;
  var outerRadius = pieWidth / 2;
  var innerRadius = 0;
  var color = d3.scale.category10();

  // drawing the chart
  var pie = d3.layout.pie();
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

function sizeChange() {
  var graphWidth = document.getElementById('GenderMap').offsetWidth;
  d3.select(mapID + ' g').attr('transform', 'scale(' + graphWidth/width + ")");
  d3.select(mapID + ' svg')
    .attr('height', height(graphWidth));
}
// END FUNCTION sizeChange

// TODO Change to if statement, reintegrate to parent function?
function fillToLegendConv(num) {
  switch (activeGraph) {
    case 'all':
      return num;
      break;
    case 'gender':
      return num * 100 + '%';
      break;
    default:
      return num;
  }
}
// END FUNCTION fillToLegendConv

function getBoundingBoxCenter(selection) {
    // get the DOM element from a D3 selection
    // you could also use "this" inside .each()
    var element = selection.node(),
        // use the native SVG interface to get the bounding box
        bbox = element.getBBox();
    // return the center of the bounding box
    return [bbox.x + bbox.width/2, bbox.y + bbox.height/2];
}

function renderMap() {
  d3.json(mapsData,function(graphData) {
    d3.json(worldJSON,function(json) {
      // pulls loaded data into worldJSON
      json.features.forEach(function(e,i,arr) {
        for (var key in graphData[e.properties.name]) {
          e.properties[key] = graphData[e.properties.name][key];
        }
      });
      var globalStats = {}
      for (var map in mapFill) {
        for (var j = 0; j < mapFill[map][3].length; j++) {
          globalStats[mapFill[map][3][j]] = 0;
        }
      }
      if (globalStats['North America'] == 0) {
        json.features.forEach(function(e,i,arr) {
          if (graphData[e.properties.name]) { globalStats[e.continent] += graphData[e.properties.name].total; }
        });
      }
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

      var svg = d3.select(mapID)
                  .append('svg')
                  .attr('width', '100%')
                  .attr('height', height(width))
                  .attr('id','gender-map-svg')
                  .style('background', colors.water)
                  .append('g')
                  .call(zoom)
                  .append('g');
      var legend = d3.select(mapID)
                     .append('div')
                     .attr('width', width + 'px')
                     .attr('id', 'map-legend')
                     .html('<p class="description">' + mapFill[activeGraph][2] + '</p>')

      // Create map legend colors and labels
      var legendColors = legend.append('div')
                     .attr('class','legend-colors');
      if (mapFill[activeGraph][0] === 'percent') {
        var legendText = ['0-' + mapFill[activeGraph][1][0] *100 + '%', mapFill[activeGraph][1][0] *100 +1 + '-' + mapFill[activeGraph][1][1] *100 + '%', mapFill[activeGraph][1][1] *100 +1 + '-' + mapFill[activeGraph][1][2] *100 + '%', mapFill[activeGraph][1][2] *100 +1 + '-' + mapFill[activeGraph][1][3] *100 + '%', mapFill[activeGraph][1][3] *100 +1 + '-100%'];
      } else if (mapFill[activeGraph][0] === 'num') {
        var legendText = ['0-' + mapFill[activeGraph][1][0], mapFill[activeGraph][1][0]+1 + '-' + mapFill[activeGraph][1][1], mapFill[activeGraph][1][1]+1 + '-' + mapFill[activeGraph][1][2], mapFill[activeGraph][1][2]+1 + '-' + mapFill[activeGraph][1][3], mapFill[activeGraph][1][3]+1 + '+'];
      }

      for (var i = 0; i < colors[activeGraph].spectrum.length; i++) {
        legendColors.append('div')
              .style('background', colors[activeGraph].spectrum[i])
              .text(legendText[i]);
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
                      var fillTest = (d.properties.female + d.properties.ATQ)/totalRespondents;
                      break;
                    case 'ethnicity':
                      var fillTest = d.properties.ethnicity / totalRespondents;
                      break;
                    case 'age':
                      var fillTest = parseInt(d.properties.avgAge);
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
              var graph = d3.select(mapID).node();
              var mousePos = d3.mouse(graph);
              mousePos[0] += window.innerWidth/10;
              mousePos[0] = mousePos[0] < (window.innerWidth/1.5) ? mousePos[0] : mousePos[0] - window.innerWidth/10 * 2;

              var displayName = d.properties.displayName ? d.properties.displayName : d.properties.name.replace(/([A-Z])/g, ' $1').trim();
              totalRespondents = d.properties.ATQ + d.properties.female + d.properties.male + d.properties.NR;
              totalRespondents = totalRespondents ? totalRespondents : 0;

              if (typeof(d.properties.ratio) === "undefined" || (activeGraph === 'age' && d.properties.totalAges == 0)) {
                // then custom message for no data
                var tooltipData = 'No respondents from '+displayName;
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
              d3.select('#tooltip').style('left', mousePos[0]+'px')
                .style('top', mousePos[1]+'px');
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
      sizeChange();
    });
  });
}
// END FUNCTION renderMap


/* PRIMARY CALLS */
renderMap('gender');


d3.select(window)
  .on("resize", sizeChange);

window.onload = function() {
  var tabs = document.getElementsByClassName('tab');
  for (var i = 0; i < tabs.length; i++) {
    var tab = tabs[i];
    tab.onclick = function() {
      document.getElementById('active-tab').removeAttribute('id');
      activeGraph = this.className.replace('tab ','');
      this.setAttribute('id','active-tab');
      d3.select(mapID).select('svg').remove();
      d3.select(mapID).select('div').remove();
      renderMap();
    }
  }
};
