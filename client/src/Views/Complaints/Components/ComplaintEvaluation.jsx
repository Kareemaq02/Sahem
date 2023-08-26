import React from "react";

// Mui
import { Button, Stack, Typography, IconButton, useTheme } from "@mui/material";
import { ChevronLeftOutlined } from "@mui/icons-material/";

// Project Imports
import ComplaintDetails from "./ComplaintDetails";
import MediaGallery from "../../../Common/Components/MediaGallery";

// slider
import Slider from 'react-slick';
import 'slick-carousel/slick/slick.css';
import 'slick-carousel/slick/slick-theme.css';


const ComplaintEvaluation = ({ photos, complaint, setApproved }) => {
  const theme = useTheme();
  return (
    <Stack spacing={2}>
      <Typography
        variant="h2"
        sx={{ display: "flex", alignItems: "center", gap: "1rem" }}
      >
        Evaluate Complaint
      </Typography>
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

      <ComplaintDetails theme={theme} complaint={complaint} />
      <Stack direction="row" spacing={2}>
        <Button
          variant="outlined"
          color="error"
          sx={{
            flex: "1 1 auto",
            borderRadius: "1rem",
          }}
        >
          Reject
        </Button>
        <Button
          onClick={() => setApproved(true)}
          variant="contained"
          color="success"
          sx={{
            flex: "1 1 auto",
            borderRadius: "1rem",
          }}
        >
          Next
        </Button>
      </Stack>
    </Stack>
  );
};

export default ComplaintEvaluation;
