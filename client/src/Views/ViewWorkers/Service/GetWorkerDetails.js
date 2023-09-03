import axios from "../../../Common/Utils/AxiosAgent";

const GetWorkerDetails = async (workerId) => {
    try{
        return axios.get(`api/users/worker/${workerId}`)
    } catch (error) {
        console.error(error)
    }
}

export default GetWorkerDetails;