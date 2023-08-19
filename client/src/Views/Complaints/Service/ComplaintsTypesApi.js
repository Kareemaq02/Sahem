import axios from "../../../Common/Utils/AxiosAgent";

export default async function ComplaintTypesApi() {
  try {
    return await axios.get("api/complaints/types");
  } catch (error) {
    console.error(error);
  }
};
