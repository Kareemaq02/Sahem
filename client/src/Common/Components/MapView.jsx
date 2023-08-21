import React, { useRef, useEffect, useState } from "react";
import mapboxgl, { Marker } from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";
import mapboxgl from 'mapbox-gl';

mapboxgl.accessToken =
  "pk.eyJ1IjoiYWdyaWRiIiwiYSI6ImNsbDN5dXgxNTAxOTAza2xhdnVmcnRzbGEifQ.3cM2WO5ubiAjuWbpXi9woQ";

function App() {
  const mapContainer = useRef(null);
  const map = useRef(null);
  const [lng, setLng] = useState( 35.850662);
  const [lat, setLat] = useState(31.941469);
  const [zoom, setZoom] = useState(9);
  useEffect(() => {
    if (map.current) return; 
    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: "mapbox://styles/mapbox/light-v11",
      center: [lng, lat],
      zoom: zoom,
    });
    new Marker().setLngLat([lng, lat]).addTo(map.current);
  });

  return (
    <div>
      <div
        ref={mapContainer}
        style={{ height: "100rem", width: "100rem", margin: "auto" }}
      />
    </div>
  );
}

export default App;