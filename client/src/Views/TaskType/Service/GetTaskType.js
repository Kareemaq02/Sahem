import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetTaskType() {
  try {
    return await axios.get("api/tasks/types");
  } catch (error) {
    console.error(error);
  }
};
