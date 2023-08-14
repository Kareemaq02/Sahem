import React, { useState, useEffect } from "react";
import {
  Box,
  IconButton,
  Avatar,
  Chip,
  Typography,
  Slider,
  useTheme,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
} from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { AddCircleOutline, ArrowCircleUp } from "@mui/icons-material/";
import ClearIcon from "@mui/icons-material/Clear";
import EditIcon from "@mui/icons-material/Edit";
import axios from "../../../Common/Utils/AxiosAgent";
// import ComplaintsTypesApi from "../Service/GetComplaintTypesApi";

function StatusColor(status) {
  switch (status) {
    case "pending":
      return "info";
    case "rejected":
      return "error";
    case "approved":
      return "primary";
    case "in progress":
      return "secondary";
    case "waiting evaluation":
      return "primary";
    case "completed":
      return "success";
    case "re-filed":
      return "default";
    default:
      return "primary";
  }
}

const ComplaintsDataGrid = ({ editComplaint, deleteComplaint, data }) => {
  const theme = useTheme();
  const [openEditDialog, setOpenEditDialog] = useState(false);
  const [selectedComplaint, setSelectedComplaint] = useState(null);
  const [editFormData, setEditFormData] = useState({
    comment: "",
    status: "",
  });
  const [complaintTypes, setComplaintTypes] = useState([]);

  // useEffect(() => {
  //   const fetchComplaintTypes = async () => {
  //     try {
  //       const response = await ComplaintsTypesApi();
  //       setComplaintTypes(response.data);
  //     } catch (error) {
  //       console.error("Failed to fetch complaint types:", error);
  //     }
  //   };

  //   fetchComplaintTypes();
  // }, []);

  const handleOpenEditDialog = (complaint) => {
    setSelectedComplaint(complaint);
    const selectedComplaintType = complaintTypes.find(
      (complaintType) =>
        complaintType.strNameEn === complaint.strComplaintTypeEn
    );
    setEditFormData({
      comment: complaint.comment || "", // Updated line
      status: selectedComplaintType ? selectedComplaintType.strNameEn : "",
    });
    setOpenEditDialog(true);
  };

  const handleCloseEditDialog = () => {
    setOpenEditDialog(false);
  };

  const handleEditFormChange = (event) => {
    setEditFormData((prevState) => ({
      ...prevState,
      [event.target.name]: event.target.value,
    }));
  };

  const handleEditFormSubmit = async () => {
    if (selectedComplaint) {
      const editedComplaint = {
        ...selectedComplaint,
        strComment: editFormData.comment, // Updated line,
        strComplaintTypeEn: editFormData.status,
      };

      try {
        const response = await axios.put(
          `/api/complaints/update/${editedComplaint.intComplaintId}`,
          editedComplaint
        );

        // Handle the response if necessary

        editComplaint(editedComplaint);
        handleCloseEditDialog();
      } catch (error) {
        console.error("Failed to update complaint:", error);
      }
    }
  };

  const columns = [
    { field: "intComplaintId", headerName: "ID", flex: 0.5 },
    { field: "strComplaintTypeEn", headerName: "Type", flex: 1 },
    { field: "dtmDateCreated", headerName: "Date Created", flex: 1 },
    {
      field: "strStatus",
      headerName: "Status",
      flex: 1,
      renderCell: (params) => (
        <Chip
          label={params.row.strStatus}
          color={StatusColor(params.row.strStatus)}
          variant="outlined"
          sx={{
            width: "7rem",
            height: "1.5rem",
            backgroundColor: "rgba(0,0,0,0.05)",
          }}
        />
      ),
    },
    {
      field: "edit",
      headerName: "Action",
      renderCell: (params) => (
        <div>
          <IconButton
            variant="contained"
            color="primary"
            onClick={() => handleOpenEditDialog(params.row)}
          >
            <EditIcon />
          </IconButton>
          <IconButton
            variant="contained"
            onClick={() => deleteComplaint(params.row.intComplaintId)}
          >
            <ClearIcon style={{ color: "red" }} />
          </IconButton>
        </div>
      ),
    },
  ];

  return (
    <Box margin="2rem 0 0 0" height="75vh">
      <DataGrid
        rows={data}
        columns={columns}
        getRowId={(row) => row.intComplaintId}
        components={{ Toolbar: GridToolbar }}
        density="compact"
      />

      {/* Edit Dialog */}
      <Dialog
        open={openEditDialog}
        onClose={handleCloseEditDialog}
        sx={{
          "& .MuiDialog-paper": {
            width: "80%",
            maxWidth: "1200px",
          },
        }}
      >
        <DialogTitle sx={{ fontSize: "24px" }}>Edit Complaint</DialogTitle>

        <DialogContent sx={{ overflow: "auto" }}>
          <FormControl
            fullWidth
            sx={{ marginBottom: "0.5rem", paddingTop: "0.5rem" }}
          >
            {/* Rest of the code */}
          </FormControl>
          <FormControl fullWidth sx={{ marginBottom: "1rem" }}>
            <InputLabel id="type-select-label">Complaint Type</InputLabel>
            <Select
              labelId="type-select-label"
              id="type-select"
              name="status"
              value={editFormData.status}
              onChange={handleEditFormChange}
              fullWidth
            >
              {complaintTypes.map((complaintType) => (
                <MenuItem
                  key={complaintType.id}
                  value={complaintType.strNameEn}
                >
                  {complaintType.strNameEn}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
          <TextField
            label="Comment"
            id="comment-input"
            name="comment"
            value={editFormData.comment}
            onChange={handleEditFormChange}
            fullWidth
            multiline
            rows={4}
            sx={{ marginBottom: "1rem" }}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseEditDialog}>Cancel</Button>
          <Button onClick={handleEditFormSubmit} color="primary">
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default ComplaintsDataGrid;
