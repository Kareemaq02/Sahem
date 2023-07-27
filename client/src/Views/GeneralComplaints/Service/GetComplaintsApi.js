import axios from "../../../Common/Utils/AxiosAgent"

export const GetComplaintApi = async () => {
    try {
        return await axios.get("api/complaints");
      } catch (error) {
        console.error(error);
      }
}