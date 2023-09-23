import React, { useState, useEffect } from "react";

// Mui
import { Typography, SwipeableDrawer } from "@mui/material";
import ArrowCircleUpIcon from '@mui/icons-material/ArrowCircleUp';
import ArrowCircleDownIcon from '@mui/icons-material/ArrowCircleDown';

// Project Imports
import { GetComplaintsApi } from "../Service/GetComplaintsApi";
import ComplaintsDataGrid from "../Components/ComplaintsDataGrid";
import { GetComplaintByidApi } from "../Service/GetComplaintByidApi";
import ComplaintEvaluation from "../Components/ComplaintEvaluation";
import TaskCreation from "../../TaskCreation";
import ScrollableContent from "../../../Common/Components/ScrollableContent";
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";

const AdminViewComplaints = () => {
  const [complaint, setComplaint] = useState({ lstMedia: [] });
  const [complaints, setComplaints] = useState([]);

  const [approved, setApproved] = useState(false);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [pageNumber, setPageNumber] = useState(1);
  const pageSize = 20;

  useEffect(() => {
    const setComplaintsView = async () => {
      const response = await GetComplaintsApi(pageSize, pageNumber);
      setComplaints(response.data);
    };
    setComplaintsView();
  }, [pageSize, pageNumber]);

  const setComplaintById = async (params) => {
    try {
      const response = await GetComplaintByidApi(params);
      setComplaint(response.data);
      setApproved(false);
      setDrawerOpen(true);
    } catch (error) {
      console.error("Error fetching complaint:", error);
    }
  }

  const decodeBase64Image = (base64Data) => {
    return `data:image/jpg;base64,${base64Data}`;
  };


  const FormatDate = () => {
    const rows = [...complaints];
    rows.forEach((c) => (c.dtmDateCreated = DateFormatterEn(c.dtmDateCreated)));
    return rows;
  };

  const handleArrowUp = () => {
    setPageNumber((prevPageNumber) => prevPageNumber + 1);
  };

  const handleArrowDown = () => {
    if (pageNumber > 1) {
      setPageNumber((prevPageNumber) => prevPageNumber - 1);
    }
  };

  return (
    <div>
      <Typography variant="h1" sx={{fontFamily: 'Droid Arabic Naskh, sans-serif' }}>عرض المشاكل</Typography>
      <ComplaintsDataGrid
        data={FormatDate()}
        AddComplaint={setComplaintById}
      />
      <div style={{ textAlign: "center", }}>
        <ArrowCircleDownIcon
          onClick={handleArrowUp}
          style={{ cursor: "pointer", marginRight: "1rem" }}
        />
        <ArrowCircleUpIcon
          onClick={handleArrowDown}
          style={{ cursor: "pointer" }}
        />
      </div>

      <SwipeableDrawer
        anchor="right"
        open={drawerOpen}
        onClose={() => setDrawerOpen(false)}
        onOpen={() => setDrawerOpen(true)}
        PaperProps={{ style: { width: "45%" } }}
      >
        <ScrollableContent>
          {approved ? (
            <TaskCreation
              photos={complaint.lstMedia}
              complaint={complaint}
              complaints={complaints} //this for bring data
              CloseDrawer={() => setDrawerOpen(false)}
            />
          ) : (
            <ComplaintEvaluation
              photos={complaint.lstMedia} //send the photo to the task creation
              complaint={complaint}
              setApproved={setApproved}
            />
          )}
        </ScrollableContent>
      </SwipeableDrawer>
    </div>
  );
};

export default AdminViewComplaints;
