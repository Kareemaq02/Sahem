import axios from "../../../Common/Utils/AxiosAgent";

export const UnVerifyUser = async (userId) => {
    try{
        await axios.put(`api/users/unverify/${userId}`);
        return true;
    } catch (error) {
        console.error(error);
    }
}