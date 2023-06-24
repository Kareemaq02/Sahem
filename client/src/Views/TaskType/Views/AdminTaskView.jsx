import { Typography, SwipeableDrawer } from "@mui/material";
import TaskTypeDataGrid from "../Components/TaskTypeDataGrid";
import GetTaskType from "../Service/GetTaskType"
import { useEffect, useState } from "react";



function AdminTaskType() {
    const [complaints, setComplaints] = useState([]);

    useEffect(() => {
        const setTaskType = async () => {
            const response = await GetTaskType();
            setComplaints(response.data)
        };
        setTaskType();
    },[])


  return (
    <div>
      <Typography variant="h1">View Task Type</Typography>
      <TaskTypeDataGrid  data={complaints}/>
    </div>
  );
}

export default AdminTaskType;
