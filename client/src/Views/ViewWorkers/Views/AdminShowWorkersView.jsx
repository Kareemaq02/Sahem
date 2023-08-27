import GetWorker from "../Service/GetWorkerApi";
import { useEffect, useState } from "react";
import ShowWorkersDataGrid from "../Components/showWorkersDataGrid";
import { Grid } from "@mui/material";
//projects
import AdminWorkerReg from "../../WorkerReg/Views/AdminWorkerReg";

const AdminShowWorkersView = () => {
    const [worker, setWorker] = useState([])
    const [verifiedUser, setVerifiedUser] = useState(false)
    const [blacklistedUser, setBlacklistedUser] = useState(false);
    const [userId, setUserId] = useState(null)

    const selectedUser = worker.find((worker) => worker.intId === userId) || null;

    useEffect(() => {
        const setViewWorker = async () => {
            const response = await GetWorker();
            setWorker(response.data)
        };
        setViewWorker();
    }, [])
   

    const handleFilterChange = (filterType, value) => {
        if (filterType === "verified") {
            setVerifiedUser(value);
        } else if (filterType === "blacklisted") {
            setBlacklistedUser(value);
        }
    };

    return (
        <Grid container spacing={2}>
            <Grid item xs={12} md={9}>
                <ShowWorkersDataGrid data={worker}/>
            </Grid>
            <Grid item xs={12} md={3}>
                <AdminWorkerReg />
            </Grid>
        </Grid>
    )
}

export default AdminShowWorkersView;
