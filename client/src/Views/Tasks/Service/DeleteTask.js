import axios from "../../../Common/Utils/AxiosAgent";

export const deleteTasks = async (taskId) => {
  try {
    await axios.delete(`/api/tasks/delete/${taskId}`);
    return true; // or return any other value indicating success
  } catch (error) {
    console.error('Error deleting tasks:', error);
    return false; // or return any other value indicating failure
  }
};
