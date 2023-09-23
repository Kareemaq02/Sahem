import axios from "../../Common/Utils/AxiosAgent";

export const UserComplaint = async () => {
    try {
        return await axios.get('api/complaints/user');
    } catch (error) {
        console.error(error);
    }
}