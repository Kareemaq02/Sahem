import axios from "../../../Common/Utils/AxiosAgent";

export default async function AddTaskType(data) {
  const taskForm = new FormData();
  taskForm.append("intDepartmentId", data.intDepartmentId);
  taskForm.append("strNameAr", data.strNameAr);
  taskForm.append("strNameEn", data.strNameEn);
  try {
    return await axios.post("api/tasks/types", taskForm);
  } catch (error) {
    console.error(error);
  }
}
