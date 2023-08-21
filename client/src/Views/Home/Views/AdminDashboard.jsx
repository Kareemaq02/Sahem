import { Grid, Paper, Typography } from "@mui/material";
import BarChartComponent from "../../Charts/Components/BarChartComponent";
import LineChartComponent from "../../Charts/Components/LineChartComponent";
import GeographyChartComp from "../../Charts/Components/GeographyChartComp";
//Data
import { mockLineData } from "../../Charts/Services/mockData";

function AdminDashboard() {
  return (
    <>
      <Typography variant="h4" component="h1" gutterBottom>
        Dashboard Content
      </Typography>
      <Grid container spacing={3}>
        <Grid item xs={6}>
          <Paper sx={{borderRadius:'1rem'}}>
            <BarChartComponent />
          </Paper>
        </Grid>
        <Grid item xs={12} sm={6}>
          <Paper sx={{borderRadius:'1rem'}}>
            <LineChartComponent />
          </Paper>
        </Grid>
        <Grid item xs={12} sm={6}>
          <Paper sx={{borderRadius:'1rem'}}>
            <GeographyChartComp />
          </Paper>
        </Grid>
      </Grid>
      <br />
      <br />
    </>
  );
}

export default AdminDashboard;
