import axios from "../../../Common/Utils/AxiosAgent";

export const GetComplaintsApi = async (pageSize, pageNumber) => {
  try {
    return await axios.get(`api/complaints?pageSize=${pageSize}&pageNumber=${pageNumber}`);
  } catch (error) {
    console.error(error);
  }
};
