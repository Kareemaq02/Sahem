import React, { useRef, useState, useEffect } from "react";
import { Box, Divider, Select, Stack, Paper, MenuItem, Chip } from "@mui/material";
import FormSelect from "../../../Common/Components/UI/FormFields/FormSelect"
import FormChip from "../../../Common/Components/UI/FormFields/FormChip"
import FormSlider from "../../../Common/Components/UI/FormFields/FormSlider"
import FormChipSelect from "../../../Common/Components/UI/FormFields/FormChipSelect"
import GetComplaintTypes from "../Service/GetComplaintTypes";
import ComplaintMap from "./ComplaintMap"
import "../Style/style.css"
import "./ComplaintMap.css"

import mapboxgl, { Marker, Popup } from "mapbox-gl";

const CustomFilter = ({ onComplaintTypesChange, onComplaintStatusChange, onSliderValueChange }) => {

    mapboxgl.accessToken =
        "pk.eyJ1IjoiYWdyaWRiIiwiYSI6ImNsbDN5dXgxNTAxOTAza2xhdnVmcnRzbGEifQ.3cM2WO5ubiAjuWbpXi9woQ";

    const mapContainer = useRef(null);
    const map = useRef(null);
    const [lng, setLng] = useState(35.919952);
    const [lat, setLat] = useState(31.941391);
    const [zoom, setZoom] = useState(8);

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
            style: "mapbox://styles/mapbox/streets-v12",
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

            const popup = new Popup({ offset: 25 }).setDOMContent(popupContent);

            new mapboxgl.Marker(el)
                .setLngLat(marker.geometry.coordinates)
                .setPopup(popup)
                .addTo(map.current);
        }

    });


    const [complaintTypes, setComplaintTypes] = useState([]);
    const [selectedComplaintTypes, setSelectedComplaintTypes] = useState([]);
    const [selectedStatus, setselectedStatus] = useState([])
    const [sliderValue, setSliderValue] = useState(30);

    useEffect(() => {
        // Fetch complaint types from the API and set them to state
        const fetchComplaintTypes = async () => {
            try {
                const response = await GetComplaintTypes();
                setComplaintTypes(response.data); // Assuming the response contains an array of complaint types
            } catch (error) {
                console.error(error);
            }
        };

        fetchComplaintTypes();
    }, [lng, lat, zoom, geojson]);


    const handleSliderChange = (event, newValue) => {
        setSliderValue(newValue);
        onSliderValueChange(newValue); 
    };


    const handleComplaintTypesChange = (event) => {
        const selectedIds = event.target.value;
        setSelectedComplaintTypes(selectedIds);
        onComplaintTypesChange(selectedIds);
        console.log(selectedIds);

    };

    const handleComplaintStatusChange = (selectedStsId) => {
        setselectedStatus(selectedStsId);
        onComplaintStatusChange(selectedStsId);
    }


    return (
        <Paper sx={{ width: "100%", backgroundColor: 'transparent 85%', }} className="filterStyle stay" >
            <Box sx={{ width: '100%' }} textAlign="center" className="filterStyle">
                <div
                    ref={mapContainer}
                    className="map-container"
                    style={{ height: "20rem", width: '100%' }}
                />
            </Box>
            <br />
            <h4 dir="rtl">انواع البلاغات</h4>
            <Divider />
            <br />
            <Box sx={{ width: '100%', }} textAlign="center">
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
                        <MenuItem key={complaintType.intTypeId} value={complaintType.intTypeId}>
                            {complaintType.strNameAr}
                        </MenuItem>
                    ))}
                </Select>
            </Box>
            <br />
            <h4 dir="rtl">الحالة</h4>
            <Divider />
            <br />
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap', p: 1 }}>
                {/* Replace the Stack with MultipleSelectCheckmarks */}
                <FormChipSelect
                    value={selectedStatus}
                    onChange={handleComplaintStatusChange}
                    items={[
                        { label: 'قيد الانتظار', value: 1, color: 'primary', },
                        { label: 'موافق عليه', value: 3, color: '#4CAF50' },
                        { label: 'مجدول', value: 4, color: '#3F51B5' },
                        { label: 'قيد العمل', value: 5, color: 'blue' },
                        { label: 'بانتظار التقييم', value: 6, color: '#9C27B0' },
                        { label: 'معاد', value: 8, color: '#FFC107' },
                    ]}
                />
            </Box>
            <h4 dir="rtl">  المسافة/كم</h4>
            <Divider />
            <br />
            <Box sx={{ padding: 2, width: '100%', textAlign: 'center', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <FormSlider value={sliderValue} onChange={handleSliderChange} />
            </Box>
        </Paper>
    );
};

export default CustomFilter;
