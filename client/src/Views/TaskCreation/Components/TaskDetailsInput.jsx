import React, { useEffect, useState, useContext } from "react";
import { useForm, FormProvider } from "react-hook-form";

// Third Party
import dayjs from "dayjs";
import { yupResolver } from "@hookform/resolvers/yup";

// Mui
import { Divider, Button, Stack, Typography, useTheme } from "@mui/material";
import { Storage } from "@mui/icons-material/";

// Project Imports
import FormTextFieldMulti from "../../../Common/Components/UI/FormFields/FormTextFieldMulti";
import FormAutocompleteBox from "../../../Common/Components/UI/FormFields/FormAutocompleteBox";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import FormDateTimePicker from "../../../Common/Components/UI/FormFields/FormDateTimePicker";
import MediaGallery from "../../../Common/Components/MediaGallery";
import { GetTasksTypesApi } from "../Service/GetTasksTypesApi";
import Slider from 'react-slick';

// Context
import TaskCreationContext from "../Context/TaskCreationContext";

// schemas
import { TaskSchema } from "../Utils/Schemas";


const TaskDetailsInput = ({ photos, complaint, NextStep }) => {
  const [taskTypes, setTaskTypes] = useState([]);
  const { task, setTask, setStartDate, setDueDate } = useContext(TaskCreationContext);

  useEffect(() => {
    const GetTaskTypes = async () => {
      setTaskTypes(await GetTasksTypesApi());
    };
    GetTaskTypes();
  }, []);

  const methods = useForm({
    resolver: yupResolver(TaskSchema),
    defaultValues: {
      startDate: task.startDate,
      dueDate: task.dueDate,
      taskType: task.taskType,
      comment: task.comment,
    },
  });
  const theme = useTheme();
  return (
    <Stack spacing={2}>
      <Slider
        dots={true}
        infinite={true}
        slidesToShow={1}
        slidesToScroll={1}
        autoplay={true}
        autoplaySpeed={3000}
      >
        {photos.map((media, index) => (
          <div key={index}>
            <img
              src={`data:image/jpg;base64,${media.data}`}
              alt={`Image ${index}`}
              style={{ borderRadius: '25px', width: '100%', height: '450px' }}
            />
          </div>
        ))}
      </Slider>
      <br />
      <Divider variant="middle" />
      <FormProvider {...methods}>
        <form
          onSubmit={methods.handleSubmit((data) => {
            setTask({
              ...task,
              startDate: dayjs(data.startDate),
              dueDate: dayjs(data.dueDate),
              taskType: data.taskType,
              comment: data.comment,
            });
            setStartDate(dayjs(data.startDate)); // Update startDate in context

            setDueDate(dayjs(data.dueDate)); // Update dueDate in context
            NextStep();
          })}
        >
          <Stack spacing={2}>
            <FlexBetween>
              <Typography variant="h4">Details</Typography>
              <Typography
                variant="h5"
                color={theme.palette.grey[500]}
                display="flex"
                alignItems="center"
                gap="0.5rem"
              >
                <Storage />
                {complaint.intComplaintId}
              </Typography>
            </FlexBetween>
            <FlexBetween>
              <Typography variant="h5" color={theme.palette.grey[500]} sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
                تاريخ الانشاء:
              </Typography>
              <FormDateTimePicker
                name="startDate"
                minDateTime={dayjs()}
                maxDateTime={methods.watch("dueDate")}
              />
            </FlexBetween>
            <FlexBetween>
              <Typography variant="h5" color={theme.palette.grey[500]} sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
                تاريخ الانتهاء:
              </Typography>
              <FormDateTimePicker
                name="dueDate"
                minDateTime={methods.watch("startDate") || dayjs()}
                onChange={(newDate) => setDueDate(newDate)}
              />
            </FlexBetween>
            <FormAutocompleteBox
              name="taskType"
              label="Task Type"
              items={taskTypes}
            />
            <FormTextFieldMulti name="comment" label="Comment" />
            <Button
              type="submit"
              variant="contained"
              sx={{ borderRadius: "1rem", fontFamily: 'Droid Arabic Naskh, sans-serif' }}
              onChange={(newDate) => setDueDate(newDate)}

            >
              التالي
            </Button>
          </Stack>
        </form>
      </FormProvider>
    </Stack>
  );
};

export default TaskDetailsInput;
