import { FormProvider, useForm } from "react-hook-form";
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { Button, Box, Typography, Paper } from "@mui/material";
import ProffessionApi from "../Service/ProffessionApi";
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";

const proffessionFormValidation = yup.object().shape({
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

const ProffessionForm = ({ refreshData }) => {
  const methods = useForm({
    resolver: yupResolver(proffessionFormValidation),
  });

  const onSubmit = async (data) => {
    try {
      await ProffessionApi(data);
      console.log("Conn...");
      console.log("Done.. OK");
      refreshData(prevData => [...prevData, data]);
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
        اضافة مهن جديدة
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

export default ProffessionForm;