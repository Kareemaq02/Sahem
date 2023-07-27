import axios from "../../../Common/Utils/AxiosAgent";

export const DeleteTask = async (taskId) => {
  try {
    await axios.delete(`api/tasks/delete/${taskId}`);
    return true; 
  } catch (error) {
    console.error('Error deleting task:', error);
    return false; 
  }
};