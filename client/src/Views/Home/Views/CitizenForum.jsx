import React, { useEffect, useState } from "react";
import { Typography, Button, Box, Grid } from "@mui/material";
import ComplaintPost from "../Component/ComplaintPost";
import GetComplaintDetails from "../Service/GetComplaintDetails";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import CustomFilter from "../Component/CustomFilter"

function CitizenForum() {
  const [comDet, setCompDet] = useState([]);
  const [complaintLimit, setComplaintLimit] = useState(20);
  const [selectedCompId, setSelectedCompId] = useState(null);

  useEffect(() => {
    const setViewComplaintDetails = async () => {
      try {
        const response = await GetComplaintDetails();
        setCompDet(response.data);
      } catch (error) {
        console.error(error);
      }
    };
    setViewComplaintDetails();
  }, []);

  const handleViewMore = () => {
    setComplaintLimit((prevLimit) => prevLimit + 20);
  };

  const handleSelectComplaint = (compId) => {
    setSelectedCompId(compId);
  };

  return (
    <div>
      <Typography variant="h1" component="h1">
        Public Forum
      </Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}> {/* ComplaintPost component takes 8 columns on larger screens */}
          <FlexBetween>
            <ComplaintPost data={comDet.slice(0, complaintLimit)} />
          </FlexBetween>
          {complaintLimit < comDet.length && (
            <Box display="flex" justifyContent="center" mt={2}>
              <Button variant="contained" onClick={handleViewMore}>
                View More
              </Button>
            </Box>
          )}
          <br/>
          <br/>
        </Grid>
        <Grid item xs={12} md={4}> {/* Filter component takes 4 columns on larger screens */}
          <CustomFilter /> {/* Render the CustomFilter component */}
        </Grid>
      </Grid>
    </div>
  );
}

export default CitizenForum;
