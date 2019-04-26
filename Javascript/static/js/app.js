// from data.js
var tableData = data;
var tbody = d3.select("tbody");
var button = d3.select("#filter-btn");

function buildTable(dataToRender) {
    tbody.html("")
    dataToRender.forEach(function(ufoData) {
        var row = tbody.append("tr");
        Object.entries(ufoData).forEach(function([key, value]) {
            var cell = tbody.append("td");
            cell.text(value);
        });
    });
}

buildTable(tableData);
console.log("ufo table rendered");

function handleClick() {
    d3.event.preventDefault();

    var inputDateElement = d3.select("#datetime");
    var inputDate = inputDateElement.property("value");

    var inputCityElement = d3.select("#city");
    var inputCity = inputCityElement.property("value");

    var inputStateElement = d3.select("#state");
    var inputState = inputStateElement.property("value");

    var inputCountryElement = d3.select("#country");
    var inputCountry = inputCountryElement.property("value");

    var inputShapeElement = d3.select("#shape");
    var inputShape = inputShapeElement.property("value");

    var filteredData = tableData;
    if (inputDate != "") {
        filteredData = filteredData.filter(ufoData => ufoData.datetime === inputDate);
    }
    if (inputCity != "") {
        filteredData = filteredData.filter(ufoData => ufoData.city === inputCity);
    }
    if (inputState != "") {
        filteredData = filteredData.filter(ufoData => ufoData.state === inputState);
    }
    if (inputCountry != "") {
        filteredData = filteredData.filter(ufoData => ufoData.country === inputCountry);
    }
    if (inputShape != "") {
        filteredData = filteredData.filter(ufoData => ufoData.shape === inputShape);
    }
    buildTable(filteredData);
}
button.on('click', handleClick);
