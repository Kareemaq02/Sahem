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

    const handleComplaintStatusChange = (selectedStsId) => { // Modify the function parameter to directly receive the selectedStsId
        setselectedStatus(selectedStsId);
        onComplaintStatusChange(selectedStsId);
    }


    return (
        <Paper sx={{ width: "100%", backgroundColor: 'transparent 85%' }} className="filterStyle stay" >
            <Box sx={{ width: '100%' }} textAlign="center" className="filterStyle">
                <div
                    ref={mapContainer}
                    className="map-container"
                    style={{ height: "20rem", width: '100%' }}
                />
            </Box>
            <br />
            <h4 dir="ltr">complaint types</h4>
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
                            {complaintType.strNameEn}
                        </MenuItem>
                    ))}
                </Select>
            </Box>
            <br />
            <h4 dir="ltr">Status</h4>
            <Divider />
            <br />
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap', p: 1 }}>
                {/* Replace the Stack with MultipleSelectCheckmarks */}
                <FormChipSelect
                    value={selectedStatus}
                    onChange={handleComplaintStatusChange} // Pass the handleComplaintStatusChange function as onChange prop
                    items={[
                        { label: 'Pending', value: 1, color: 'primary' },
                        { label: 'rejected', value: 2, color: 'error' },
                        { label: 'approved', value: 3, color: 'success' },
                        { label: 'scheduled', value: 4, color: 'primary' },
                        { label: 'in progress', value: 5, color: 'success' },
                        { label: 'waiting evaluation', value: 6, color: 'success' },
                        { label: 'completed', value: 7, color: 'success' },
                        { label: 're-filed', value: 8, color: 'success' },
                    ]}
                />
            </Box>
            <br />
            <h4 dir="ltr">Distance</h4>
            <Divider />
            <br />
            <Box sx={{ padding: 2, width: '100%', textAlign: 'center', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <FormSlider />
            </Box>
    </Paper>
  );
};

export default CustomFilter;