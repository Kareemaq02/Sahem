import { Box, Button, TextFieldt } from "@mui/material";
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
    <FormProvider {...methods}>
      <form onSubmit={methods.handleSubmit(onSubmit)}>
        <FormTextField name="strNameAr" label="Arabic Name" />
        <br />
        <br />
        <FormTextField name="strNameEn" label="English Name" />
        <br />
        <br />
        <Button variant="contained" type="submit" sx={{ width: "100%" }}>
          Add
        </Button>
      </form>
    </FormProvider>
  );
};

export default DepartmentTypeForm;
