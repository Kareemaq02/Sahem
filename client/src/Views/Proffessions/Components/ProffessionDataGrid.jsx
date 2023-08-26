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
  import DeleteForeverIcon from '@mui/icons-material/DeleteForever';

  const Proffession = ({Delete, data}) => {
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
          {
            field: 'Action',
            headerName: 'حذف',
            flex: 0.5,
            renderCell: (params) => (
              <IconButton>
                <DeleteForeverIcon sx={{color: 'red'}}/>
              </IconButton>
            )
          }
    ]

    
  return (
    <Box margin="2rem 0 0 0" height="75vh">
      <DataGrid
        rows={data}
        columns={columns}
        getRowId={(row) => row.id || Math.random().toString(36).substring(7)}
        components={{ Toolbar: GridToolbar }}
        density="compact"
        sx={{fontSize: 'medium',fontFamily: 'Droid Arabic Naskh, sans-serif'}}
      />
    </Box>
  );
};

export default Proffession;