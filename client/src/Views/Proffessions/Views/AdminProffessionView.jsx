import { Typography, Grid } from "@mui/material";
import { useEffect, useState } from "react";
import ProffessionDataGrid from "../Components/ProffessionDataGrid";
import GetProffession from "../Service/GetProffession";
import ProffessionForm from "../Components/ProffessionForm";

function AdminProffession() {
  const [proffession, setProffession] = useState([]);

  useEffect(() => {
    const setProffessions = async () => {
      const response = await GetProffession();
      setProffession(response.data);
    };
    setProffessions();
  }, []);

  return (
    <div>
      <Typography variant="h1">View Proffessions</Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}>
          <ProffessionDataGrid data={proffession} />
        </Grid>
        <Grid item xs={12} md={4}>
          <ProffessionForm/>
        </Grid>
      </Grid>
    </div>
  );
}

export default AdminProffession;
