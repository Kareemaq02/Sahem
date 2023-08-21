import { AddCircleOutline, ArrowCircleUp } from "@mui/icons-material/";
import { DataGrid,GridToolbar } from "@mui/x-data-grid";
import {
    Box,
    IconButton,
  } from "@mui/material";
  import { CheckCircleOutline } from "@mui/icons-material/";

const WorkerTaskDataGrid = ({data,EvaluateTask}) => {

    const columns = [
        {field: "id", headerName: "ID", flex:0.5},
        { field: "admin", headerName: "Admin Name", flex: 0.5 },
        { field: "status", headerName: "Status", flex: 0.5 },
        { field: "dateScheduled", activatedDate: "scheduledDate", flex: 0.5 },
        { field: "deadline", headerName: "finishedDate", flex: 0.5 },
    ];

    return (
        <Box margin="2rem 0 0 0" height="75vh">
            <DataGrid
                rows={data}
                columns={columns}
                getRowId={(row) => row.id }
                components={{ Toolbar: GridToolbar }}
                density="compact"
            />
        </Box>
    )
}

export default WorkerTaskDataGrid