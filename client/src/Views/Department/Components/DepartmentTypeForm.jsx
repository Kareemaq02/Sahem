import { Box, Button, TextFieldt } from "@mui/material";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { FormProvider, useForm } from "react-hook-form";
import DepartmentTypeApi from "../Service/DepartmentTypeApi";

const DepartmentTypeForm = () => {
  const methods = useForm();

  const onSubmit = async (data) => {
    try {
      await DepartmentTypeApi(data);
      console.log("conn...");
      console.log("Done.. OK");
    } catch (error) {
      console.log("connect Falied");
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
