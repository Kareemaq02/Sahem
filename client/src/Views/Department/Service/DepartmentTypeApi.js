import axios from "../../../Common/Utils/AxiosAgent";

export default async function DepartmentTypeApi(data) {
    const taskForm = new FormData();
    taskForm.append("strNameAr", data.strNameAr)
    taskForm.append("strNameEn", data.strNameEn)
    
    try{
        return await axios.post("api/departments",taskForm)
    }catch (error){
        console.error(error)
    }
}