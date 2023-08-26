// Assuming you have the necessary import for axios
import axios from "../../../Common/Utils/AxiosAgent"

export const GetComplaintApi = async () => {
    try {
        const response = await axios.get("api/complaints/completed/public");
        console.log("API Response:", response.data); // Add this line to check the response

        const complaintsWithData = response.data.map((complaint) => {
            const { lstMediaBefore, lstMediaAfter, ...rest } = complaint;
            const beforeImageData = lstMediaBefore[0]?.data || "";
            const afterImageData = lstMediaAfter[0]?.data || "";

            return { ...rest, beforeImageData, afterImageData };
        });

        return complaintsWithData;
    } catch (error) {
      console.error("API Error:", error);
      return [];
    }
}
