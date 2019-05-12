// var newYorkCoords = [40.73, -74.0059];
// var mapZoomLevel = 12;

// Create the createMap function

  // Create a baseMaps object to hold the lightmap layer
  var link = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json";

// Perform an API call to the Citi Bike API to get station information. Call createMarkers when complete

  d3.json(link, function(data) {
    createFeatures(data.data.stations)
    console.log(data.data.stations)
  });

  // Initialize an array to hold bike markers
  var bikeStations = [];

  // Create the createMarkers function

  function createFeatures(stations) {
    console.log(stations);
    
    // Loop through the stations array
    // For each station, create a marker and bind a popup with the station's name
    stations.forEach(function(d) {
      // console.log(d)
   
      

     // Pull the "stations" property off of response.data 
     // Add the marker to the bikeMarkers array
      bikeStations.push(

        L.marker([d.lat, d.lon]).bindPopup("<h1>" + d.name + "<hr>" + d.capacity +"</h1>"));
        // `<h1> ${d.name} <hr> ${d.capacity}</h1>`
      })
    console.log(bikeStations);
    
    createMap(bikeStations);

  }

function createMap(bikeStations) {
    // Create a layer group made from the bike markers array, pass it into the createMap function

  var cityLayer = L.layerGroup(bikeStations);

  // Create an overlayMaps object to hold the bikeStations layer
  var light = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
  attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
  maxZoom: 18,
  id: "mapbox.light",
  accessToken: API_KEY
  });

  var dark = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
  attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
  maxZoom: 18,
  id: "mapbox.dark",
  accessToken: API_KEY
  });

  var baseMaps = {
    Light: light,
    Dark: dark
  };

  var overlayMaps = {
    stations: cityLayer
    
  };

  // Create the map object with options

  var myMap = L.map("map-id", {
    center: [40.73, -74.0059],
    zoom: 12,
    layers: [light, cityLayer]
  });

  // Create a layer control, pass in the baseMaps and overlayMaps. Add the layer control to the map

L.control.layers(baseMaps, overlayMaps).addTo(myMap);

}
