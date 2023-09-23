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
    'iconSize': [50,50]
    },
    'geometry': {
    'type': 'Point',
    'coordinates': [35.9378, 31.967221] //1
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
    'coordinates': [35.9378, 31.967221]  //2
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
    'coordinates': [35.9541, 31.9396]  //3
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
    'coordinates': [35.9396, 31.9541] //4
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
    'coordinates': [35.756200, 31.959800] //5
    }
    },  
    {
    'type': 'Feature',
    'properties': {
    'message': 'Foo',
    'iconSize': [50,50]
    },
    'geometry': {
    'type': 'Point',
    'coordinates': [35.959800, 31.756200] //6
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
    'coordinates': [35.907521, 31.945040] //7
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
    'coordinates': [35.945040, 31.907521] //8
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
    'coordinates': [35.901976, 31.940798]  //9
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
    'coordinates': [35.909095, 31.901976] //10
    }
    },
    {
    'type': 'Feature',
    'properties': {
    'message': 'Foo',
    'iconSize': [50,50]
    },
    'geometry': {
    'type': 'Point',
    'coordinates': [35.930738, 31.950586]
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
    'coordinates': [35.930738, 31.980124] //11
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
    'coordinates': [35.980124, 31.930738] //12
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
    'coordinates': [35.905450, 31.933384] //13
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
    'coordinates':  [35.933384, 31.905450]//14
    }
    },  
    {
    'type': 'Feature',
    'properties': {
    'message': 'Foo',
    'iconSize': [50,50]
    },
    'geometry': {
    'type': 'Point',
    'coordinates': [36.942814, 32.0002] //15
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
    'coordinates': [35.0002, 31.942814] //16
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
    'coordinates': [35.998071, 31.998387] //17
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
    'coordinates': [35.998387, 31.998071] //18
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
    'coordinates': [35.006963, 32.846399] //19
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
    'coordinates': [35.846399, 32.006963] //20
     }
     },
    ]
    };

  useEffect(() => {
    if (map.current) return; // initialize map only once
    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [lng, lat],
      zoom: zoom,
    });


    for (const marker of geojson.features) {
      const el = document.createElement('div');
      const width = marker.properties.iconSize[0];
      const height = marker.properties.iconSize[1];
      el.className = 'marker';
      // el.style.backgroundImage = `url(https://placekitten.com/g/${width}/${height}/)`;
      el.style.width = `${width}px`;
      el.style.height = `${height}px`;
      el.style.backgroundSize = '100%';

      // Create a custom popup content
      const popupContent = document.createElement("div");
      popupContent.className = "popup-container";
    // <div class="popup-image" style="border-color: ${(marker.properties.message)};">
    // <img src="URL_OF_YOUR_IMAGE" alt="Marker Image" />
      popupContent.innerHTML = `

  </div>
  <div class="popup-divider"></div>
  <div class="popup-content">
    <!-- ... rest of the content -->
  </div>
  <div class="popup-divider"></div>
  <div class="popup-content">
    <div class="popup-label">رقم البلاغ</div>
    <div class="popup-value">16</div>
    <div class="popup-label">حالة البلاغ</div>
    <div class="popup-value">قيد الانتظار </div>
    <div class="popup-label">المستخدم</div>
    <div class="popup-value">Mohammed</div>
    <div class="popup-label">نوع البلاغ</div>
    <div class="popup-value">خط مياه مكسور/معطل</div>
    <div class="popup-label">تاريخ الأضافة</div>
    <div class="popup-value">2023-08-12T00:00:00</div>
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
      <div ref={mapContainer} style={{ height: "100%", width: "100%", borderRadius: "5px" }} />
    </Box>
  );
}

export default App;
