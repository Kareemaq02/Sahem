import React from "react";
import { Box } from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";

const WorkerDataGrid = ({ tasks }) => {
    const columns = [
        { field: "taskId", headerName: 'ID', flex: 0.5 },
        { field: "strTypeNameEn", headerName: 'Type', flex: 1 },
        { field: "strTaskStatus", headerName: 'Status', flex: 0.5 },
        { field: "scheduledDate", headerName: 'Scheduled', flex: 0.5 },
        { field: "deadlineDate", headerName: 'Deadline', flex: 0.5 },
    ];

    return (
        <Box margin="2rem 0 0 0" height="75vh">
            <DataGrid
                rows={tasks}
                columns={columns}
                getRowId={(row) => row.taskId}
                components={{ Toolbar: GridToolbar }}
                density="compact"
            />
        </Box>
    );
};

export default WorkerDataGrid;
