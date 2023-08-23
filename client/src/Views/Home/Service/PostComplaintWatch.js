import axios from "../../../Common/Utils/AxiosAgent";


export const PostComplaintWatch = async (complaintId) => {
    try{
        return await axios.post(`api/complaints/addToWatchlist/${complaintId}`)
    } catch (error) {
        console.error(error);
    }
}