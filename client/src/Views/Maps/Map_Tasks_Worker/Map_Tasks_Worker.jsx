import React, { useRef, useEffect, useState } from "react";
import mapboxgl, { Marker, Popup } from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";
import { Box } from "@mui/material";
import "./Map_Tasks_Worker.css";

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
    'coordinates': [35.957211, 31.875612] //1
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
    'coordinates': [35.875612, 31.957211] //2
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
    'coordinates': [35.959620, 31.956780] //3
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
    'coordinates': [35.956780, 31.959620] //4
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
    'coordinates': [35.958506, 31.959800] //5
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
    'coordinates': [35.959800, 31.958506] //6
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
    'coordinates': [35.920547, 31.908317] //7
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
    'coordinates': [35.908317, 31.920547] //8
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
    'coordinates': [35.884041, 31.894218] //9
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
    'coordinates': [35.894218, 31.884041] //10
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
    'coordinates': [35.894218, 31.977749]
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
    'coordinates': [35.958729, 31.977749] //11
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
    'coordinates': [35.977749, 31.958729] //12
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
    'coordinates': [35.966547, 31.953233] //13
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
    'coordinates': [35.953233, 31.966547] //14
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
    'coordinates': [35.932839, 31.936827] //15
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
    'coordinates': [35.936827, 31.932839] //16
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
    'coordinates': [35.975788, 31.964211] //17
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
    'coordinates': [35.964211, 31.975788] //18
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
    'coordinates': [35.990713, 31.993783] //19
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
    'coordinates': [35.993783, 31.990713] //20
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

    popupContent.innerHTML = `
  </div>
  <div class="popup-divider"></div>
  <div class="popup-content">
    <!-- ... rest of the content -->
  </div>
      <div class="popup-divider"></div>
      <div class="popup-content">
        <div class="popup-label">رقم البلاغ</div>
        <div class="popup-value">1253</div>
        <div class="popup-label">حالة البلاغ</div>
        <div class="popup-value">قيد الانتظار</div>
        <div class="popup-label">المستخدم</div>
        <div class="popup-value">Zeinab</div>
        <div class="popup-label">نوع البلاغ</div>
        <div class="popup-value">تجمعات المياه(لا يوجد تصريف)</div>
        <div class="popup-label">تاريخ الأضافة</div>
        <div class="popup-value">2023-08-13T00:00:00</div>
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
      <div ref={mapContainer} style={{ height: "100%", width: "100%",borderRadius: "5px"}} />
    </Box>
  );
}

export default App;
