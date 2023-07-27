import axios from "../../../Common/Utils/AxiosAgent";

export default async function SetVote(complaintId) {
  try {
    
    return await axios.post(`/api/complaints/vote/${complaintId}`);;
  } catch (error) {
    // Handle error here
    console.error(error);
    throw error;
  }
}
