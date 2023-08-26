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

const TaskTypeDataGrid = ({ DeleteTaskType, data }) => {
  const theme = useTheme();
  const columns = [
    {
      field: "strNameAr",
      headerName: "الاسم بالعربي",
      flex: 1,
    },
    {
      field: "strNameEn",
      headerName: "الاسم بلانجليزي",
      flex: 1,
    },
  ];

  return (
    <Box margin="2rem 0 0 0" height="75vh">
      <DataGrid
        rows={data}
        columns={columns}
        getRowId={(row) => row.intId }
        components={{ Toolbar: GridToolbar }}
        density="compact"
        sx={{fontSize: 'medium'}}
      />
    </Box>
  );
};

export default TaskTypeDataGrid;
