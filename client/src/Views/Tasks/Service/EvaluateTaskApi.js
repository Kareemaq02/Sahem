import axios from "../../../Common/Utils/AxiosAgent";

export const EvaluateTaskApi = async (data, id) => {
  if (data.status === "failed") {
    const response = await axios.post(`api/evaluations/fail/${id}`, data);
    return response.data.status < 400;
  }

  if (data.status === "completed") {
    const response = await axios.post(`api/evaluations/complete/${id}`, data);
    return response.data.status < 400;
  }

  if (data.status === "incomplete") {
     const response = await axios.post(`api/evaluations/Incomplete/${id}`, data);
     return response.data.status < 400;
   }

  return false;
};
