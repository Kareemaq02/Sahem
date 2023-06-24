import {
    Box,
    IconButton,
    Avatar,
    Chip,
    Typography,
    Slider,
    useTheme,
  } from "@mui/material";
  import { DataGrid, GridToolbar } from "@mui/x-data-grid";
  import { AddCircleOutline, ArrowCircleUp } from "@mui/icons-material/";
  import DeleteIcon from "@mui/icons-material/Delete";

  
  const DepartmentTypeDataGrid = ({DeleteTaskType, data }) => {
    const theme = useTheme();
    const columns = [
          {
            field: "strNameAr",
            headerName: "Arabic Name",
            flex: 1,
          },
          {
            field: "strNameEn",
            headerName: "English Name",
            flex: 1,
          },
          
    ]
    return (
        <Box margin="2rem 0 0 0" height="75vh">
          <DataGrid
            rows={data}
            columns={columns}
            getRowId={(row) => row.strUserName || Math.random().toString(36).substring(7)}
            components={{ Toolbar: GridToolbar }}
            density="compact"
          />
        </Box>
      ); 
}

export default DepartmentTypeDataGrid;