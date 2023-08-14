import axios from "../../../Common/Utils/AxiosAgent";

export const VerifyUser = async (userId) => {
    try{
        await axios.put(`api/users/verify/${userId}`)
        return true;
    } catch(error) {
        console.error(error);
    }
}