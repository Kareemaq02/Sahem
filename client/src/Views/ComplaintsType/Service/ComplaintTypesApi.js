import axios from "../../../Common/Utils/AxiosAgent";

export default async function ComplaintsTypesApi(data) {
  const taskForm = new FormData();
  taskForm.append("intDepartmentId", data.intDepartmentId);
  taskForm.append("strNameAr", data.strNameAr);
  taskForm.append("strNameEn", data.strNameEn);
  taskForm.append("intPrivacyId", data.intPrivacyId);
  taskForm.append("decGrade", data.decGrade);

  try {
    return await axios.post("api/complaints/CreateType", taskForm);
  } catch (error) {
    console.error(error);
  }
}
