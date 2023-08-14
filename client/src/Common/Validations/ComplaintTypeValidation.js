import * as yup from "yup";

export const complaintTypeSchema = yup.object().shape({
    intDepartmentID: yup.number().integer().required(),
    strNameAR:yup.string().required(),
    strNameEN: yup.string().required(),
    intPrivacyID: yup.number().integer().required(),
    decGrade: yup.number().integer().required()
});