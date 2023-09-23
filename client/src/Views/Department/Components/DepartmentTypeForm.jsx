import { Box, Button, TextFieldt, Typography, Paper } from "@mui/material";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { FormProvider, useForm } from "react-hook-form";
import DepartmentTypeApi from "../Service/DepartmentTypeApi";
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";
import { Snackbar, Alert } from '@mui/material';
import { useState } from 'react';



const departmentTypeFormValidation = yup.object().shape({
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



const DepartmentTypeForm = ({ refreshDataGrid }) => {
  const methods = useForm({
    resolver: yupResolver(departmentTypeFormValidation),
  });

  const [openSnackbar, setOpenSnackbar] = useState(false);

  const handleSnackbarClose = () => {
    setOpenSnackbar(false);
  };
  
  const handleSnackbarOpen = () => {
    setOpenSnackbar(true);
  };
  


  const onSubmit = async (data) => {
    try {
      await DepartmentTypeApi(data);
      console.log("Conn...");
      console.log("Done.. OK");
      refreshDataGrid(prevData => [...prevData, data]); // Add the new department to the data array
      handleSnackbarOpen();

    } catch (error) {
      console.log("Error While Connect.");
    }
  };

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
      تم إضافة قسم جديد بنجاح!
      </Alert>
    </Snackbar>
      <Typography variant="h2" sx={{ p: 1, textAlign: 'center', fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
        اضافة قسم جديد
      </Typography>
      <FormProvider {...methods}>
        <form onSubmit={methods.handleSubmit(onSubmit)}>
          <FormTextField name="strNameAr" label="الاسم بالعربي" />
          <br />
          <br />
          <FormTextField name="strNameEn" label="الاسم بلانجليزي" />
          <br />
          <br />
          <Button variant="contained" type="submit" sx={{ width: '100%' }}>
          إضافة
          </Button>
        </form>
      </FormProvider>
    </Paper>
  );
};

export default DepartmentTypeForm;