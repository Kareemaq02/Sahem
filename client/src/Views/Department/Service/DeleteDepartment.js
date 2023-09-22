import axios from "../../../Common/Utils/AxiosAgent";


export const DeleteDepartment = async (depId) => {

    try{
        return await axios.put(`/api/departments/remove?intDepartmentId=${depId}`)
    }catch (error) {
        console.error(error);
    }
}