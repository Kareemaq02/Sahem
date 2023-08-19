import axios from "../../../Common/Utils/AxiosAgent";
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";

export const GetTasksApi = async (
  pageSize,
  pageNumber,
  lstTaskStatusIds, // New parameter
  lstTaskTypeIds
) => {
  try {
    const params = {
      pageSize,
      pageNumber,
    };

    const urlParams = new URLSearchParams();
    if (lstTaskStatusIds && Array.isArray(lstTaskStatusIds)) {
      lstTaskStatusIds.forEach((taskStatusId) => {
        urlParams.append("lstTaskStatusIds", taskStatusId);
      });
    }

    if (lstTaskTypeIds && Array.isArray(lstTaskTypeIds)) {
      lstTaskTypeIds.forEach((taskTypeId) => {
        urlParams.append("lstTaskTypeIds", taskTypeId);
      });
    }

   
    

    const response = await axios.get(`api/tasks?${urlParams}`, { params });
    return response.data.map((item) => ({
      id: item.taskID,
      admin: item.adminUsername,
      cost: 0,
      type: item.strTypeNameEn,
      dateScheduled: DateFormatterEn(item.scheduledDate),
      deadline: DateFormatterEn(item.deadlineDate),
      status: item.strTaskStatus,
    }));
  } catch (error) {
    console.error(error);
  }
}
