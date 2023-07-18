import axios from "../../../Common/Utils/AxiosAgent";
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";

export const GetTaskDetailsApi = async (id) => {
  // Add code here when the backend is ready
  try {
    const response = await axios.get(`api/tasks/details/${id}`);
    const data = response.data;
    return {
      taskStatus: data.strTaskStatus,
      members: data.workersList.map((worker) => worker.intId.toString()), // Need to be changed into string names
      type: data.strTypeNameEn,
      date: DateFormatterEn(data.finishedDate),
      photos: data.lstMedia.map((media) => ({
        image: media.strMediaRef,
        title: "image",
      })),
    };
  } catch (error) {
    console.error(error);
  }
};
