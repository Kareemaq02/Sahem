import { Typography, SwipeableDrawer, Grid } from "@mui/material";
import TaskTypeDataGrid from "../Components/TaskTypeDataGrid";
import GetTaskType from "../Service/GetTaskType"
import { useEffect, useState } from "react";
import AddTaskType from "../Components/AddTaskType";


function AdminTaskType() {
  const [complaints, setComplaints] = useState([]);

  useEffect(() => {
    const setTaskType = async () => {
      const response = await GetTaskType();
      setComplaints(response.data)
    };
    setTaskType();
  }, [])


  return (
    <div>
      <Typography variant="h1" sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>اظهار انواع المشاكل</Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}>
          <TaskTypeDataGrid data={complaints} />
        </Grid>
        <Grid item xs={12} md={4}>
          <AddTaskType refreshdata={setComplaints}/>
        </Grid>
      </Grid>
    </div>
  );
}

export default AdminTaskType;
