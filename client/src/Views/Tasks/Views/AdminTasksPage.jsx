import React, { useEffect, useState } from "react";
import { useForm, FormProvider } from "react-hook-form";
import { deleteTasks } from "../Service/DeleteTask";
import { Button, Snackbar, Stack, Typography, useTheme, SwipeableDrawer, Grid, } from "@mui/material";
import { EvaluateTaskApi } from "../Service/EvaluateTaskApi";
import { GetTaskDetailsApi } from "../Service/GetTaskDetailsApi";
import TaskDetails from "../Components/TaskDetails";
import MediaGallery from "../../../Common/Components/MediaGallery";
import FormTextFieldMulti from "../../../Common/Components/UI/FormFields/FormTextFieldMulti";
import FormRatingGroup from "../../../Common/Components/UI/FormFields/FormRatingGroup";
import FormRowRadioGroup from "../../../Common/Components/UI/FormFields/FormRadioGroup";
import TasksDataGrid from "../Components/TasksDataGrid";
import ScrollableContent from "../../../Common/Components/ScrollableContent";
import CustomFilter from "../Components/CustomFilter";

// icons 
import ArrowCircleUpIcon from '@mui/icons-material/ArrowCircleUp';
import ArrowCircleDownIcon from '@mui/icons-material/ArrowCircleDown';

const testPhotos = [
  {
    media: "https://picsum.photos/id/10/800",
    title: "Test 1",
  },
  {
    media: "https://picsum.photos/id/13/800",
    title: "Test 2",
  },
  {
    media: "https://picsum.photos/id/14/800",
    title: "Test 3",
  },
];
const radioOptions = ["خطا", "منجز"];

const AdminTasksPage = () => {
  const methods = useForm();
  const theme = useTheme();
  const [taskPhotos, setTaskPhotos] = useState(testPhotos);
  const [selectedStatus, setSelectedStatus] = useState([]);

  const [refreshDataGrid, setRefreshDataGrid] = useState(false);
  const handleRefreshDataGrid = () => {
    setRefreshDataGrid(prevState => !prevState);
  };
  const [selectedComplaintTypes, setSelectedComplaintTypes] = useState([]);
  const [taskData, setTaskData] = useState({
    taskId: 0,
    taskStatus: null,
    members: [],
    type: null,
    date: null,
    photos: []
  });

  const [drawerOpen, setDrawerOpen] = useState(false);
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState("");
  const [pageNumber, setPageNumber] = useState(1);
  const pageSize = 15;


  const [showAlertDialog, setShowAlertDialog] = useState(false);

  const onSubmit = async (data) => {
    if (EvaluateTaskApi(data, taskData.taskId)) {
      setSnackbarMessage("Task evaluated successfully!");
      setSnackbarOpen(true);
      handleRefreshDataGrid();
      setDrawerOpen(false);
    } else {
      setSnackbarMessage("Failed to evaluate task.");
      setSnackbarOpen(true);
    }
  };

  const handleCloseSnackbar = () => {
    setSnackbarOpen(false);
  };

  const handleComplaintStatusChange = (selectedStatusId) => {
    setSelectedStatus(selectedStatusId);
  };

  const handleComplaintTypesChange = (selectedComplaintTypeIds) => {
    setSelectedComplaintTypes(selectedComplaintTypeIds);
  };
  const handleArrowUp = () => {
    setPageNumber((prevPageNumber) => prevPageNumber + 1);
  };

  const handleArrowDown = () => {
    if (pageNumber > 1) {
      setPageNumber((prevPageNumber) => prevPageNumber - 1);
    }
  };

  return (
    <div>
      <Typography variant="h1" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>تقييم الاعمال</Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={10}>
          <TasksDataGrid
            refreshDataGrid={refreshDataGrid}
            EvaluateTask={async (id, admin) => {
              const data = await GetTaskDetailsApi(id);
              setTaskPhotos(data.photos);
              setTaskData({ taskId: id, ...data, admin: admin, photos: null });
              setDrawerOpen(true);
            }}
            pageNumber={pageNumber}
            pageSize={pageSize}
            selectedStatus={selectedStatus}
            selectedTaskType={selectedComplaintTypes}
          />

          <div style={{ textAlign: "center", }}>
            <ArrowCircleDownIcon
              onClick={handleArrowUp}
              style={{ cursor: "pointer", marginRight: "1rem" }}
            />
            <ArrowCircleUpIcon
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
                    <MediaGallery
                      items={testPhotos}
                      height="25rem"
                      width="auto"
                      borderRadius="1rem"
                    />
                    <TaskDetails theme={theme} taskData={taskData} />
                    <FormRatingGroup name="rating" />
                    <FormTextFieldMulti label="التعليق" name="comment" />
                    <FormRowRadioGroup
                      name="status"
                      radioLabel="Status"
                      labels={radioOptions}

                    />
                    <Button
                      type="submit"
                      color="primary"
                      variant="contained"
                      sx={{ borderRadius: "1rem", fontFamily: 'Droid Arabic Naskh, sans-serif' }}
                    >
                      التالي
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

        <Grid item xs={12} md={2}>
          <CustomFilter onComplaintStatusChange={handleComplaintStatusChange} onComplaintTypesChange={handleComplaintTypesChange} />
        </Grid>
      </Grid>
    </div>
  );
};

export default AdminTasksPage;
