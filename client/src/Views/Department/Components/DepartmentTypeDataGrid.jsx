import {
  Box,
  IconButton,
  Avatar,
  Chip,
  Typography,
  Slider,
  useTheme,
  SwipeableDrawer,
} from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { AddCircleOutline, ArrowCircleUp } from "@mui/icons-material/";
import DeleteIcon from "@mui/icons-material/Delete";
import DeleteForeverIcon from '@mui/icons-material/DeleteForever';
import { DeleteDepartment } from "../Service/DeleteDepartment";
import { useEffect, useState } from "react";
import StreetviewIcon from '@mui/icons-material/Streetview';
import { GetDepWorker } from "../Service/GetDepWorker";
import { FlexBetween } from "../../../Common/Components/FlexBetween"

const DepartmentTypeDataGrid = ({ data, refreshDataGrid }) => {
  const [selectedWorker, setSelectedWorker] = useState(null);

  const handleDeleteDepartment = async (depId) => {
    try {
      await DeleteDepartment(depId);
      refreshDataGrid();
    } catch (error) {
      console.error(error);
    }
  }

  const handleDepartmentWorker = async (depId) => {
    try {
      const response = await GetDepWorker(depId);
      console.log(response.data)
      setSelectedWorker(response.data)
    } catch (error) {
      console.error(error);
    }
  }

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
    {
      field: 'Action',
      headerName: 'حذف',
      flex: 0.25,
      renderCell: (params) => (
        <IconButton onClick={() => handleDeleteDepartment(params.row.intId)}>
          <DeleteForeverIcon sx={{ color: 'red' }} />
        </IconButton>
      )
    },
    {
      field: 'View',
      headerName: 'عرض',
      flex: 0.25,
      renderCell: (params) => (
        <IconButton onClick={() => handleDepartmentWorker(params.row.intId)}>
          <StreetviewIcon />
        </IconButton>
      )
    }
  ];

  const handleCloseDrawer = () => {
    setSelectedWorker(null);
  }

  return (
    <Box margin="2rem 0 0 0" height="75vh">
      <DataGrid
        rows={data}
        columns={columns}
        getRowId={(row) => row.intId || Math.random().toString(36).substring(7)}
        components={{ Toolbar: GridToolbar }}
        density="compact"
        sx={{ fontSize: 'medium' }}
      />

      <SwipeableDrawer
        anchor="right"
        open={!!selectedWorker}
        onClose={handleCloseDrawer}
        onOpen={() => { }}
      >
        {selectedWorker && selectedWorker.map(worker => (
          <Box key={worker.intId} p={2} sx={{ width: '30vw', direction: 'rtl' }}>
            <Typography variant="h2" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
                معلومات {worker.strFirstNameAr}
            </Typography>
            <br />
            <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
              <FlexBetween>
                الاسم:
                <Chip label={<div>{worker.strFirstNameAr} {worker.strLastNameAr}</div>} />
              </FlexBetween>
            </Typography>
            <br />
            <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
              <FlexBetween>
                رقم الهاتف:
                <Chip label={<div>{worker.strPhoneNumber}</div>}/>

              </FlexBetween>
            </Typography>
          </Box>
        ))}
      </SwipeableDrawer>
    </Box>
  );
}

export default DepartmentTypeDataGrid;
