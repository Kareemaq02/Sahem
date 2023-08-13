import { Paper, Typography, Box, Divider, Switch } from "@mui/material";
import { useState } from "react";



const CustomFilter = ({ onFilterChange }) => {

    const handleVerifiedSwitchChange = (event) => {
        onFilterChange("verified", event.target.checked); 
    };

    const handleBlacklistedSwitchChange = (event) => {
        onFilterChange("blacklisted", event.target.checked);
    };

    return (
        <Paper sx={{ bgcolor: 'transparent' }}>
            <Box sx={{ backgroundColor: "#f0f0f0", width: '100%', padding: 10 }} textAlign="center">
                <h2 style={{ fontSize: "36px" }}>Filters</h2>
            </Box>
            <br />
            <Typography variant="h4"> Show Only Verified </Typography>
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap' }}>
                <Switch onChange={handleVerifiedSwitchChange} />

            </Box>
            <br />
            <br />
            <Divider />
            <Typography variant="h4"> Show Only Blacklisted </Typography>
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap' }}>
                <Switch onChange={handleBlacklistedSwitchChange} />

            </Box>
            <br />
            <br />
        </Paper>
    )
}


export default CustomFilter;