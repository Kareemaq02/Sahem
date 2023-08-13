import axios from "../../../Common/Utils/AxiosAgent";

export const GetMyTasks = async () => {
    try {
        return await axios.get("api/tasks/loggedInWorker");
    } catch (error) {
        console.error(error)
    }
}