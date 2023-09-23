import React, { useContext, useState } from "react";

// Mui
import {
  Stack,
  Divider,
  Typography,
  Box,
  Chip,
  Avatar,
  AvatarGroup,
  useTheme,
  TextField,
  Button,
} from "@mui/material";
import { CalendarMonth, Storage } from "@mui/icons-material";
import { styled } from "@mui/system";

// Project Imports
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import { CreateTaskApi } from "../Service/CreateTaskApi";

// Context
import TaskCreationContext from "../Context/TaskCreationContext";
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";
import ResultPopup from "../../../Common/Components/ResultPopup";

const MuiAvatarGroup = styled(AvatarGroup)(({ theme }) => ({
  "& .MuiAvatar-root": {
    width: "1.5rem",
    height: "1.5rem",
    fontSize: "0.75rem",
    color: theme.palette.grey[500],
  },
}));

const TaskCreationDetails = ({ ResetStep, complaint, CloseDrawer }) => {
  const theme = useTheme();
  const { task, members, leader, fullTeam } = useContext(TaskCreationContext);
  const [result, setResult] = useState(null);

  const CreateTask = async () => {
    const data = {
      cost: 0.0,
      startDate: task.startDate,
      endDate: task.dueDate,
      comment: task.comment,
      team: fullTeam,
    };
    setResult(await CreateTaskApi(data, complaint.intComplaintId));
  };

  return result !== null ? (
    <ResultPopup
      type={result}
      successMessage={`Task has been created successfully at ${DateFormatterEn()}`}
      failMessage={`Task creation failed, UNKNOWN ERROR at ${DateFormatterEn()}`}
      onClick={CloseDrawer}
    />
  ) : (
    <Box>
      <Stack spacing={2}>
        <Box width="25rem">
          <Typography variant="h2">{task.taskType.strName}</Typography>
          <Typography variant="h6" color={theme.palette.grey[500]}>
            Al Jama'a Street 10, Amman
          </Typography>
        </Box>
        <Divider variant="middle" />
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
            {task.id}
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Chip label={task.status} color="primary" variant="outlined" />
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            الحالة
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Box>
            <MuiAvatarGroup max={4}>
              {members.map((member) => (
                <Avatar key={member.intId}>{member.strName[0]}</Avatar>
              ))}
            </MuiAvatarGroup>
          </Box>
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            الاعضاء
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Chip
            variant="outlined"
            avatar={<Avatar>{leader.strName[0]}</Avatar>}
            label={leader.strName}
            sx={{
              "& .MuiChip-label": { color: theme.palette.grey[500] },
              direction: 'rtl',
              p: 1,
            }}
          />
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            مسؤول الفريق
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Chip
            variant="outlined"
            icon={<CalendarMonth color="primary" />}
            label={DateFormatterEn(task.startDate)}
            color="primary"
          />
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            من تاريخ
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Chip
            variant="outlined"
            icon={<CalendarMonth color="primary" />}
            label={DateFormatterEn(task.dueDate)}
            color="primary"
          />
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            الى تاريخ
          </Typography>
        </FlexBetween>
        <TextField
          label="Comment"
          multiline
          rows={4}
          readOnly
          value={task.comment}
        />
        <Stack direction="row" spacing={2}>
          <Button
            onClick={ResetStep}
            variant="outlined"
            color="primary"
            sx={{
              flex: "1 1 auto",
              borderRadius: "1rem",
              fontFamily: 'Droid Arabic Naskh, sans-serif'
            }}
          >
            تعديل
          </Button>
          <Button
            onClick={CreateTask}
            variant="contained"
            color="success"
            sx={{
              flex: "1 1 auto",
              borderRadius: "1rem",
              fontFamily: 'Droid Arabic Naskh, sans-serif'
            }}
          >
            انشاء المهمة
          </Button>
        </Stack>
      </Stack>
    </Box>
  );
};

export default TaskCreationDetails;
