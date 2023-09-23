import { Box, Button, TextField, Typography, Select, MenuItem, Paper } from "@mui/material";
import { FormProvider, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import ComplaintsTypesApi from "../Service/ComplaintTypesApi";
import { GetDepartmentApi } from "../../../Common/Services/GetDepartmentApi";
import { useEffect, useState } from "react";
import { Snackbar, Alert } from '@mui/material';


const complaintsTypeFormValidation = yup.object().shape({
  intDepartmentId: yup.number().integer().typeError("Invalid data type, must enter a number").required("Invalid entry this field is required"),
  strNameAr: yup
    .string()
    .typeError("Invalid data type, must enter a name")
    .matches(/^[\p{L}\s]*$/u, "Invalid entry, must not contain numbers")
    .required("This field is required"),
  strNameEn: yup.string().typeError("Invalid data type, must enter a name").matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers").required("Invalid entry this field is required"),
  intPrivacyId: yup.number().required("Invalid entry this field is required"),
  decGrade: yup.number().typeError("Invalid data type, must enter a number").required("Invalid entry this field is required").max(10, "Invalid Entery Value must be a maximum of 10"),
});


const ComplaintsTypeForm = ({ refreshData }) => {
  const methods = useForm({
    resolver: yupResolver(complaintsTypeFormValidation),
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
      await ComplaintsTypesApi(data);
      console.log("Conn...");
      console.log("Done.. OK");
      refreshData(prevData => [...prevData, data]);
      handleSnackbarOpen();
      //add navigator here
    } catch (error) {
      console.log("Error While Connect.");
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
        تم إضافة نوع الشكوى بنجاح!
        </Alert>
      </Snackbar>
        <Typography variant="h2" sx={{ p: 1, textAlign: 'center', fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
          اضافة نوع مشكلة جديد
        </Typography>
        <FormProvider {...methods}>
          <form onSubmit={methods.handleSubmit(onSubmit)}>
            <Select
              name="intDepartmentId"
              {...methods.register("intDepartmentId")}
              style={{ width: "100%" }}
            >
              <MenuItem value="">حدد القسم</MenuItem>
              {dep.map((department) => (
                <MenuItem key={department.intId} value={department.intId}>
                  {department.strNameAr}
                </MenuItem>
              ))}
            </Select>
            <br />
            <br />
            <FormTextField name="strNameAr" label="اسم عربي" />
            <br />
            <br />
            <FormTextField name="strNameEn" label="English Name" />
            <br />
            <br />
            <Typography variant="subtitle1" sx={{ marginBottom: '8px' }}>
            مستوى الخصوصية
            </Typography>
            <Select
              name="intPrivacyId"
              {...methods.register('intPrivacyId')}
              style={{ width: '100%' }} // Apply the width styling
            >
              <MenuItem value="">حدد مستوى الخصوصية</MenuItem>
              <MenuItem value="1">المستوى 1</MenuItem>
              <MenuItem value="2">المستوى 2</MenuItem>
              <MenuItem value="3">المستوى 3</MenuItem>
            </Select>
            <br />
            <br />
            <FormTextField name="decGrade" label="الدرجة" />
            <br />
            <br />
            <Button type="submit" sx={{ width: '100%' }} variant="contained">
              أضف
            </Button>
          </form>
        </FormProvider>
      </Paper>
    );
  };

  export default ComplaintsTypeForm;