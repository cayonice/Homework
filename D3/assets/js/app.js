// @TODO: YOUR CODE HERE!
var svgWidth = 960;
var svgHeight = 500;

var margin = {
  top: 20,
  right: 40,
  bottom: 80,
  left: 60
};

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

// Create an SVG wrapper, append an SVG group that will hold our chart,
// and shift the latter by left and top margins.
var svg = d3
  .select(".scatter")
  .append("svg")
  .attr("width", svgWidth)
  .attr("height", svgHeight);

// Append an SVG group
var chartGroup = svg.append("g")
  .attr("transform", `translate(${margin.left}, ${margin.top})`);

// Retrieve data from the CSV file and execute everything below
d3.csv("assets/data/data.csv").then(function(data) {

  // parse data
  data.forEach(function(element) {
    element.poverty = +element.poverty;
    element.healthcare = +element.healthcare;
  });

  // xLinearScale function above csv import
  var xLinearScale = d3.scaleLinear()
    .domain([8, d3.max(data, d => d.poverty)])
    .range([0, width]);

  // Create y scale function
  var yLinearScale = d3.scaleLinear()
    .domain([4, d3.max(data, d => d.healthcare)])
    .range([height, 0]);

  // Create initial axis functions
  var bottomAxis = d3.axisBottom(xLinearScale);
  var leftAxis = d3.axisLeft(yLinearScale);

  // append x axis
  chartGroup.append("g")
      .attr("transform", `translate(0, ${height})`)
      .call(bottomAxis);

  // append y axis
  chartGroup.append("g")
      .call(leftAxis);

  // append initial circles + text blocks
  elemEnter = chartGroup.selectAll("circle")
    .data(data)
    .enter()
    .append("g")
    .attr("class", "node-group");

  elemEnter.append("circle")
    .attr("cx", d => xLinearScale(d.poverty))
    .attr("cy", d => yLinearScale(d.healthcare))
    .attr("r", 10)
    .attr("fill", "lightblue")
    .attr("opacity", "0.9");

  elemEnter.append("text")
    .text(d => d.abbr)
    .attr("fill", "white")
    .attr("text-anchor", "middle")
    .attr("font-size", 10)
    .attr("x", d => xLinearScale(d.poverty))
    .attr("y", d => yLinearScale(d.healthcare));

  // append x axis
  chartGroup.append("text")
    .attr("x", width / 2 - 40)
    .attr("y", height + 50)
    .classed("axis-text", true)
    .text("In Poverty (%)");

  // append y axis
  chartGroup.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left - 40)
    .attr("x", 0 - (height / 2) - 60)
    .attr("dy", "4em")
    .classed("axis-text", true)
    .text("Lacks Healthcare (%)");
});

