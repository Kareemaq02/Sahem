import axios from "../../../Common/Utils/AxiosAgent";

const GetComplaintImage = async (complaintId) => {
  try {
    return await axios.get(`api/complaints/${complaintId}`);
  } catch (error) {
    console.error(error);
  }
};

export default GetComplaintImage;