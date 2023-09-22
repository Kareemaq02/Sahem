import { Box, Button, TextField, Typography, Select, MenuItem, Paper } from "@mui/material";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { FormProvider, useForm } from "react-hook-form";
import InsertTaskType from "../Service/InsertTaskType";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import { GetDepartmentApi } from "../../../Common/Services/GetDepartmentApi";
import { useEffect, useState } from "react";
import { Snackbar, Alert } from '@mui/material';

const taskTypeFormValidation = yup.object().shape({
  intDepartmentId: yup.number().integer().typeError("Invalid data type, must enter a number").required("Invalid entry this field is required"),
  strNameAr: yup
    .string()
    .typeError("Invalid data type, must enter a name")
    .matches(/^[\p{L}\s]*$/u, "Invalid entry, must not contain numbers")
    .required("This field is required"),
  strNameEn: yup
    .string()
    .typeError("Invalid data type, must enter a name")
    .matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers")
    .required("This field is required"),
});

const AddTaskType = ({ refreshdata }) => {
  const [openSnackbar, setOpenSnackbar] = useState(false);

  const handleSnackbarClose = () => {
    setOpenSnackbar(false);
  };
  
  const handleSnackbarOpen = () => {
    setOpenSnackbar(true);
  };
  

  const methods = useForm({
    resolver: yupResolver(taskTypeFormValidation),
  });

  const onSubmit = async (data) => {
    try {
      const response = await InsertTaskType(data);
      console.log("Task type added successfully");
      console.log(response.data);
      const newTaskType = {
        ...response.data,
        id: response.data.intId,
      };

      refreshdata(prevData => [...prevData, newTaskType]);
      handleSnackbarOpen();
    } catch (error) {
      console.error("Failed to add task type", error);
    }
  };


  const [dep, setDep] = useState([]);

  useEffect(() => {
    const fetchDepartments = async () => {
      try {
        const response = await GetDepartmentApi();
        setDep(response.data);
      } catch (error) {
        console.error(error);
      }
    };

    fetchDepartments();
  }, []);


  return (
    <Paper
      sx={{
        p: 2,
        borderRadius: '25px'
      }}
    >
          <Snackbar
      open={openSnackbar}
      autoHideDuration={3000}
      onClose={handleSnackbarClose}
    >
      <Alert onClose={handleSnackbarClose} severity="success" sx={{ width: '100%' }}>
      تم إضافة نوع عمل جديد بنجاح!
      </Alert>
    </Snackbar>
      <Typography variant="h2" sx={{ textAlign: 'center', p: 1, fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
        اضافة نوع عمل جديد
      </Typography>
      <FormProvider {...methods}>
        <form onSubmit={methods.handleSubmit(onSubmit)}>
          <Select
            name="intDepartmentId"
            {...methods.register("intDepartmentId")}
            style={{ width: "100%" }}
          >
            <MenuItem value="">اختر القسم</MenuItem>
            {dep.map((department) => (
              <MenuItem key={department.intId} value={department.intId}>
                {department.strNameAr}
              </MenuItem>
            ))}
          </Select>          <br />
          <br />
          <FormTextField name="strNameAr" label="Arabic Name" />
          <br />
          <br />
          <FormTextField name="strNameEn" label="English Name" />
          <br />
          <br />
          <Button
            type="submit"
            variant="contained"
            color="primary"
            sx={{ width: '100%' }}
          >
            إضافة
          </Button>
        </form>
      </FormProvider>
    </Paper>
  );
};

export default AddTaskType;