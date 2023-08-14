import axios from "../../../Common/Utils/AxiosAgent";

export const  WhiteListUser = async (userId) => {
    try{
        await axios.put(`api/users/whitelist/${userId}`)
        return true;
    } catch (error) {
        console.error(error)
    }
} 