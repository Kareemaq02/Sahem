import React, { useRef, useEffect, useState } from "react";
import mapboxgl, { Marker, Popup } from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";
import { Box } from "@mui/material";
import "./Map_Tasks.css";

mapboxgl.accessToken =
  "pk.eyJ1IjoiYWdyaWRiIiwiYSI6ImNsbDN5dXgxNTAxOTAza2xhdnVmcnRzbGEifQ.3cM2WO5ubiAjuWbpXi9woQ";

function App() {
  const mapContainer = useRef(null);
  const map = useRef(null);
  const [lat, setLat] = useState(31.952912);
  const [lng, setLng] = useState(35.910861);
  const [zoom, setZoom] = useState(11);
  const geojson = {
    'type': 'FeatureCollection',
    'features': [
    {
    'type': 'Feature',
    'properties': {
    'message': 'Foo',
    'iconSize': [60, 60]
    },
    'geometry': {
    'type': 'Point',
    'coordinates': [lng, lat]
    }
    },
    {
    'type': 'Feature',
    'properties': {
    'message': 'Bar',
    'iconSize': [50, 50]
    },
    'geometry': {
    'type': 'Point',
    'coordinates': [35.875612, 31.957211]
    }
    },
    ]
    };

  useEffect(() => {
    if (map.current) return; // initialize map only once
    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: "mapbox://styles/mapbox/light-v11",
      center: [lng, lat],
      zoom: zoom,
    });


    for (const marker of geojson.features) {
        const el = document.createElement('div');
        const width = marker.properties.iconSize[0];
        const height = marker.properties.iconSize[1];
        el.className = 'marker';
        el.style.backgroundImage = `url(https://placekitten.com/g/${width}/${height}/)`;
        el.style.width = `${width}px`;
        el.style.height = `${height}px`;
        el.style.backgroundSize = '100%';

    // Create a custom popup content
    const popupContent = document.createElement("div");
    popupContent.className = "popup-container";

    popupContent.innerHTML = `
    <div class="popup-image" style="border-color: ${(marker.properties.message)};">
    <img src="URL_OF_YOUR_IMAGE" alt="Marker Image" />
  </div>
  <div class="popup-divider"></div>
  <div class="popup-content">
    <!-- ... rest of the content -->
  </div>
      <div class="popup-divider"></div>
      <div class="popup-content">
        <div class="popup-label">رقم البلاغ</div>
        <div class="popup-value">Value 1</div>
        <div class="popup-label">حالة البلاغ</div>
        <div class="popup-value">Value 2</div>
        <div class="popup-label">المستخدم</div>
        <div class="popup-value">Value 3</div>
        <div class="popup-label">تاريخ الأضافة</div>
        <div class="popup-value">Value 4</div>
      </div>
    `;

    // Create a popup
    const popup = new Popup({ offset: 25 }).setDOMContent(popupContent);

    // Add the marker element to the map with popup
    new mapboxgl.Marker(el)
      .setLngLat(marker.geometry.coordinates)
      .setPopup(popup) // Set the popup
      .addTo(map.current);
  }
    }, [lng, lat, zoom, geojson]);

  return (
    <Box
      display="flex"
      justifyContent="center"
      alignItems="center"
      height="95%"
      width="100%"
    >
      <div ref={mapContainer} style={{ height: "100%", width: "100%" }} />
    </Box>
  );
}

export default App;
