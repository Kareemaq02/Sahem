import { AddCircleOutline, ArrowCircleUp } from "@mui/icons-material/";
import { DataGrid,GridToolbar } from "@mui/x-data-grid";
import {
    Box,
    IconButton,
  } from "@mui/material";
  import { CheckCircleOutline } from "@mui/icons-material/";

const WorkerTaskDataGrid = ({data,EvaluateTask}) => {

    const columns = [
        {field: "taskID", headerName: "ID", flex:0.5},
        { field: "adminUsername", headerName: "Admin Name", flex: 0.5 },
        { field: "strTaskStatus", headerName: "Status", flex: 0.5 },
        { field: "activatedDate", activatedDate: "scheduledDate", flex: 0.5 },
        { field: "finishedDate", headerName: "finishedDate", flex: 0.5 },
        {
            field: "button",
            headerName: "Action",
            renderCell: (params) => (
              <IconButton
                variant="contained"
                color="primary"
                onClick={() => EvaluateTask(params.row.taskID)}
              >
                <CheckCircleOutline />
              </IconButton>
            ),
          },
    ];

    return (
        <Box margin="2rem 0 0 0" height="75vh">
            <DataGrid
                rows={data}
                columns={columns}
                getRowId={(row) => row.taskID }
                components={{ Toolbar: GridToolbar }}
                density="compact"
            />
        </Box>
    )
}

export default WorkerTaskDataGrid