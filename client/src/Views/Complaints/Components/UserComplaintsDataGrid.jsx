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
  Card,
  CardContent
} from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { AddCircleOutline, ArrowCircleUp } from "@mui/icons-material/";
import ClearIcon from "@mui/icons-material/Clear";
import EditIcon from "@mui/icons-material/Edit";
import axios from "../../../Common/Utils/AxiosAgent";
import ComplaintsTypesApi from "../Service/ComplaintsTypesApi";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import RadioButtonCheckedIcon from '@mui/icons-material/RadioButtonChecked';
import BorderColorIcon from '@mui/icons-material/BorderColor';
import DeleteIcon from '@mui/icons-material/Delete';
import { updateComplaint } from "../Service/UpdateComplaint"
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";

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


const DeleteConfirmationDialog = ({ open, onClose, onDelete }) => {
  return (
    <Dialog open={open} onClose={onClose}>
      <DialogTitle sx={{ fontSize: "24px" }}>Confirm Deletion</DialogTitle>
      <DialogContent>
        Are you sure you want to delete this complaint?
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} color="primary">
          Cancel
        </Button>
        <Button onClick={onDelete} color="error">
          Delete
        </Button>
      </DialogActions>
    </Dialog>
  );
};

const ComplaintsDataGrid = ({ editComplaint, deleteComplaint, data }) => {
  const theme = useTheme();
  const [openEditDialog, setOpenEditDialog] = useState(false);
  const [openDeleteConfirmation, setOpenDeleteConfirmation] = useState(false); // Added state for delete confirmation
  const [selectedComplaint, setSelectedComplaint] = useState(null);
  const [editFormData, setEditFormData] = useState({
    comment: "",
    status: "",
  });
  const [complaintTypes, setComplaintTypes] = useState([]);

  useEffect(() => {
    const fetchComplaintTypes = async () => {
      try {
        const response = await ComplaintsTypesApi();
        setComplaintTypes(response.data);
      } catch (error) {
        console.error("Failed to fetch complaint types:", error);
      }
    };

    fetchComplaintTypes();
  }, []);

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

  const handleDeleteConfirmation = (complaint) => {
    setSelectedComplaint(complaint);
    setOpenDeleteConfirmation(true);
  };

  const handleCloseDeleteConfirmation = () => {
    setSelectedComplaint(null);
    setOpenDeleteConfirmation(false);
  };

  const handleEditFormSubmit = async () => {
    if (selectedComplaint) {
      const editedComplaint = {
        ...selectedComplaint,
        strComment: editFormData.comment,
        strComplaintTypeEn: editFormData.status,
      };

      try {
        const success = await updateComplaint(
          editedComplaint.intComplaintId,
          editedComplaint
        );

        if (success) {
          editComplaint(editedComplaint);
          handleCloseEditDialog();
        } else {
          console.error("Failed to update complaint"); // Handle error if needed
        }
      } catch (error) {
        console.error("Failed to update complaint:", error);
      }

    }
  };


  /*const columns = [
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
*/
  return (
    <Box sx={{ display: "grid", gap: 2, width: '100%' }}>

      {data.map((complaint) => (
        <Card key={complaint.intComplaintId} sx={{ borderRadius: '25px' }}>
          <CardContent>
            <Typography variant="h3" component="div">
              <FlexBetween>
                بلاغ رقم: {complaint.intComplaintId}
                <Chip
                  icon={<RadioButtonCheckedIcon />}
                  color="primary"
                  label={complaint.strStatus}
                  variant="outlined"
                  sx={{ p: 1 }}
                />
              </FlexBetween>
            </Typography>
            <Typography variant="h5" component="div">
              {complaint.strComplaintTypeAr}
            </Typography>
            <Typography variant="body1" color="text.secondary">
              <IconButton onClick={() => handleOpenEditDialog(complaint)}>
                <BorderColorIcon sx={{ color: 'darkblue' }} />
              </IconButton>
              {/* add dialog to check if user want to delete the complaint */}
              <IconButton onClick={() => handleDeleteConfirmation(complaint)}>
                <DeleteIcon sx={{ color: 'darkblue' }} />
              </IconButton>
            </Typography>
            <Typography variant="h5">
              <FlexBetween>
                <Typography variant="h6"></Typography>
                <Typography variant="h6">{DateFormatterEn(complaint.dtmDateCreated)}</Typography>
              </FlexBetween>
            </Typography>
          </CardContent>
        </Card>
      ))}
      <br />
      <br />

      <DeleteConfirmationDialog
        open={openDeleteConfirmation}
        onClose={handleCloseDeleteConfirmation}
        onDelete={() => {
          deleteComplaint(selectedComplaint.intComplaintId);
          handleCloseDeleteConfirmation();
        }}
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
                  {complaintType.strNameAr}
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
