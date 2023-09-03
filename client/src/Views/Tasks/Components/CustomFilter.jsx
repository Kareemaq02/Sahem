import { Box, Divider, Select, Stack, Paper, MenuItem, Chip } from "@mui/material";
import { GetTaskType } from "../Service/GetTaskTypes";
import { useState, useEffect } from "react";
import FormChipSelect from "../../../Common/Components/UI/FormFields/FormChipSelect"


const CustomFilter = ({ onComplaintStatusChange, onComplaintTypesChange }) => {

    const [taskType, setTaskType] = useState([])
    const [selectedTaskTypes, setSelectedTaskTypes] = useState([]);
    const [selectedStatus, setSelectedStatus] = useState([]);


    useEffect(() => {
        // Fetch complaint types from the API and set them to state
        const fetchTaskTypes = async () => {
            try {
                const response = await GetTaskType();
                setTaskType(response.data); // Assuming the response contains an array of complaint types
            } catch (error) {
                console.error(error);
            }
        };

        fetchTaskTypes();
    }, []);

    const handleComplaintStatusChange = (selectedStsId) => {
        setSelectedStatus(selectedStsId);
        onComplaintStatusChange(selectedStsId);
    }

    const handleTaskTypesChange = (event) => {
        const selectedTypeId = event.target.value
        setSelectedTaskTypes(selectedTypeId);
        onComplaintTypesChange(selectedTypeId);
        console.log(selectedTypeId)
    };

    return (
        <Paper sx={{ width: "100%", backgroundColor: 'transparent 85%' }} className="filterStyle stay" >
            <Box sx={{ backgroundColor: "#f0f0f0", width: '100%', padding: 10 }} textAlign="center" className="filterStyle">
                <h2>Filter</h2>
            </Box>
            <br />
            <h4 dir="ltr">complaint types</h4>
            <Divider />
            <br />
            <Box sx={{ width: '100%', }} textAlign="center">
                <Select
                    multiple
                    value={selectedTaskTypes}
                    onChange={handleTaskTypesChange}
                    sx={{ width: "70%" }}
                    renderValue={(selected) => (
                        <Box sx={{ display: "flex", flexWrap: "wrap" }}>
                            {selected.map((taskTypeId) => {
                                const selectedTaskType = taskType.find((type) => type.intId === taskTypeId);
                                return (
                                    <Chip key={taskTypeId} label={selectedTaskType.strNameEn} style={{ margin: 2 }} />
                                );
                            })}

                        </Box>
                    )}
                >
                    {taskType.map((taskType) => (
                        <MenuItem key={taskType.intId} value={taskType.intId}>
                            {taskType.strNameEn}
                        </MenuItem>
                    ))}
                </Select>
            </Box>
            <br />
            <h4 dir="ltr">Status</h4>
            <Divider />
            <br />
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap', p: 1 }}>
                <FormChipSelect
                    value={selectedStatus}
                    onChange={handleComplaintStatusChange} // Pass the handleComplaintStatusChange function as onChange prop
                    items={[
                        { label: 'inactive', value: 1, color: 'primary' },
                        { label: 'in progress', value: 2, color: 'error' },
                        { label: 'wait evaluation', value: 3, color: 'success' },
                        { label: 'failed', value: 4, color: 'primary' },
                        { label: 'incomplete', value: 5, color: 'success' },
                        { label: 'completed', value: 6, color: 'success' },
                    ]}
                />
            </Box>
            <br />


        </Paper>
    );
};

export default CustomFilter;
