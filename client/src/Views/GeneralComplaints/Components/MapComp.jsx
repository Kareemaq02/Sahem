import React, { useState, useEffect, useRef } from 'react';
import mapboxgl from 'mapbox-gl';
import axios from 'axios';
import Marker from './Marker'; 

const MAPBOX_ACCESS_TOKEN = process.env.REACT_APP_MAP_TOKEN;
mapboxgl.accessToken = MAPBOX_ACCESS_TOKEN;

const ComplaintsMap = () => {
  const [complaints, setComplaints] = useState([]);
  const mapContainerRef = useRef(null); 
  const mapRef = useRef(null); 

  useEffect(() => {
    fetchComplaints();
  }, []);

  const fetchComplaints = async () => {
    try {
      const response = await axios.get('api/complaints');
      setComplaints(response.data);
    } catch (error) {
      console.error('Error fetching complaints:', error);
    }
  };

  useEffect(() => {
    // Initialize the map
    if (!mapRef.current) {
      mapRef.current = new mapboxgl.Map({
        container: mapContainerRef.current,
        style: 'mapbox://styles/mapbox/streets-v11',
        center: [0, 0], 
        zoom: 2, 
      });
    }

    return () => mapRef.current.remove();
  }, []);

  return (
    <div>
      <div ref={mapContainerRef} style={{ width: '100%', height: '400px' }} />
      {complaints.map((complaint) => (
        <Marker
          key={complaint.intComplaintId}
          map={mapRef.current} 
          latitude={complaint.latLng.lat}
          longitude={complaint.latLng.lng}
          complaintData={complaint}
        />
      ))}
    </div>
  );
};

export default ComplaintsMap;
