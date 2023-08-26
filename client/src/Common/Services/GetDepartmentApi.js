import axios from "../../Common/Utils/AxiosAgent";


export const GetDepartmentApi = async () => {
    try {
        return axios.get('api/departments');
    } catch (error) {
        console.error(error)
    }
}