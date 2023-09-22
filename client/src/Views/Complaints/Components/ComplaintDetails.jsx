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
        <Box width="100%">
          <Typography variant="h2" sx={{direction: 'rtl', fontFamily: 'Droid Arabic Naskh, sans-serif'}}>{complaint.strComplaintTypeAr}</Typography>
          <Typography variant="h6" color={theme.palette.grey[500]} sx={{direction: 'rtl', fontFamily: 'Droid Arabic Naskh, sans-serif'}}>
            عنوان المشكلة
          </Typography>
        </Box>
        <Divider variant="middle" />
        <FlexBetween>
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
          <Typography variant="h4">Details</Typography>
        </FlexBetween>
        <FlexBetween>
          <Chip label={complaint.strStatus} color="primary" variant="outlined" />
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }} >
            الحالة
          </Typography>
        </FlexBetween>
        <FlexBetween>
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
              direction: 'rtl',
              p: 1,
            }}
          />
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            المستخدم
          </Typography>
        </FlexBetween>
        <FlexBetween>
          <Chip
            variant="outlined"
            icon={<CalendarMonth color="primary" />}
            label={DateFormatterEn(complaint.dtmDateCreated)}
            color="primary"
          />
          <Typography variant="h5" color={theme.palette.grey[500]} sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
            تاريخ الانشاء
          </Typography>
        </FlexBetween>
      </Stack>
    </Box>
  );
};

export default ComplaintDetails;
