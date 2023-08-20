import axios from "../../../Common/Utils/AxiosAgent";

export const ActivateTask = async (taskId) => {
    try{
        return await axios.put(`api/tasks/activate/${taskId}`);
    } catch (error) {
        console.error(error);
    }
}