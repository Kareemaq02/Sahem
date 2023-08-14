import axios from "../../../Common/Utils/AxiosAgent";

export const  BlackListUser = async (userId) => {
    try{
        await axios.put(`api/users/blacklist/${userId}`)
        return true;
    } catch (error) {
        console.error(error)
    }
} 