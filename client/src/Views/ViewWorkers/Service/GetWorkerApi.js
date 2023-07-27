import axios from "../../../Common/Utils/AxiosAgent";


export default async function GetWorker() {
    try{
        return await axios.get("api/tasks/users")
    }catch(error){
        console.error(error)
    }
}