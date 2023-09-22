import axios from "../../../Common/Utils/AxiosAgent";

export const GetTasksTypesApi = async () => {
  try {
    const response = await axios.get(`/api/tasks/types`);
    return response.data.map((item) => ({
      intId: item.intId,
      strName: item.strNameAr,
    }));
  } catch (error) {
    return false;
  }
};
