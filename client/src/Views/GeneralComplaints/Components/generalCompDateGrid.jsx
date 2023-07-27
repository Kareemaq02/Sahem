import { useTheme } from "@emotion/react";
import { Toolbar,Box } from "@mui/material";
import { DataGrid,GridToolbar } from "@mui/x-data-grid";
import React , {useState , useEffect} from "react";

const GeneralCompDataGrid = ({data}) => {
    const theme = useTheme();

    const columns = [
        { field: "intComplaintId", headerName: "ID", flex: 0.5 },
        { field: "strComplaintTypeEn", headerName: "Type", flex: 1 },
        { field: "dtmDateCreated", headerName: "Date Created", flex: 1 },
    ]

    return (
        <Box margin="2rem 0 0 0" height="75vh">
            <DataGrid
                rows={data}
                columns={columns}
                getRowId={(row) => row.intComplaintId}
                components={{ Toolbar: GridToolbar }}
                density="compact"
            />
        </Box>
    )
}

export default GeneralCompDataGrid;