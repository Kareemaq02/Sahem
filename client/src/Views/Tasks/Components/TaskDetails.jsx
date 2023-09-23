import React from "react";

// Mui
import {
  Stack,
  Divider,
  Typography,
  Box,
  Chip,
  Avatar,
  AvatarGroup,
} from "@mui/material";
import { CalendarMonth, Storage } from "@mui/icons-material";
import { styled } from "@mui/system";

// Project Imports
import { FlexBetween } from "../../../Common/Components/FlexBetween";

const MuiAvatarGroup = styled(AvatarGroup)(({ theme }) => ({
  "& .MuiAvatar-root": {
    width: "1.5rem",
    height: "1.5rem",
    fontSize: "0.75rem",
    color: theme.palette.grey[500],
  },
}));

const TaskDetails = ({ theme, taskData }) => {
  return (
    <Box dir="rtl" sx={{p:1}}>
      <Stack spacing={2}>
        <Box width="25rem">
          <Typography variant="h2" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>{taskData.typeAr}</Typography>
          <Typography variant="h6" color={theme.palette.grey[500]}>
            Al Jama'a Street 10, Amman
          </Typography>
        </Box>
        <Divider variant="middle" />
        <FlexBetween>
          <Typography variant="h4" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>المعلومات</Typography>
          <Typography
            variant="h5"
            color={theme.palette.grey[500]}
            display="flex"
            alignItems="center"
            gap="0.5rem"
          >
            <Storage />
            {taskData.taskId}
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            الحالة
          </Typography>
          <Chip
            label={taskData.taskStatus}
            color="primary"
            variant="outlined"
          />
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            العمال
          </Typography>
          <Box>
            <MuiAvatarGroup max={4}>
              {taskData.members.map((member) => (
                <Avatar>{member}</Avatar>
              ))}
            </MuiAvatarGroup>
          </Box>
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            مسؤول العمال
          </Typography>
          <Chip
            variant="outlined"
            avatar={<Avatar>F</Avatar>}
            label={taskData.admin}
            sx={{
              "& .MuiChip-label": { color: theme.palette.grey[500] },
              p:1
            }}
          />
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            تاريخ الانشاء
          </Typography>
          <Chip
            variant="outlined"
            icon={<CalendarMonth color="primary" />}
            label={taskData.date}
            color="primary"
            sx={{p:1}}
          />
        </FlexBetween>
      </Stack>
    </Box>
  );
};

export default TaskDetails;
