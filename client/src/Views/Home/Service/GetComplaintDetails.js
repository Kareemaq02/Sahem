import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetComplaintDetails(
  pageNumber,
  pageSize,
  userLat,
  userLng,
  lstComplaintTypeIds,
  lstComplaintStatusIds,
  intDistance 
  ) {
  try {
    const params = {
      pageNumber,
      pageSize,
      userLat,
      userLng,
      intDistance 
    };

    const urlParams = new URLSearchParams();
    lstComplaintStatusIds.forEach((complaintStatusId) => {
      urlParams.append("lstComplaintStatusIds", complaintStatusId);
    });

    lstComplaintTypeIds.forEach((complaintTypeId) => {
      urlParams.append("lstComplaintTypeIds", complaintTypeId);
    });

    return await axios.get(`api/complaints/general?${urlParams}`, { params });
  } catch (error) {
    console.error(error);
  }
}
