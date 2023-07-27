import axios from "../../../Common/Utils/AxiosAgent";

export const updateComplaint = async (complaintId, updatedComplaintData) => {
  try {
    await axios.put(`/api/complaints/update/${complaintId}`, updatedComplaintData);
    return true; // or return any other value indicating success
  } catch (error) {
    console.error('Error updating complaint:', error);
    return false; // or return any other value indicating failure
  }
};
