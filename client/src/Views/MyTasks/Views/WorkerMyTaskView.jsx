import React, { useEffect, useState } from "react";
import WorkerDataGrid from "../Components/WorkerDataGrid";
import { GetMyTasks } from "../Service/GetMyTaskAPI";
import { Box } from "@mui/material";

const WorkerMyTaskView = () => {
    const [myTasks, setMyTasks] = useState([]);

    useEffect(() => {
        const fetchWorkerTasks = async () => {
            try {
                const response = await GetMyTasks();
                const tasksWithLeaderStatus = response.data.map(task => ({
                    ...task,
                    isLeader: task.blnIsTaskLeader === true
                }));
                setMyTasks(tasksWithLeaderStatus);
            } catch (error) {
                console.error(error);
            }
        };
        fetchWorkerTasks();
    }, []);


    return (
        <Box>
            <WorkerDataGrid tasks={myTasks} refreshData={setMyTasks}/>
        </Box>
    );
};

export default WorkerMyTaskView;
