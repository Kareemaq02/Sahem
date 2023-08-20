import { Box, Button, Paper, TextField, Typography } from "@mui/material";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { FormProvider, useForm } from "react-hook-form";
import InsertTaskType from "../Service/InsertTaskType";

const AddTaskType = () => {
  const methods = useForm();

  const onSubmit = async (data) => {
    try {
      await InsertTaskType(data);
      console.log("Task type added successfully");
      console.log(data);
      // Add any additional logic or redirection after successful submission
    } catch (error) {
      console.error("Failed to add task type", error);
      // Handle error scenario
    }
  };
  return (
    <Paper sx={{p:2, borderRadius:'25px'}}>
      <Typography variant="h2" sx={{p:1, textAlign:'center'}}>Insert Task Type</Typography>
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
          <Button
            type="submit"
            variant="contained"
            color="primary"
            sx={{ width: "100%" }}
          >
            Add
          </Button>
        </form>
      </FormProvider>
    </Paper>
  );
};

export default AddTaskType;
