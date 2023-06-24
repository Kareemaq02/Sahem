import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetProffession() {
  try {
    return await axios.get("api/professions");
  } catch (error) {
    console.error(error);
  }
}
