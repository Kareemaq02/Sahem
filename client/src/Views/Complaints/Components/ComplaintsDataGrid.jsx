import React from "react";
import {
  Box,
  Chip,
  Typography,
  Slider,
  useTheme,
  IconButton,
  Avatar,
} from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import {
  AddCircleOutline,
  ArrowCircleUp,
  Info,
  Error,
  CheckCircle,
  Schedule,
  DoneAll,
  Help,
} from "@mui/icons-material/";

function StatusIcon(status) {
  switch (status) {
    case "pending":
      return <Schedule />;
    case "rejected":
      return <Error />;
    case "approved":
      return <Info />;
    case "in progress":
      return <Help />;
    case "waiting evaluation":
      return <Info />;
    case "completed":
      return <CheckCircle />;
    case "re-filed":
      return <DoneAll />;
    default:
      return <Info />;
  }
}

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

const ComplaintsDataGrid = ({ AddComplaint, data }) => {
  const theme = useTheme();
  const columns = [
    {
      field: "button",
      headerName: "Action",
      renderCell: (params) => (
        <IconButton
          variant="contained"
          color="primary"
          onClick={() => AddComplaint(params.row.intComplaintId)}
        >
          <AddCircleOutline />
        </IconButton>
      ),
    },
    { field: "intComplaintId", headerName: "ID", flex: 0.5 },
    {
      field: "strUserName",
      headerName: "User",
      flex: 0.8,
      renderCell: (params) => (
        <Chip
          variant="outlined"
          avatar={<Avatar>{params.row.strUserName[0]}</Avatar>}
          label={params.row.strUserName}
          sx={{
            "& .MuiChip-label": { color: theme.palette.grey[500] },
          }}
        />
      ),
    },
    { field: "strComplaintTypeAr", headerName: "Type", flex: 1 },
    {
      field: "decPriority",
      headerName: "Priority",
      flex: 1,
      renderCell: (params) => (
        <Box display="flex" alignItems="center" gap="0.5rem">
          <ArrowCircleUp />
          <Slider
            sx={{
              width: "8rem",
              height: "0.7rem",
              "& .MuiSlider-track": {
                backgroundImage: `linear-gradient(90deg, ${theme.palette.primary.main} 0%,  ${theme.palette.secondary.main} 100%)`,
              },
              "& .MuiSlider-thumb": {
                display: "none",
              },
            }}
            defaultValue={params.row.decPriority * 100}
            disabled
          />
          <Typography variant="body2">
            {(params.row.decPriority * 100).toFixed(2)}%
          </Typography>
        </Box>
      ),
    },
    { field: "dtmDateCreated", headerName: "Date Created", flex: 1 },
    {
      field: "strStatus",
      headerName: "Status",
      flex: 1,
      renderCell: (params) => (
        <Chip
          label={params.row.strStatus}
          color={StatusColor(params.row.strStatus)}
          icon={StatusIcon(params.row.strStatus)}
          variant="outlined"
          sx={{
            width: "60%",
            height: "100%",
            backgroundColor: "rgba(0, 0, 0, 0.05)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
          }}
        />
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
    </Box>
  );
};

export default ComplaintsDataGrid;
