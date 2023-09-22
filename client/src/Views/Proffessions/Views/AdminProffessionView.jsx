import { Typography, Grid } from "@mui/material";
import { useEffect, useState } from "react";
import ProffessionDataGrid from "../Components/ProffessionDataGrid";
import GetProffession from "../Service/GetProffession";
import ProffessionForm from "../Components/ProffessionForm";
import { Snackbar, Alert } from '@mui/material';

function AdminProffession() {
  const [proffession, setProffession] = useState([]);

  const [openSnackbar, setOpenSnackbar] = useState(false);

  const handleSnackbarClose = () => {
    setOpenSnackbar(false);
  };
  
  const handleSnackbarOpen = () => {
    setOpenSnackbar(true);
  };
  

  useEffect(() => {
    const setProffessions = async () => {
      const response = await GetProffession();
      setProffession(response.data);
      handleSnackbarOpen(); 
    };
    setProffessions();
  }, []);

  return (
    <div>
       <Snackbar
      open={openSnackbar}
      autoHideDuration={3000}
      onClose={handleSnackbarClose}
    >
      <Alert onClose={handleSnackbarClose} severity="success" sx={{ width: '100%' }}>
      تم إضافة مهنة جديدة بنجاح!
      </Alert>
    </Snackbar>
      <Typography variant="h1" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>عرض المهن</Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}>
          <ProffessionDataGrid data={proffession} />
        </Grid>
        <Grid item xs={12} md={4}>
          <ProffessionForm refreshData={setProffession}/>
        </Grid>
      </Grid>
    </div>
  );
}

export default AdminProffession;
