import React, { useState, useEffect } from "react";

// Mui
import { Stack, Divider, Typography, Box, Chip, Avatar } from "@mui/material";
import { CalendarMonth, Storage } from "@mui/icons-material";

// Project Imports
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";
import { FlexBetween } from "../../../Common/Components/FlexBetween";

const ComplaintDetails = ({ theme, complaint }) => {
  return (
    <Box>
      <Stack spacing={2}>
        <Box width="25rem">
          <Typography variant="h2">{complaint.strComplaintTypeEn}</Typography>
          <Typography variant="h6" color={theme.palette.grey[500]}>
            Address Here
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
            {complaint.intComplaintId}
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]}>
            Status
          </Typography>
          <Chip label={complaint.strStatus} color="primary" variant="outlined" />
        </FlexBetween>
        <FlexBetween>
          <Typography variant="h5" color={theme.palette.grey[500]}>
            User
          </Typography>
          <Chip
            variant="outlined"
            avatar={
              <Avatar>
                {complaint.strUserName ? complaint.strUserName[0] : ""}
              </Avatar>
            }
            label={complaint.strUserName}
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
            label={DateFormatterEn(complaint.dtmDateCreated)}
            color="primary"
          />
        </FlexBetween>
      </Stack>
    </Box>
  );
};

export default ComplaintDetails;
