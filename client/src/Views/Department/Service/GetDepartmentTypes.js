import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetDepartmentType() {
  try {
    console.log("function is working...")
    return await axios.get("/api/departments");
  } catch (error) {
    console.error(error);
  }
}
