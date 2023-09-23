import axios from "../../../Common/Utils/AxiosAgent";

export const GetUserComplaints = async () => {
  try {
    const response = await axios.get("/api/complaints/user")
    const complaintsWithData = response.data.map((complaint) => {
      const { lstMediaBefore, lstMediaAfter, ...rest } = complaint;
      const beforeImageData = lstMediaBefore[0]?.data || "";
      const afterImageData = lstMediaAfter[0]?.data || "";

      return { ...rest, beforeImageData, afterImageData };
    });

    return complaintsWithData;
  } catch (error) {
    return false
  }
};
