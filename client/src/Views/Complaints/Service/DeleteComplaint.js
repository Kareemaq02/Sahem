import axios from "../../../Common/Utils/AxiosAgent";

export const deleteComplaint = async (complaintId) => {
  try {
    await axios.delete(`/api/complaints/delete/${complaintId}`);
    return true; // or return any other value indicating success
  } catch (error) {
    console.error('Error deleting complaint:', error);
    return false; // or return any other value indicating failure
  }
};