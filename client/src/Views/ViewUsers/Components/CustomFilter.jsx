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
        <Paper sx={{ bgcolor: 'white', p:3, borderRadius:'25px'}}>
            <Typography variant="h3">اظهار المستخدمين الموثقين فقط</Typography>
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap' }}>
                <Switch onChange={handleVerifiedSwitchChange} />

            </Box>
            <br />
            <br />
            <Divider />
            <br />
            <br />
            <Typography variant="h3"> اظهار المستخدمين المحظورين فقط </Typography>
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap' }}>
                <Switch onChange={handleBlacklistedSwitchChange} />

            </Box>
            <br />
            <br />
        </Paper>
    )
}


export default CustomFilter;