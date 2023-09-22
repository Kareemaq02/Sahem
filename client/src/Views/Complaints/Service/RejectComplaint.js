import axios from "../../../Common/Utils/AxiosAgent";


export const RejectComplaints = async (complaintId) => {

    try {
        return axios.put(`/api/complaints/reject/${complaintId}`)
    } catch (error) {
        console.error (error);
    }
}