import axios from "../../../Common/Utils/AxiosAgent"

export const GetComplaintApi = async () => {
    try {
        return await axios.get("/api/complaints/completed/public");
      } catch (error) {
        console.error(error);
      }
}