import React from "react";
import { Box, Divider, Select, Stack, Paper } from "@mui/material";
import FormSelect from "../../../Common/Components/UI/FormFields/FormSelect"
import FormChip from "../../../Common/Components/UI/FormFields/FormChip"
import FormSlider from "../../../Common/Components/UI/FormFields/FormSlider"
const CustomFilter = () => {


    return (
        <Paper sx={{ width: "100%", backgroundColor: 'transparent' }}>
            <Box sx={{ backgroundColor: "#f0f0f0", width: '100%', padding: 10 }} textAlign="center">
                <h2>Here is the Map box</h2>
            </Box>
            <br />
            <h4 dir="ltr">complaint types</h4>
            <Divider />
            <br />
            <Box sx={{ width: '100%', }} textAlign="center">
                <Select sx={{ width: '100%' }} />

            </Box>
            <br />
            <h4 dir="ltr">Status</h4>
            <Divider />
            <br />
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap' }}>
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
            <Box sx={{padding:2 ,width: '100%', textAlign: 'center', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <FormSlider />
            </Box>


        </Paper>
    );
};

export default CustomFilter;
