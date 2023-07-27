import GetWorker from "../Service/GetWorkerApi";
import { useEffect, useState } from "react";
import ShowWorkersDataGrid from "../Components/showWorkersDataGrid";

const AdminShowWorkersView = () => {
    const [worker, setWorker] = useState([])



    const info = [
        {ID:'1',Name:"Ibrahim",Date:'Today'},
        {ID:'2',Name:"Ahmad",Date:'Today'},
        {ID:'3',Name:"Osama",Date:'Today'},
        {ID:'4',Name:"Abed",Date:'Today'},
    ]

    useEffect(() => {
        const setViewWorker = async () => {
            const response = await GetWorker();
            setWorker(response.data)
        };
        setViewWorker();
    }, [])

    return(
        <ShowWorkersDataGrid data={worker} />
    )
}

export default AdminShowWorkersView;
