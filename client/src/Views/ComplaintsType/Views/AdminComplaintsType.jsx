import { Typography, SwipeableDrawer, Grid } from "@mui/material";
import { useEffect, useState } from "react";
import GetComplaintsTypes from "../Service/GetComplaintsTypes";
import ComplaintsTypeDataGrid from "../Components/ComplaintsTypeDataGrid";
import ComplaintsTypeForm from "../Components/ComplaintsTypeForm"

function AdminComplaintsType() {
  const [complaintType, setComplaintType] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const response = await GetComplaintsTypes();
      setComplaintType(response.data);
    };

    if (complaintType.length === 0) {
      fetchData();
    }
  }, [complaintType]);


  return (
    <div>
      <Typography variant="h1">View Complaints Type</Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}>
          <ComplaintsTypeDataGrid data={complaintType} />
        </Grid>
        <Grid item xs={12} md={4}>
          <ComplaintsTypeForm refreshData={setComplaintType}/>
        </Grid>
      </Grid>
    </div>
  )
}

export default AdminComplaintsType;