import React, { useRef, useEffect, useState } from "react";
import { Box, Divider, Select, Stack, Paper } from "@mui/material";
import mapboxgl from "mapbox-gl";
import FormSelect from "../../../Common/Components/UI/FormFields/FormSelect";
import FormChip from "../../../Common/Components/UI/FormFields/FormChip";
import FormSlider from "../../../Common/Components/UI/FormFields/FormSlider";

mapboxgl.accessToken =
  "pk.eyJ1IjoiYWdyaWRiIiwiYSI6ImNsbDN5dXgxNTAxOTAza2xhdnVmcnRzbGEifQ.3cM2WO5ubiAjuWbpXi9woQ";

const CustomFilter = () => {
  const mapContainer = useRef(null);
  const map = useRef(null);
  const [lng, setLng] = useState(35.919952);
  const [lat, setLat] = useState(31.941391);
  const [zoom, setZoom] = useState(10);

  useEffect(() => {
    if (map.current) return; 
    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [lng, lat],
      zoom: zoom,
    });
  });

  return (
    <Paper sx={{ width: "100%", backgroundColor: "transparent" }}>
      <div
        ref={mapContainer}
        className="map-container"
        style={{ height: "20rem" }}
      />
      <br />
      <h4 dir="ltr">complaint types</h4>
      <Divider />
      <br />
      <Box sx={{ width: "100%" }} textAlign="center">
        <Select sx={{ width: "100%" }} />
      </Box>
      <br />
      <h4 dir="ltr">Status</h4>
      <Divider />
      <br />
      <Box
        sx={{
          width: "100%",
          textAlign: "center",
          display: "flex",
          flexWrap: "wrap",
        }}
      >
        <Stack direction="row" spacing={1} gap={1}>
          <FormChip label="Approved" color="primary" />
          <FormChip label="pending" color="success" />
          <FormChip label="Completed" color="success" />
          <br />
          <br />
        </Stack>
        <Stack direction="row" spacing={1} gap={1}>
          <FormChip label="demo" color="primary" />
          <FormChip label="demo" color="success" />
        </Stack>
      </Box>
      <br />
      <h4 dir="ltr">Distance</h4>
      <Divider />
      <br />
      <Box
        sx={{
          padding: 2,
          width: "100%",
          textAlign: "center",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <FormSlider />
      </Box>
    </Paper>
  );
};

export default CustomFilter;