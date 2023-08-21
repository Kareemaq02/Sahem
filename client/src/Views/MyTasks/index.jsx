import { Typography } from "@mui/material";
import WorkerMyTaskView from "./Views/WorkerMyTaskView"


function Home() {

    return(
        <div>
            <Typography variant="h1">الاعمال الخاصة بي</Typography>
            <WorkerMyTaskView />
        </div>
    )
}

export default Home;