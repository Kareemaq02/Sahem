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

const TaskDetails = ({ theme, selectedTask}) => {
    return (
    <Box>
      <Stack spacing={2}>
        <Box width="25rem">
          <Typography variant="h2">Construction waste</Typography>
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
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]}>
            Status
          </Typography>
          <Chip label={selectedTask?.strTaskStatus} color="primary" variant="outlined" />
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]}>
            Members
          </Typography>
          <Box>
            <MuiAvatarGroup max={4}>
              <Avatar>A</Avatar>
              <Avatar>M</Avatar>
              <Avatar>A</Avatar>
              <Avatar>W</Avatar>
              <Avatar>S</Avatar>
            </MuiAvatarGroup>
          </Box>
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]}>
            Team Leader
          </Typography>
          <Chip
            variant="outlined"
            avatar={<Avatar>F</Avatar>}
            label={"Fares"}
            sx={{
              "& .MuiChip-label": { color: theme.palette.grey[500] },
            }}
          />
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]}>
            Date Submitted
          </Typography>
          <Chip
            variant="outlined"
            icon={<CalendarMonth color="primary" />}
            label={selectedTask?.activatedDate}
            color="primary"
          />
        </FlexBetween>
      </Stack>
    </Box>
  );
};

export default TaskDetails;
