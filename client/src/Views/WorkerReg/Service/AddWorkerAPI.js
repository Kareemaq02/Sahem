import axios from "../../../Common/Utils/AxiosAgent";

const AddWorkerAPI = async (data) => {
  try {
    const response = await axios.post("/api/account/register/employee?isAdmin=false", data);
    return response.data; 
  } catch (error) {
    throw error;
  }
};

export default AddWorkerAPI;
