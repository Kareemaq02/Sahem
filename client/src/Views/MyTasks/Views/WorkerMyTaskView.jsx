import React, { useEffect, useState } from "react";
import WorkerDataGrid from "../Components/WorkerDataGrid";
import { GetMyTasks } from "../Service/GetMyTaskAPI";

const WorkerMyTaskView = () => {
    const [myTasks, setMyTasks] = useState([]);

    useEffect(() => {
        const fetchWorkerTasks = async () => {
            try {
                const response = await GetMyTasks();
                console.log("API Response:", response.data); // Log the response for debugging
                setMyTasks(response.data);
            } catch (error) {
                console.error(error);
            }
        };
        fetchWorkerTasks();
    }, []);


    return (
        <div>
            <WorkerDataGrid tasks={myTasks} />
        </div>
    );
};

export default WorkerMyTaskView;
