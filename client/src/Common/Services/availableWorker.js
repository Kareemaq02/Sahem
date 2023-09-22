import axios from "../../Common/Utils/AxiosAgent";

export const availableWorker = async (startDate, dueDate) => {
  try {
    const response = await axios.get(
      `https://localhost:5000/api/users/workers/available?startDate=${startDate}&endDate=${dueDate}`
    );
    return response.data.map((employee) => ({
      intId: employee.intId,
      strName: employee.strFirstNameAr + " " + employee.strLastNameAr,
      profession: employee.strProfessionAr,
    }));
  } catch (error) {
    console.error(error);
  }
};
