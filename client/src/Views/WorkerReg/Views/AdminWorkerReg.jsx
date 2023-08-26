import { Typography, Button, Paper, Box } from "@mui/material"
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
        <Box>
            <Paper sx={{ p: 2, borderRadius: '25px' }}>
                <FormProvider {...methods}>
                    <h1 style={{ textAlign: 'center' }}>تسجيل عامل جديد</h1>
                    <form onSubmit={methods.handleSubmit(createWorker)}>
                        <FormTextField name="strUsername" label="اسم المستخدم" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strPhonenumber" label="رقم الهاتف" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField type="password" name="strPassword" label="كلمة المرور" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strFirstName" label="الاسم الاول" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strLastName" label="الاسم الاخير" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strFirstNameAr" label="الاسم الاول بالعربي" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strLastNameAr" label="الاسم الاحير بالعربي" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strNationalId" label="رقم وطني" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strPassportNumber" label="رقم الجواز" defaultValue="" />
                        <br />
                        <br />
                        <FormTextField name="strNationalIdNumber" label="الرقم الوطني" defaultValue="" />
                        <br />
                        <br />
                        <Button type="submit" variant="contained" color="primary" sx={{ width: "100%" }}>

                            Add
                        </Button>
                    </form>
                </FormProvider>
            </Paper>
            <br />
            <br />
        </Box>
    )
}
export default AdminWorkerReg;