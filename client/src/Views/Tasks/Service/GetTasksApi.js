import axios from "../../../Common/Utils/AxiosAgent";
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";

export const GetTasksApi = async () => {
  try {
    const response = await axios.get("api/tasks");
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
};
