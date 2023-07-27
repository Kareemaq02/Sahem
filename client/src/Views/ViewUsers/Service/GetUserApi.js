import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetUser () {  
    try{
        return await axios.get("api/users/citizens")
    } catch (error) {
        console.error(error)
    }
}