import { Box, Button, TextFieldt, Typography } from "@mui/material";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { FormProvider, useForm } from "react-hook-form";
import DepartmentTypeApi from "../Service/DepartmentTypeApi";
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";


const departmentTypeFormValidation = yup.object().shape({
  strNameAr: yup.string().typeError("Invalid data type, must enter a name").matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers").required("Invalid entry this field is required"),
  strNameEn: yup.string().typeError("Invalid data type, must enter a name").matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers").required("Invalid entry this field is required"),
});


const DepartmentTypeForm = () => {
  const methods = useForm({
    resolver: yupResolver(departmentTypeFormValidation), 
  });

  const onSubmit = async (data) => {
    try {
      await DepartmentTypeApi(data);
      console.log("Conn...");
      console.log("Done.. OK");
    } catch (error) {
      console.log("Error While Connect.");
    }
  };

  return (
    <Box
      sx={{
        width: '70%',
        margin: '0 auto',
        padding: '20px',
        border: '1px solid #ccc',
        borderRadius: '8px',
        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
        // backgroundColor: '#f5f5f5',
      }}
    >
      <Typography variant="h2" sx={{ marginBottom: '20px' }}>
        Insert Department Type
      </Typography>
      <FormProvider {...methods}>
        <form onSubmit={methods.handleSubmit(onSubmit)}>
          <FormTextField name="strNameAr" label="Arabic Name" />
          <br />
          <br />
          <FormTextField name="strNameEn" label="English Name" />
          <br />
          <br />
          <Button variant="contained" type="submit" sx={{ width: '100%' }}>
            Add
          </Button>
        </form>
      </FormProvider>
    </Box>
  );
};

export default DepartmentTypeForm;