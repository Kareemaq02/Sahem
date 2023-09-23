import React, { useRef, useState, useEffect } from "react";
import {Box, Divider,Select, Stack, Paper, MenuItem,Chip,} from "@mui/material";
import FormSelect from "../../../Common/Components/UI/FormFields/FormSelect";
import FormChip from "../../../Common/Components/UI/FormFields/FormChip";
import FormSlider from "../../../Common/Components/UI/FormFields/FormSlider";
import FormChipSelect from "../../../Common/Components/UI/FormFields/FormChipSelect";
import GetComplaintTypes from "../Service/GetComplaintTypes";
import ComplaintMap from "./ComplaintMap";
import "../Style/style.css";
import "./ComplaintMap.css";

import mapboxgl, { Marker, Popup } from "mapbox-gl";
import GetPublicComplaintMarker from "../Service/GetPublicComplaintsMap";


const CustomFilter = ({  onComplaintTypesChange,  onComplaintStatusChange,  data,}) => {

console.log(data);

  mapboxgl.accessToken =
    "pk.eyJ1IjoiYWdyaWRiIiwiYSI6ImNsbDN5dXgxNTAxOTAza2xhdnVmcnRzbGEifQ.3cM2WO5ubiAjuWbpXi9woQ";

  const mapContainer = useRef(null);
  const map = useRef(null);
  const [lng, setLng] = useState(35.919952);
  const [lat, setLat] = useState(31.941391);
  const [zoom, setZoom] = useState(8);
  const [markerDetail, setMarkerDetails] = useState([]);

  useEffect(() => {
    if (map.current) return; // Prevent map from being initialized multiple times

    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [lng, lat],
      zoom: zoom,
    });
  }, []);

  useEffect(() => {
    if (!map.current || !data) return;

    // Dynamically create markers based on comDet

    data.map((complaint) => {
      const el = document.createElement("div");
      el.className = "marker";
      const imageData = complaint.imageData;

      el.style.width = "50px";
      el.style.height = "50px";

      const popupContent = document.createElement("div");
      popupContent.className = "popup-container";
      popupContent.innerHTML = `
          <div class="popup-content">
            <div class="popup-label">رقم البلاغ</div>
            <div class="popup-value">${complaint.intComplaintId}</div>
            <div class="popup-label">حالة البلاغ</div>
            <div class="popup-value">${complaint.strStatus}</div>
            <div class="popup-label">المستخدم</div>
            <div class="popup-value">${complaint.strUserName}</div>
            <div class="popup-label">تاريخ الأضافة</div>
            <div class="popup-value">${complaint.dtmDateCreated}</div>
          </div>
        `;

      const popup = new Popup({ offset: 25 }).setDOMContent(popupContent);

      new mapboxgl.Marker(el)
        .setLngLat([complaint.latLng.decLng, complaint.latLng.decLat])
        .setPopup(popup)
        .addTo(map.current);
    });
  }, [data]);


  const [complaintTypes, setComplaintTypes] = useState([]);
  const [selectedComplaintTypes, setSelectedComplaintTypes] = useState([]);
  const [selectedStatus, setselectedStatus] = useState([]);

  useEffect(() => {
    // Fetch complaint types from the API and set them to state
    const showMarkerDetails = async () => {
      const response = await GetPublicComplaintMarker();
      setMarkerDetails(response.data);
    };
    const fetchComplaintTypes = async () => {
      try {
        const response = await GetComplaintTypes();
        setComplaintTypes(response.data); // Assuming the response contains an array of complaint types
      } catch (error) {
        console.error(error);
      }
    };

    fetchComplaintTypes();
    showMarkerDetails();
  }, []);

  const handleComplaintTypesChange = (event) => {
    const selectedIds = event.target.value;
    setSelectedComplaintTypes(selectedIds);
    onComplaintTypesChange(selectedIds);
    console.log(selectedIds);
  };

  const handleComplaintStatusChange = (selectedStsId) => {
    setselectedStatus(selectedStsId);
    onComplaintStatusChange(selectedStsId);
  };

  return (
    <Paper sx={{ width: "100%", backgroundColor: "transparent 85%" }}className="filterStyle stay">
      <Box sx={{ width: "100%" }} textAlign="center" className="filterStyle">
        <div
          ref={mapContainer}
          className="map-container"
          style={{ height: "20rem", width: "100%" }}
        />
      </Box>
      <br />
      <h4 dir="rtl">انواع البلاغات</h4>
      <Divider />
      <br />
      <Box sx={{ width: "100%" }} textAlign="center">
        <Select
          multiple
          value={selectedComplaintTypes}
          onChange={handleComplaintTypesChange}
          sx={{ width: "70%" }}
          renderValue={(selected) => (
            <Box sx={{ display: "flex", flexWrap: "wrap" }}>
              {selected.map((complaintTypeId) => {
                const complaintType = complaintTypes.find((type) => type.intTypeId === complaintTypeId);
                return (        
                <Chip key={complaintTypeId} label={complaintType.strNameEn} style={{ margin: 2 }} />
                );
              })}
            </Box>
          )}
        >
          {complaintTypes.map((complaintType) => (
            <MenuItem
              key={complaintType.intTypeId}
              value={complaintType.intTypeId}
            >
              {complaintType.strNameAr}
            </MenuItem>
          ))}
        </Select>
      </Box>
      <br />
      <h4 dir="rtl">الحالة</h4>
      <Divider />
      <br />
      <Box sx={{width: "100%", textAlign: "center",display: "flex",flexWrap: "wrap",p: 1,}}>
        {/* Replace the Stack with MultipleSelectCheckmarks */}
        <FormChipSelect
          value={selectedStatus}
          onChange={handleComplaintStatusChange} // Pass the handleComplaintStatusChange function as onChange prop
          items={[
            { label: "قيد الانتظار", value: 1, color: "primary" },
            { label: "مرفوض", value: 2, color: "#F44336" },
            { label: "موافق عليه", value: 3, color: "#4CAF50" },
            { label: "مجدول", value: 4, color: "#3F51B5" },
            { label: "قيد العمل", value: 5, color: "blue" },
            { label: "بانتظار التقييم", value: 6, color: "#9C27B0" },
            { label: "منجز", value: 7, color: "#8BC34A" },
            { label: "معاد", value: 8, color: "#FFC107" },
          ]}
        />
      </Box>
      <br />
    </Paper>
  );
};

export default CustomFilter;
