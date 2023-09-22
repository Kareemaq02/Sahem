import axios from "../../../Common/Utils/AxiosAgent";


export const CompleteAPI = async (taskId) => {
    try {
        return await axios.post(`api/evaluations/fail/${id}`)
    } catch (error) {
        console.error(error);
    }
}