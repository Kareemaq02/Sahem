import { Box, Button, TextField, Typography,Paper } from "@mui/material";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { FormProvider, useForm } from "react-hook-form";
import InsertTaskType from "../Service/InsertTaskType";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";

const taskTypeFormValidation = yup.object().shape({
  intDepartmentId: yup.number().integer().typeError("Invalid data type, must enter a number").required("Invalid entry this field is required"),
  strNameAr: yup.string().typeError("Invalid data type, must enter a name").matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers").required("Invalid entry this field is required"),
  strNameEn: yup.string().typeError("Invalid data type, must enter a name").matches(/^[A-Za-z\s]*$/, "Invalid entry, must not contain numbers").required("Invalid entry this field is required"),
});

const AddTaskType = () => {
  const methods = useForm({
    resolver: yupResolver(taskTypeFormValidation), 
  });

  const onSubmit = async (data) => {
    try {
      await InsertTaskType(data);
      console.log("Task type added successfully");
      console.log(data);
    } catch (error) {
      console.error("Failed to add task type", error);
    }
  };
  return (
    <Paper
      sx={{
        p:2,
        borderRadius:'25px'
      }}
    >
      <Typography variant="h2" sx={{ textAlign:'center', p:1}}>
        Add Task Types
      </Typography>
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
            sx={{ width: '100%' }}
          >
            Add
          </Button>
        </form>
      </FormProvider>
    </Paper>
  );
};

export default AddTaskType;