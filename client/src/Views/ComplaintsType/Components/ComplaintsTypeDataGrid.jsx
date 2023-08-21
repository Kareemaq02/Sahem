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

const ComplaintsTypeDataGrid = ({ DeleteComplaintsType, data }) => {
  const theme = useTheme();
  const columns = [
    {
      field: "intDepartmentId",
      headerName: "Department ID",
      flex: 0.5,
    },
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
    {
      field: "strPrivacy",
      headerName: "Privacy",
      flex: 0.5,
    },
  ];
  return (
    <Box margin="2rem 0 0 0" height="75vh">
      <DataGrid
        rows={data}
        columns={columns}
        getRowId={(row) => row.id || Math.random().toString(36).substring(7)}
        components={{ Toolbar: GridToolbar }}
        density="compact"
        sx={{width:"70%"}}
      />
    </Box>
  );
};

export default ComplaintsTypeDataGrid;
