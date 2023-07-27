import axios from "../../../Common/Utils/AxiosAgent";

export const GetTasksApi = async () => {
  try{
    return await axios.get("api/tasks")
  } catch (error) {
    console.log(error);
  }
};
