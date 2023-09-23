import axios from "../../../Common/Utils/AxiosAgent";


export const GetDepWorker = async (depId) => {
    try {
        return axios.get(`/api/departments/workers?id=${depId}`)
    } catch (error) {
        console.error(error);
    }
}