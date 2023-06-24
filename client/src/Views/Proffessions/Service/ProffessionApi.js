import axios from "../../../Common/Utils/AxiosAgent";

export default async function ProffessionApi(data) {
  const taskForm = new FormData();
  taskForm.append("strNameAr", data.strNameAr);
  taskForm.append("strNameEn", data.strNameEn);
  try {
    return await axios.post("api/professions", taskForm);
  } catch (error) {
    console.error(error);
  }
}
