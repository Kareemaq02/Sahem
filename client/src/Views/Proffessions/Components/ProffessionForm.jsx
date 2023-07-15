import { FormProvider, useForm } from "react-hook-form";

import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField";
import { Button } from "@mui/material";
import ProffessionApi from "../Service/ProffessionApi";

const ProffessionForm = () => {
  const methods = useForm();

  const onSubmit = async (data) => {
    try {
      await ProffessionApi(data);
      console.log("Conn..");
      console.log("Done.. OK");
    } catch (error) {
      console.error(`Error While Connect: ${error}`);
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

export default ProffessionForm;
