import axios from "../../../Common/Utils/AxiosAgent";

export const GetAnalyticsApi = async (lstComplaintTypeIds, selectedDate, selectedDueDate) => {
  try {
    const urlParams = new URLSearchParams();

    lstComplaintTypeIds.forEach((complaintTypeId) => {
      urlParams.append("lstComplaintTypeIds", complaintTypeId);
    });

    urlParams.append("dtmDateCreated", selectedDate);

    urlParams.append("dtmDateTo", selectedDueDate);


    return await axios.get(`api/complaints/analytics?${urlParams}`);
  } catch (error) {
    console.error(error);
  }
};
