import GetWorker from "../Service/GetWorkerApi";
import { useEffect, useState } from "react";
import ShowWorkersDataGrid from "../Components/showWorkersDataGrid";
import { Grid } from "@mui/material";

//projects
import AdminWorkerReg from "../../WorkerReg/Views/AdminWorkerReg";

const AdminShowWorkersView = () => {
    const [worker, setWorker] = useState([])



    const info = [
        { ID: '1', Name: "Ibrahim", Date: 'Today' },
        { ID: '2', Name: "Ahmad", Date: 'Today' },
        { ID: '3', Name: "Osama", Date: 'Today' },
        { ID: '4', Name: "Abed", Date: 'Today' },
    ]

    useEffect(() => {
        const setViewWorker = async () => {
            const response = await GetWorker();
            setWorker(response.data)
        };
        setViewWorker();
    }, [])

    return (
        <Grid container spacing={2}>
            <Grid item xs={12} md={9}>
                <ShowWorkersDataGrid data={worker} />
            </Grid>
            <Grid item xs={12} md={3}>
                <AdminWorkerReg />
            </Grid>
        </Grid>
    )
}

export default AdminShowWorkersView;
