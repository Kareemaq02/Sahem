import { Box, Button, TextField, Typography, Select, MenuItem, Paper } from "@mui/material";
import { FormProvider, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import ComplaintsTypesApi from "../Service/ComplaintTypesApi";
import { GetDepartmentApi } from "../../../Common/Services/GetDepartmentApi";
import { useEffect, useState } from "react";


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

  const onSubmit = async (data) => {
    try {
      await ComplaintsTypesApi(data);
      console.log("Conn...");
      console.log("Done.. OK");
      refreshData(prevData => [...prevData, data]);

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
        <Typography variant="h2" sx={{ p: 1, textAlign: 'center' }}>
          Insert Complaint Type
        </Typography>
        <FormProvider {...methods}>
          <form onSubmit={methods.handleSubmit(onSubmit)}>
            <Select
              name="intDepartmentId"
              {...methods.register("intDepartmentId")}
              style={{ width: "100%" }}
            >
              <MenuItem value="">Select Department</MenuItem>
              {dep.map((department) => (
                <MenuItem key={department.intId} value={department.intId}>
                  {department.strNameAr}
                </MenuItem>
              ))}
            </Select>
            <br />
            <br />
            <FormTextField name="strNameAr" label="Arabic Name" />
            <br />
            <br />
            <FormTextField name="strNameEn" label="English Name" />
            <br />
            <br />
            <Typography variant="subtitle1" sx={{ marginBottom: '8px' }}>
              Privacy Level
            </Typography>
            <Select
              name="intPrivacyId"
              {...methods.register('intPrivacyId')}
              style={{ width: '100%' }} // Apply the width styling
            >
              <MenuItem value="">Select Privacy Level</MenuItem>
              <MenuItem value="1">Level 1</MenuItem>
              <MenuItem value="2">Level 2</MenuItem>
              <MenuItem value="3">Level 3</MenuItem>
            </Select>
            <br />
            <br />
            <FormTextField name="decGrade" label="Grade" />
            <br />
            <br />
            <Button type="submit" sx={{ width: '100%' }} variant="contained">
              Add
            </Button>
          </form>
        </FormProvider>
      </Paper>
    );
  };

  export default ComplaintsTypeForm;