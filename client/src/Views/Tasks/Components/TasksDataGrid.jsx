import { useEffect, useState } from "react";

import { Box, IconButton, Avatar, Chip, useTheme } from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { CheckCircleOutline } from "@mui/icons-material/";

// Project Imports
import { GetTasksApi } from "../Service/GetTasksApi";
import { deleteTasks } from "../Service/DeleteTask";

// icons
import DeleteForeverIcon from '@mui/icons-material/DeleteForever';

function StatusColor(status) {
  switch (status) {
    case "Completed":
      return "success";
    case "Failed":
      return "error";
    case "In Progress":
      return "secondary";
    case "Incomplete":
      return "primary";
    case "Pending":
      return "info";
    default:
      return "primary";
  }
}

const TasksDataGrid = ({ EvaluateTask, pageSize, pageNumber, selectedStatus, selectedTaskType,refreshDataGrid }) => {
  const theme = useTheme();
  const [tasks, setTasks] = useState([]);
  useEffect(() => {


    const setTasksView = async () => {
      const response = await GetTasksApi(pageSize, pageNumber, selectedStatus, selectedTaskType);
      setTasks(response);
    };
    setTasksView();
    // fetchData();
  }, [pageSize, pageNumber, selectedStatus, selectedTaskType,refreshDataGrid]);

  const [taskToDelete, setTaskToDelete] = useState(null);

  const handleDeleteTask = async (taskIdToDelete) => {
    try {
      await deleteTasks(taskIdToDelete); // Call your deleteTask API function
      const updatedTasks = tasks.filter((task) => task.id !== taskIdToDelete);
      setTasks(updatedTasks);
    } catch (error) {
      console.error("Error deleting task:", error);
    }
  };




  const columns = [
    {
      field: "button",
      headerName: "Evaluate",
      renderCell: (params) => (
        <IconButton
          variant="contained"
          color="primary"
          onClick={() => EvaluateTask(params.row.id, params.row.admin)}
        >
          <CheckCircleOutline />
        </IconButton>
      ),
    },
    { field: "id", headerName: "ID", flex: 0.5 },
    {
      field: "admin",
      headerName: "Admin",
      flex: 1,
      renderCell: (params) => (
        <Chip
          variant="outlined"
          avatar={<Avatar>{params.row.admin[0]}</Avatar>}
          label={params.row.admin}
          sx={{
            "& .MuiChip-label": { color: theme.palette.grey[500] },
          }}
        />
      ),
    },
    { field: "type", headerName: "Type", flex: 1 },
    { field: "cost", headerName: "Cost", flex: 1 },
    { field: "dateScheduled", headerName: "Date Scheduled", flex: 1 },
    { field: "deadline", headerName: "Deadline", flex: 1 },
    {
      field: "status",
      headerName: "Status",
      flex: 1,
      renderCell: (params) => (
        <Chip
          label={params.row.status}
          color={StatusColor(params.row.status)}
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
      field: "Action",
      headerName: "Action",
      renderCell: (params) => (
        <IconButton
          variant="contained"
          color="primary"
          onClick={() => handleDeleteTask(params.row.id)}
        >
          <DeleteForeverIcon />
        </IconButton>
      ),
    },
  ];

  return (
    <Box margin="2rem 0 0 0" height="75vh">
      <DataGrid
        rows={tasks}
        columns={columns}
        components={{ Toolbar: GridToolbar }}
        density="compact"
      />
    </Box>
  );
};

export default TasksDataGrid;