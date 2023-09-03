import React, { useEffect, useState } from "react";
import { Typography, Box, Grid, IconButton } from "@mui/material";
import ComplaintPost from "../Component/ComplaintPost";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import CustomFilter from "../Component/CustomFilter";
// icons
import ArrowForwardIcon from "@mui/icons-material/ArrowForward";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
// project
import GetComplaintDetails from "../Service/GetComplaintDetails";
import GetComplaintImage from "../Service/GetComplaintImage";
import ScrollLock from 'react-scroll-lock-component';

function CitizenForum() {
  const [comDet, setCompDet] = useState([]);
  const [pageSize, setPageSize] = useState(10);
  const [pageNumber, setPageNumber] = useState(1);
  const [selectedComplaintTypes, setSelectedComplaintTypes] = useState([]);
  const [selectedStatus, setSelectedStatus] = useState([]);


  useEffect(() => {
    const fetchComplaints = async () => {
      try {
        const response = await GetComplaintDetails(
          pageNumber,
          pageSize,
          selectedComplaintTypes,
          selectedStatus,
          null 
        );

        const complaintsWithData = await Promise.all(response.data.map(async (complaint) => {
          const imageDataResponse = await GetComplaintImage(complaint.intComplaintId); 
          const imageData = imageDataResponse.data.lstMedia[0]?.data || "-1"; 

          return { ...complaint, imageData };
        }));

        setCompDet(complaintsWithData);
      } catch (error) {
        console.error(error);
      }
    };

    fetchComplaints();
  }, [pageNumber, pageSize, selectedComplaintTypes, selectedStatus]);



  const handlePageChange = (direction) => {
    if (direction === "prev" && pageNumber > 1) {
      setPageNumber((prevPageNumber) => prevPageNumber - 1);
    } else if (direction === "next") {
      setPageNumber((prevPageNumber) => prevPageNumber + 1);
    }
  };

  const handleComplaintTypesChange = (selectedComplaintTypeIds) => {
    setSelectedComplaintTypes(selectedComplaintTypeIds);
  };

  const handleComplaintStatusChange = (selectedStatusId) => {
    setSelectedStatus(selectedStatusId);
  };


  return (
    <div>

      <Grid container spacing={2} className="app-container">
 
        <Grid item xs={12} md={8} className="main-content">
          <FlexBetween>
            <ComplaintPost data={comDet} />
          </FlexBetween>

          <Box display="flex" justifyContent="center" mt={2} >
            <IconButton onClick={() => handlePageChange("prev")} disabled={pageNumber === 1}>
              <ArrowForwardIcon />
            </IconButton>
            <IconButton
              onClick={() => handlePageChange("next")}
              disabled={comDet.length < pageSize}
            >

              <ArrowBackIcon />
            </IconButton>

          </Box>
        </Grid>
        {/* <ScrollLock> */}
        <Grid item xs={12} md={4} className="custom-filter-container">
          {/* Pass the handleComplaintTypesChange function as a prop */}
          <CustomFilter onComplaintTypesChange={handleComplaintTypesChange} onComplaintStatusChange={handleComplaintStatusChange}  />
        </Grid>
        {/* </ScrollLock> */}
      </Grid>

      <br />
      <br />
    </div>
  );
}

export default CitizenForum;