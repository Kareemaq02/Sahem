import { Box, Button, TextField } from "@mui/material";
import { FormProvider, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import ComplaintsTypesApi from "../Service/ComplaintTypesApi";

const complaintsTypeFormValidation = yup.object().shape({
  intDepartmentId: yup.number().integer().typeError("Invalid data type, must enter a number").required("Invalid entry this field is required"),
  strNameAr: yup.string().typeError("Invalid data type, must enter a name").matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers").required("Invalid entry this field is required"),
  strNameEn: yup.string().typeError("Invalid data type, must enter a name").matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers").required("Invalid entry this field is required"),
  intPrivacyId: yup.number().integer().typeError("Invalid data type, must enter a number").required("Invalid entry this field is required"),
  decGrade: yup.number().integer().typeError("Invalid data type, must enter a number").required("Invalid entry this field is required"),
});

const ComplaintsTypeForm = () => {
  const methods = useForm({
    resolver: yupResolver(complaintsTypeFormValidation), 
  });

  const onSubmit = async (data) => {
    try {
      await ComplaintsTypesApi(data);
      console.log("Conn...");
      console.log("Done.. OK");
    } catch (error) {
      console.log("Error While Connect.");
    }
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={methods.handleSubmit(onSubmit)}>
        <FormTextField name="intDepartmentId" label="Department ID" />
        <br />
        <br />
        <FormTextField name="strNameAr" label="Arabic Name" />
        <br />
        <br />
        <FormTextField name="strNameEn" label="English Name" />
        <br />
        <br />
        <FormTextField name="intPrivacyId" label="Privacy" />
        <br />
        <br />
        <FormTextField name="decGrade" label="Grade" />
        <br />
        <br />
        <Button type="submit" sx={{ width: "100%" }} variant="contained">
          Add
        </Button>
      </form>
    </FormProvider>
  );
};

export default ComplaintsTypeForm;
