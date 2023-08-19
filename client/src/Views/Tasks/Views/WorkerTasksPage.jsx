import {
  Button,
  Snackbar,
  Stack,
  Typography,
  useTheme,
  SwipeableDrawer,
  Grid,
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

//icons
import ArrowCircleUpIcon from '@mui/icons-material/ArrowCircleUp';
import ArrowCircleDownIcon from '@mui/icons-material/ArrowCircleDown';
import CustomFilter from "../Components/CustomFilter";



function WorkerTasksPage() {
  const methods = useForm();
  const theme = useTheme();
  const pageSize = 15;
  const radioOptions = ["Failed", "Incomplete", "Completed"];

  const [pageNumber, setPageNumber] = useState(1);
  const [tasks, setTasks] = useState([]);
  const [selectedStatus, setSelectedStatus] = useState([]);
  const [selectedTypes, setSelectedTypes] = useState([]);
  const [selectedComplaintTypes, setSelectedComplaintTypes] = useState([]);

  useEffect(() => {
    const setTasksView = async () => {
      const response = await GetTasksApi(pageSize, pageNumber, selectedStatus, selectedComplaintTypes);
      setTasks(response);
    };
    setTasksView();
    
  }, [pageSize, pageNumber, selectedStatus, selectedComplaintTypes]);

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

  const handleArrowUp = () => {
    setPageNumber((prevPageNumber) => prevPageNumber + 1);
  };

  const handleArrowDown = () => {
    if (pageNumber > 1) {
      setPageNumber((prevPageNumber) => prevPageNumber - 1);
    }
  };

  const handleComplaintStatusChange = (selectedStatusId) => {
    setSelectedStatus(selectedStatusId);
  };

  const handleComplaintTypesChange = (selectedComplaintTypeIds) => {
    setSelectedComplaintTypes(selectedComplaintTypeIds);
  };

  return (
    <div>
      <Typography variant="h1" component="h1">
        Worker Tasks Page
      </Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}>


          <WorkerTaskDataGrid data={tasks} EvaluateTask={handleEvaluateTask} />

          <div style={{ textAlign: "center", }}>
            <ArrowCircleUpIcon
              onClick={handleArrowUp}
              style={{ cursor: "pointer", marginRight: "1rem" }}
            />
            <ArrowCircleDownIcon
              onClick={handleArrowDown}
              style={{ cursor: "pointer" }}
            />
          </div>

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
        </Grid>

        <Grid item xs={12} md={4}>
          <CustomFilter onComplaintStatusChange={handleComplaintStatusChange}  onComplaintTypesChange={handleComplaintTypesChange}  />
        </Grid>
      </Grid>
    </div>
  );
}

export default WorkerTasksPage;
