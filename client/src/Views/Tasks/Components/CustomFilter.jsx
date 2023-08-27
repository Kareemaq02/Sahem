import { Box, Divider, Select, Stack, Paper, MenuItem, Chip, Typography } from "@mui/material";
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
        <Paper sx={{ width: "100%", backgroundColor: 'transparent 85%', borderRadius: '25px', p : 2 }} className="filterStyle stay" >
            <Typography dir="rtl" variant="h4" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>انواع المشاكل</Typography>
            <br />
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
                            {taskType.strNameAr}
                        </MenuItem>
                    ))}
                </Select>
            </Box>
            <br />
            <Typography variant="h4" dir="rtl" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>الحالة</Typography >
            <br />
            <Divider />
            <br />
            <Box sx={{ width: '100%', textAlign: 'center', display: 'flex', flexWrap: 'wrap', p: 1 }}>
                <FormChipSelect
                    value={selectedStatus}
                    onChange={handleComplaintStatusChange} // Pass the handleComplaintStatusChange function as onChange prop
                    items={[
                        { label: 'غير مفعل', value: 1, color: 'primary' },
                        { label: 'قيد العمل', value: 2, color: 'error' },
                        { label: 'انتظار التقييم', value: 3, color: 'success' },
                        { label: 'فشل', value: 4, color: 'primary' },
                        { label: 'غير مكتمل', value: 5, color: 'success' },
                        { label: 'منجز', value: 6, color: 'success' },
                    ]}
                />
            </Box>
            <br />


        </Paper>
    );
};

export default CustomFilter;
