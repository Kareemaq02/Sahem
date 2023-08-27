import React, { useState, useEffect } from 'react'
import { Box, Grid, Paper, Typography, Select, Chip, MenuItem } from "@mui/material";
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { DemoContainer } from '@mui/x-date-pickers/internals/demo';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import dayjs from 'dayjs';
import BarChartComponent from "../../Charts/Components/BarChartComponent";
import LineChartComponent from "../../Charts/Components/LineChartComponent";
import GeographyChartComp from "../../Charts/Components/GeographyChartComp";
import GetComplaintTypes from "../Service/GetComplaintTypes";
import FormDateTimePicker from '../../../Common/Components/UI/FormFields/FormDateTimePicker';

//Data
import { mockLineData } from "../../Charts/Services/mockData";
import { FlexBetween } from '../../../Common/Components/FlexBetween';

function AdminDashboard() {
  const [complaintTypes, setComplaintTypes] = useState([]);
  const [selectedComplaintTypes, setSelectedComplaintTypes] = useState([]);
  const [selectedDate, setSelectedDate] = useState(dayjs('2022-04-17'));
  const [totalComplaints, setTotalComplaints] = useState(0);


  useEffect(() => {
    const fetchComplaintTypes = async () => {
      try {
        const response = await GetComplaintTypes();
        setComplaintTypes(response.data);
      } catch (error) {
        console.error(error);
      }
    };

    fetchComplaintTypes();
  }, []);

  const handleDateChange = (newValue) => {
    setSelectedDate(newValue);
  };


  const handleComplaintTypesChange = (event) => {
    const selectedIds = event.target.value;
    setSelectedComplaintTypes(selectedIds);
    console.log(selectedIds);
  };

  const handleTotalComplaintsChange = (total) => {
    setTotalComplaints(total);
  };


  return (
    <>
      <Typography variant="h4" component="h1" gutterBottom>
        تخصيص التحليل
      </Typography>
      <Grid container spacing={3}>
        <Grid item xs={12} sx={{ display: 'flex' }}>
          <Paper sx={{ borderRadius: '1rem', p: 1, display: 'flex' }}>
            <Box sx={{ display: 'flex' }}>
              <Typography variant='h3' sx={{ display: 'grid', margin: 'auto 0' }}>اختيار النوع</Typography>
              <Box sx={{ pr: 2, width: "100%", }}>
                <Select
                  multiple
                  value={selectedComplaintTypes}
                  onChange={handleComplaintTypesChange}
                  sx={{ width: "100%", height: '100%' }}
                  renderValue={(selected) => (
                    <Box sx={{ display: "flex", flexWrap: "wrap" }}>
                      {selectedComplaintTypes.map((complaintTypeId) => {
                        const complaintType = complaintTypes.find((type) => type.intTypeId === complaintTypeId);
                        return (
                          <Chip key={complaintTypeId} label={complaintType.strNameEn} style={{ margin: 2 }} />
                        );
                      })}
                    </Box>
                  )}
                >
                  {complaintTypes.map((complaintType) => (
                    <MenuItem key={complaintType.intTypeId} value={complaintType.intTypeId}>
                      {complaintType.strNameAr}
                    </MenuItem>
                  ))}
                </Select>
              </Box>
              <Typography variant='h3' sx={{ pr: 1, display: 'grid', margin: 'auto 0' }}>اختيار التاريخ</Typography>
              <Box sx={{ pr: 2, }}>
                <LocalizationProvider dateAdapter={AdapterDayjs}>
                  <DemoContainer components={['DatePicker', 'DatePicker']}>
                    <DatePicker
                      label="اختيار تاريخ"
                      value={selectedDate}
                      onChange={handleDateChange}
                    />
                  </DemoContainer>
                </LocalizationProvider>
              </Box>
              <FlexBetween>
                <Typography variant='h3' sx={{ pr: 1, display: 'grid', margin: 'auto 0' }}>مجموع البلاغات</Typography>
                <Box
                  sx={{
                    display: 'grid',
                    alignItems: 'center',
                    justifyContent: 'center',
                    width: 50,
                    height: 50,
                    borderRadius: '50%',
                    backgroundColor: '#007BFF',
                    margin: 'auto',
                    marginTop: 'auto',
                    marginBottom: 'auto',
                    boxShadow: '0px 0px 10px rgba(0, 0, 0, 0.2)',

                  }}
                >
                  <Typography variant="h4" sx={{ color: 'white', padding: 1 }}>
                    {totalComplaints}
                  </Typography>
                </Box>
              </FlexBetween>


            </Box>


          </Paper>
        </Grid>
        <Grid item xs={12} sm={12}>
          <Paper sx={{ borderRadius: '1rem' }}>
            <BarChartComponent
              selectedComplaintTypes={selectedComplaintTypes}
              selectedDate={selectedDate.format('YYYY-MM-DDTHH:mm:ss')}
              onTotalComplaintsChange={handleTotalComplaintsChange}
            />
          </Paper>
        </Grid>
        <Grid item xs={12} sm={6}>
          <Paper sx={{ borderRadius: '1rem' }}>
            <LineChartComponent />
          </Paper>
        </Grid>
      </Grid>
      <br />
      <br />
    </>
  );
}

export default AdminDashboard;
