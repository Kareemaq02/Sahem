import { Typography, SwipeableDrawer } from "@mui/material";
import { useEffect, useState } from "react";
import GetComplaintsTypes from "../Service/GetComplaintsTypes";
import ComplaintsTypeDataGrid from "../Components/ComplaintsTypeDataGrid";

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


    return(
        <div>
            <Typography variant="h1">View Complaints Type</Typography>
            <ComplaintsTypeDataGrid data={complaintType} />
        </div>
    )
}

export default AdminComplaintsType;