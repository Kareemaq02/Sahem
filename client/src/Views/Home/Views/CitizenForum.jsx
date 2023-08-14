import React, { useEffect, useState } from "react";
import { Typography, Box, Grid, IconButton } from "@mui/material";
import ComplaintPost from "../Component/ComplaintPost";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import CustomFilter from "../Component/CustomFilter";
import ArrowForwardIcon from "@mui/icons-material/ArrowForward";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import GetComplaintDetails from "../Service/GetComplaintDetails";

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
          null // Replace 'null' with the actual date value, if needed
        );
        setCompDet(response.data);
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
      <Typography variant="h1" component="h1">
        Public Forum
      </Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}>
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

        <Grid item xs={12} md={4}>
          {/* Pass the handleComplaintTypesChange function as a prop */}
          <CustomFilter onComplaintTypesChange={handleComplaintTypesChange} onComplaintStatusChange={handleComplaintStatusChange} />
        </Grid>
      </Grid>
      <br />
      <br />
    </div>
  );
}

export default CitizenForum;