import React, { useState, useEffect } from "react";

//axios
import axios from "../../../Common/Utils/AxiosAgent";


// Mui
import { Typography, SwipeableDrawer } from "@mui/material";

// Project Imports
import { GetUserComplaints } from "../Service/GetUserComplaints";
import ComplaintsDataGrid from "../Components/UserComplaintsDataGrid";
import ComplaintEvaluation from "../Components/ComplaintEvaluation";
import TaskCreation from "../../TaskCreation";
import ScrollableContent from "../../../Common/Components/ScrollableContent";
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";
import { deleteComplaint } from "../Service/DeleteComplaint";

const CitizenViewComplaints = () => {
  const [complaint, setComplaint] = useState({ lstMedia: [] });
  const [complaints, setComplaints] = useState([]);

  const [approved, setApproved] = useState(false);
  const [drawerOpen, setDrawerOpen] = useState(false);

  useEffect(() => {
    const setComplaintsView = async () => {
      const response = await GetUserComplaints();
      setComplaints(response);
    };
    setComplaintsView();
  }, []);

  const FormatDate = () => {
    return complaints.map((complaint) => ({
      ...complaint,
      dtmDateCreated: DateFormatterEn(complaint.dtmDateCreated),
      lstMedia: complaint.lstMedia || [], // Handle the case when lstMedia is not available
    }));
  };



  const photos = complaint.lstMedia.map((media, index) => ({
    media: `data:image/jpg;base64, ${media}`,
    title: complaint.intComplaintId + "-" + index,
  }));


  const editComplaint = (editedComplaint) => {
    // Update the complaints array with the edited complaint
    setComplaints((prevComplaints) =>
      prevComplaints.map((complaint) =>
        complaint.intComplaintId === editedComplaint.intComplaintId ? editedComplaint : complaint
      )
    );
  };

  return (
    <div>
      <Typography variant="h1">View Complaints</Typography>
      <ComplaintsDataGrid
        data={FormatDate()}
        deleteComplaint={async (complaintId) => {
          const success = await deleteComplaint(complaintId);
          if (success) {
            setComplaints((prevComplaints) =>
              prevComplaints.filter((complaint) => complaint.intComplaintId !== complaintId)
            );
          }
        }}
        editComplaint={editComplaint}

      />


      <SwipeableDrawer
        anchor="right"
        open={drawerOpen}
        onClose={() => setDrawerOpen(false)}
        onOpen={() => setDrawerOpen(true)}
        PaperProps={{ style: { width: "65%" } }}
      >
        <ScrollableContent>
          {approved ? (
            <TaskCreation
              photos={photos}
              complaint={complaint}
              CloseDrawer={() => setDrawerOpen(false)}
            />
          ) : (
            <ComplaintEvaluation
              photos={photos}
              complaint={complaint}
              setApproved={setApproved}
            />
          )}
        </ScrollableContent>
      </SwipeableDrawer>
    </div>
  );
};

export default CitizenViewComplaints;
