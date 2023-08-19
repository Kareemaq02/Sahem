import axios from "../../../Common/Utils/AxiosAgent";

export const GetTaskType = async () => {
    try {
        return await axios.get("api/tasks/types")
    } catch (error) {
        console.error(error);
    }
}