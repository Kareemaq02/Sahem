import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetComp() {
    try{
        return await axios.get("api/complaints")
    }catch (error) {
        console.error(error)
    }
}