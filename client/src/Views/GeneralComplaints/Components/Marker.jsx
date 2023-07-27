import React, { useState, useEffect } from 'react';
import mapboxgl from 'mapbox-gl';

const Marker = ({ map, latitude, longitude, complaintData }) => {
  const [popup, setPopup] = useState(null);

  useEffect(() => {
    const marker = new mapboxgl.Marker()
      .setLngLat([longitude, latitude])
      .addTo(map);

    marker.getElement().addEventListener('click', () => {
      const newPopup = new mapboxgl.Popup()
        .setLngLat([longitude, latitude])
        .setHTML(`<h3>${complaintData.strUserName}</h3><p>${complaintData.strComment}</p>`)
        .addTo(map);

      setPopup(newPopup);
    });

    return () => marker.remove();
  }, [map, latitude, longitude, complaintData]);

  useEffect(() => {
    return () => {
      if (popup) {
        popup.remove();
      }
    };
  }, [popup]);

  return null;
};

export default Marker;
