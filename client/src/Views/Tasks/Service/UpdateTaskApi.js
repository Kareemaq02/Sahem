import axios from "../../../Common/Utils/AxiosAgent";

export const updateTask = async (taskId, updatedTaskData) => {
  try {
    await axios.put(`/api/taks/update/${taskId}`, updatedTaskData);
    return true; // or return any other value indicating success
  } catch (error) {
    console.error('Error updating complaint:', error);
    return false; // or return any other value indicating failure
  }
};
