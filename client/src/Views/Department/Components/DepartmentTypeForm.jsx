import { Box, Button, TextFieldt, Typography, Paper } from "@mui/material";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { FormProvider, useForm } from "react-hook-form";
import DepartmentTypeApi from "../Service/DepartmentTypeApi";
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";


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

  const onSubmit = async (data) => {
    try {
      await DepartmentTypeApi(data);
      console.log("Conn...");
      console.log("Done.. OK");
      refreshDataGrid(prevData => [...prevData, data]); // Add the new department to the data array

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
            Add
          </Button>
        </form>
      </FormProvider>
    </Paper>
  );
};

export default DepartmentTypeForm;