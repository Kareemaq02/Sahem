import React, { useRef, useState, useEffect } from "react";
import { Box, Divider, Select, Stack, Paper, MenuItem, Chip } from "@mui/material";
import FormSelect from "../../../Common/Components/UI/FormFields/FormSelect"
import FormChip from "../../../Common/Components/UI/FormFields/FormChip"
import FormSlider from "../../../Common/Components/UI/FormFields/FormSlider"
import FormChipSelect from "../../../Common/Components/UI/FormFields/FormChipSelect"
import GetComplaintTypes from "../Service/GetComplaintTypes";
import ComplaintMap from "./ComplaintMap"
import "../Style/style.css"
import mapboxgl from "mapbox-gl";

const CustomFilter = ({ onComplaintTypesChange, onComplaintStatusChange }) => {

    mapboxgl.accessToken =
        "pk.eyJ1IjoiYWdyaWRiIiwiYSI6ImNsbDN5dXgxNTAxOTAza2xhdnVmcnRzbGEifQ.3cM2WO5ubiAjuWbpXi9woQ";

    const mapContainer = useRef(null);
    const map = useRef(null);
    const [lng, setLng] = useState(35.919952);
    const [lat, setLat] = useState(31.941391);
    const [zoom, setZoom] = useState(10);

    useEffect(() => {
        if (map.current) return; // initialize map only once
        map.current = new mapboxgl.Map({
            container: mapContainer.current,
            style: "mapbox://styles/mapbox/streets-v12",
            center: [lng, lat],
            zoom: zoom,
        });
    });


    const handleMapMouseEnter = () => {
        document.body.classList.add("disable-scroll"); // Add a CSS class to disable scrolling
    };

    const handleMapMouseLeave = () => {
        document.body.classList.remove("disable-scroll"); // Remove the CSS class to enable scrolling
    };

    const [complaintTypes, setComplaintTypes] = useState([]);
    const [selectedComplaintTypes, setSelectedComplaintTypes] = useState([]);
    const [selectedStatus, setselectedStatus] = useState([])

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
    }


    return (
        <Paper sx={{ width: "100%", backgroundColor: 'transparent 85%', }} className="filterStyle stay" >
            <Box sx={{ width: '100%' }} textAlign="center" className="filterStyle">
                <div
                    ref={mapContainer}
                    className="map-container"
                    style={{ height: "20rem", width: '100%' }}
                    onMouseEnter={handleMapMouseEnter}
                    onMouseLeave={handleMapMouseLeave}
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
                    onChange={handleComplaintStatusChange} // Pass the handleComplaintStatusChange function as onChange prop
                    items={[
                        { label: 'قيد الانتظار', value: 1, color: 'primary', },
                        { label: 'مرفوض', value: 2, color: '#F44336' },
                        { label: 'موافق عليه', value: 3, color: '#4CAF50' },
                        { label: 'مجدول', value: 4, color: '#3F51B5' },
                        { label: 'قيد العمل', value: 5, color: 'blue' },
                        { label: 'بانتظار التقييم', value: 6, color: '#9C27B0' },
                        { label: 'منجز', value: 7, color: '#8BC34A' },
                        { label: 'معاد', value: 8, color: '#FFC107' },
                    ]}
                />
            </Box>

        </Paper>
    );
};

export default CustomFilter;
