import { Typography, Button, Paper } from "@mui/material"
import { FormProvider, useForm } from "react-hook-form"
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";

// project
import FormTextField from "../../../Common/Components/UI/FormFields/FormTextField"
import AddWorkerAPI from "../Service/AddWorkerAPI"

const departmentTypeFormValidation = yup.object().shape({
    strUsername: yup
        .string()
        .typeError("Invalid data type, must enter a User name")
        .matches(/^[A-Za-z0-9\s]*$/, "Invalid entry, must not contain special characters")
        .required("This field is required"),
    strPhonenumber: yup
        .string()
        .typeError("Invalid data type, must enter a Phone Number")
        .matches(/^[0-9]*$/, "Invalid entry, must contain only numbers")
        .required("This field is required"),
    strPassword: yup
        .string()
        .typeError("Invalid data type, must enter a Password")
        .matches(/^[A-Za-z0-9\s!@#$%^&*()_-]*$/, "Invalid entry, can contain letters, numbers, and special characters !@#$%^&*()_-")
        .required("This field is required"),
});



const AdminWorkerReg = () => {

    const methods = useForm({
        resolver: yupResolver(departmentTypeFormValidation),
    });
    const createWorker = async (formData) => {
        try {
            await AddWorkerAPI(formData);
            console.log("Worker added successfully");
        } catch (error) {
            console.error("Failed to add worker", error);
        }
    };


    return (
        <Paper sx={{ p: 2, borderRadius: '25px' }}>
            <FormProvider {...methods}>
                <h1 style={{ textAlign: 'center' }}>Register a Worker</h1>
                <form onSubmit={methods.handleSubmit(createWorker)}>
                    <FormTextField name="strUsername" label="User Name" defaultValue="" />
                    <br />
                    <br />
                    <FormTextField name="strPhonenumber" label="Phone Number" defaultValue="" />
                    <br />
                    <br />
                    <FormTextField type="password" name="strPassword" label="Password" defaultValue="" />
                    <br />
                    <br />
                    <FormTextField name="strFirstName" label="First Name" defaultValue="" />
                    <br />
                    <br />
                    <FormTextField name="strLastName" label="Last Name" defaultValue="" />
                    <br />
                    <br />
                    <FormTextField name="strNationalId" label="National Id" defaultValue="" />
                    <br />
                    <br />
                    <FormTextField name="strPassportNumber" label="Passport Number" defaultValue="" />
                    <br />
                    <br />
                    <FormTextField name="strNationalIdNumber" label="National Id Number" defaultValue="" />
                    <br />
                    <br />
                    <Button type="submit" variant="contained" color="primary" sx={{ width: "100%" }}>

                        Add
                    </Button>
                </form>
            </FormProvider>
        </Paper>
    )
}
export default AdminWorkerReg;