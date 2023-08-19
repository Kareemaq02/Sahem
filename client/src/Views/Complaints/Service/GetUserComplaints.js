import axios from "../../../Common/Utils/AxiosAgent";

export const GetUserComplaints = async () => {
  try {
    const response = await axios.get("/api/complaints/user")
    return response.data.map((item) => ({
      intComplaintId: item.intComplaintId,
      dtmDateCreated: item.dtmDateCreated,
      dtmDateFinished: item.dtmDateFinished,
      strStatus: item.strStatus,
      strComplaintTypeEn: item.strComplaintTypeEn,
      strComplaintTypeAr: item.strComplaintTypeAr,
    }));
  } catch (error) {
    return false
  }
};
