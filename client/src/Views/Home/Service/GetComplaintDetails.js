import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetComplaintDetails(
  pageNumber,
  pageSize,
  lstComplaintTypeIds,
  lstComplaintStatusIds // New parameter
) {
  try {
    const params = {
      pageNumber,
      pageSize,
    };

    const urlParams = new URLSearchParams();
    lstComplaintStatusIds.forEach((complaintStatusId) => {
      urlParams.append("lstComplaintStatusIds", complaintStatusId);
    });

    lstComplaintTypeIds.forEach((complaintTypeId) => {
      urlParams.append("lstComplaintTypeIds", complaintTypeId);
    });

    return await axios.get(`api/complaints?${urlParams}`, { params });
  } catch (error) {
    console.error(error);
  }
}
