import { useEffect, useState } from "react";

import { Box, IconButton, Avatar, Chip, useTheme } from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { CheckCircleOutline } from "@mui/icons-material/";

// Project Imports
import { GetTasksApi } from "../Service/GetTasksApi";
import { deleteTasks } from "../Service/DeleteTask";
import DeleteConfirmationDialog from "./DeleteConfirmationDialog ";
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

const TasksDataGrid = ({ EvaluateTask, pageSize, pageNumber, selectedStatus, selectedTaskType, refreshDataGrid }) => {
  const theme = useTheme();
  const [tasks, setTasks] = useState([]);
  const [taskToDelete, setTaskToDelete] = useState(null);
  const [deleteConfirmationOpen, setDeleteConfirmationOpen] = useState(false); // State for dialog



  useEffect(() => {
    const setTasksView = async () => {
      const response = await GetTasksApi(pageSize, pageNumber, selectedStatus, selectedTaskType);
      setTasks(response);
    };
    setTasksView();
    // fetchData();
  }, [pageSize, pageNumber, selectedStatus, selectedTaskType, refreshDataGrid]);





  const handleDeleteTask = (taskIdToDelete) => {
    setTaskToDelete(taskIdToDelete);
    setDeleteConfirmationOpen(true);
  };

  const confirmDelete = async () => {
    try {
      await deleteTasks(taskToDelete); // Call your deleteTask API function
      const updatedTasks = tasks.filter((task) => task.id !== taskToDelete);
      setTasks(updatedTasks);
      setTaskToDelete(null);
    } catch (error) {
      console.error("Error deleting task:", error);
    }
  };




  const columns = [
    {
      field: "button",
      headerName: "تقييم العمل",
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
    { field: "id", headerName: "رقم", flex: 0.5 },
    {
      field: "admin",
      headerName: "المسؤول",
      flex: 1,
      renderCell: (params) => (
        <Chip
          variant="outlined"
          avatar={<Avatar>{params.row.admin[0]}</Avatar>}
          label={params.row.admin}
          sx={{
            "& .MuiChip-label": { color: theme.palette.grey[500] },
            p: 1
          }}
        />
      ),
    },
    { field: "typeAr", headerName: "النوع", flex: 1 },
    { field: "cost", headerName: "التكلفة", flex: 1 },
    { field: "dateScheduled", headerName: "تاريخ العمل", flex: 1 },
    { field: "deadline", headerName: "تاريخ الانتهاء", flex: 1 },
    {
      field: "status",
      headerName: "الحالة",
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
      headerName: "حذف",
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
        sx={{ fontSize: 'medium', fontFamily: 'Droid Arabic Naskh, sans-serif', }}
      />
      <DeleteConfirmationDialog
        open={deleteConfirmationOpen}
        onClose={() => setDeleteConfirmationOpen(false)}
        onDelete={confirmDelete}
      />
    </Box>
  );
};

export default TasksDataGrid;