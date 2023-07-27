import {
  Button,
  Snackbar,
  Stack,
  Typography,
  useTheme,
  SwipeableDrawer,
} from "@mui/material";
import { useEffect, useState } from "react";
import { useForm, FormProvider } from "react-hook-form";
import { GetTasksApi } from "../Service/GetTasksApi";
import WorkerTaskDataGrid from "../Components/WorkerTasksDataGrid";
import ScrollableContent from "../../../Common/Components/ScrollableContent";
import FormRowRadioGroup from "../../../Common/Components/UI/FormFields/FormRadioGroup";
import FormRatingGroup from "../../../Common/Components/UI/FormFields/FormRatingGroup";
import FormTextFieldMulti from "../../../Common/Components/UI/FormFields/FormTextFieldMulti";
import TaskDetails from "../Components/WorkerTaskDetails";
import { EvaluateTaskApi } from "../Service/EvaluateTaskApi";
import { GetTaskDetailsApi } from "../Service/GetTaskDetailsApi";

function WorkerTasksPage() {
  const [tasks, setTasks] = useState([]);
  const methods = useForm();
  const theme = useTheme();

  const radioOptions = ["Failed", "Incomplete", "Completed"];

  useEffect(() => {
    const setTasksView = async () => {
      const response = await GetTasksApi();
      console.log("Tasks response:", response);
      if (response && response.data) {
        setTasks(response.data);
      }
    };
    setTasksView();
  }, []);

  const [taskId, setTaskId] = useState(0);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState("");
  const [selectedTask, setSelectedTask] = useState(null);


  const handleEvaluateTask = (taskId) => {
    // Find the selected task
    const selectedTask = tasks.find((task) => task.taskID === taskId);
    setSelectedTask(selectedTask);
  
    // Open the drawer
    setDrawerOpen(true);
  };


  const onSubmit = (data) => {
    if (EvaluateTaskApi(data)) {
      setSnackbarMessage("Task evaluated successfully!");
      setSnackbarOpen(true);
  
      // Close the drawer after successful submission
      setDrawerOpen(false);
    } else {
      setSnackbarMessage("Failed to evaluate task.");
      setSnackbarOpen(true);
    }
  };
  

  const handleCloseSnackbar = () => {
    setSnackbarOpen(false);
  };

  return (
    <div>
      <Typography variant="h1" component="h1">
        Worker Tasks Page
      </Typography>
      <WorkerTaskDataGrid data={tasks} EvaluateTask={handleEvaluateTask} />


      <SwipeableDrawer
        anchor="right"
        open={drawerOpen}
        onClose={() => setDrawerOpen(false)}
        onOpen={() => setDrawerOpen(true)}
      >
        <ScrollableContent>
          <FormProvider {...methods}>
            <form onSubmit={methods.handleSubmit(onSubmit)}>
              <Stack spacing={2} width="32.5vw">
                <TaskDetails theme={theme} selectedTask={selectedTask} />
                <Button
                  type="submit"
                  color="primary"
                  variant="contained"
                  sx={{ borderRadius: "1rem" }}
                >
                  Approve
                </Button>
              </Stack>
            </form>
          </FormProvider>
        </ScrollableContent>
      </SwipeableDrawer>
      <Snackbar
        open={snackbarOpen}
        autoHideDuration={2000}
        onClose={handleCloseSnackbar}
        message={snackbarMessage}
      />
    </div>
  );
}

export default WorkerTasksPage;
