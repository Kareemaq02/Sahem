import React, { useState } from "react";
import { Box, IconButton, useTheme, Stack, Typography, SwipeableDrawer, Divider, Button, Chip } from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { CheckCircleOutline } from "@mui/icons-material/";
import { GetTaskDetailsApi } from "../../Tasks/Service/GetTaskDetailsApi";
import MediaGallery from "../../../Common/Components/MediaGallery";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";
import { ActivateTask } from "../Service/ActivateTask";
import VisibilityIcon from '@mui/icons-material/Visibility';
import { IdentityHelper } from "../../../Common/Utils/IdentityHelper";
import Snackbar from "@mui/material/Snackbar";
import MuiAlert from "@mui/material/Alert";

const WorkerDataGrid = ({ tasks, refreshData }) => {
    const [drawerOpen, setDrawerOpen] = useState(false);
    const [selectedTask, setSelectedTask] = useState(null);
    const theme = useTheme();
    const [showTaskBarError, setShowTaskBarError] = useState(false);
    const [showTaskBarSuccess, setShowTaskBarSuccess] = useState(false);

    const firstName = IdentityHelper.UserData.firstName
    const lastName = IdentityHelper.UserData.lastName
    //console.log(`${firstName} ${lastName} `) // for testing

    const columns = [
        { field: "taskId", headerName: 'رقم', flex: 0.5 },
        { field: "strTypeNameEn", headerName: 'النوع', flex: 1 },
        { field: "strTaskStatus", headerName: 'الحالة', flex: 0.5 },
        { field: "scheduledDate", headerName: 'البدأ', flex: 0.5 },
        { field: "deadlineDate", headerName: 'الانتهاء', flex: 0.5 },
        {
            field: "button",
            headerName: "",
            renderCell: (params) => (
                <>
                    <IconButton
                        variant="contained"
                        color="primary"
                        onClick={() => {
                            setSelectedTask(params.row); // Set the selected task
                            setDrawerOpen(true);
                        }}
                    >
                        <VisibilityIcon />
                    </IconButton>
                    <IconButton
                        variant="contained"
                        color="primary"
                        disabled={!params.row.isLeader}
                        onClick={() => handleSubmit(params.row.taskId, params.row.strTaskStatus)}
                    >
                        <CheckCircleOutline />
                    </IconButton>
                </>
            ),
        },
    ];

    const handleSubmit = async (taskId, status, tasks) => {
        await ActivateTask(taskId);
        if (status === 'in progress') {
            setShowTaskBarError(true);
        } else if (status === 'completed') {
            setShowTaskBarError(true);
        } else {
            setShowTaskBarSuccess(true);

        }

    }

    return (
        <Box margin="2rem 0 0 0" height="75vh">
            <DataGrid
                rows={tasks}
                columns={columns}
                getRowId={(row) => row.taskId}
                components={{ Toolbar: GridToolbar }}
                density="compact"
            />
            <SwipeableDrawer
                anchor="right"
                open={drawerOpen}
                onClose={() => setDrawerOpen(false)}
                onOpen={() => setDrawerOpen(true)}
            >
                <Stack spacing={2} width="32.5vw">
                    {/* Display the selected task details */}
                    {selectedTask && (
                        <Box sx={{ p: 3 }}>
                            <br />
                            <Box sx={{ height: '25rem', width: 'auto', bgcolor: "gray", borderRadius: '1rem' }}>
                                {/* photo */}
                            </Box>
                            <br />
                            <Typography variant="h2" sx={{ p: 3, direction: 'rtl' }}> {selectedTask.strTypeNameAr}</Typography>
                            <Divider />
                            <br />
                            <br />
                            <FlexBetween>
                                <Chip label={selectedTask.taskId} />
                                <Typography variant="h4">رقم </Typography>
                            </FlexBetween>
                            <br />
                            <FlexBetween>
                                <Chip label={selectedTask.strTaskStatus} />
                                <Typography variant="h4">الحالة </Typography>
                            </FlexBetween>
                            <br />
                            <FlexBetween>
                                <Chip label={DateFormatterEn(selectedTask.scheduledDate)} />
                                <Typography variant="h4">وقت البدأ </Typography>
                            </FlexBetween>
                            <br />
                            <FlexBetween>
                                <Chip label={DateFormatterEn(selectedTask.deadlineDate)} />
                                <Typography variant="h4">وقت الانتهاء</Typography>
                            </FlexBetween>
                        </Box>
                    )}
                </Stack>
            </SwipeableDrawer>
            {showTaskBarError && (
                <Snackbar
                    open={showTaskBarError}
                    autoHideDuration={4000}
                    onClose={() => setShowTaskBarError(false)}
                    anchorOrigin={{
                        vertical: 'top',
                        horizontal: 'right',
                    }}
                    dir="ltr"
                >
                    <MuiAlert
                        elevation={6}
                        variant="filled"
                        severity="error"
                        onClose={() => setShowTaskBarError(false)}
                    >
                        Task already activated
                    </MuiAlert>
                </Snackbar>
            )}

            {showTaskBarSuccess && (
                <Snackbar
                    open={showTaskBarSuccess}
                    autoHideDuration={4000}
                    onClose={() => setShowTaskBarSuccess(false)}
                    anchorOrigin={{
                        vertical: 'top',
                        horizontal: 'right',
                    }}
                    dir="ltr"
                >
                    <MuiAlert
                        elevation={6}
                        variant="filled"
                        severity="success"
                        onClose={() => setShowTaskBarSuccess(false)}
                    >
                        Task activate...
                    </MuiAlert>
                </Snackbar>
            )}


        </Box>
    );
};

export default WorkerDataGrid;
