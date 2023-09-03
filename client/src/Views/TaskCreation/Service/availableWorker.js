import axios from "../../Common/Utils/AxiosAgent";

export const availableWorker = async () => {


  try {
    const response = await axios.get();
    return response.data.map((employee) => ({
      intId: employee.intId,
      strName: employee.strFirstName + " " + employee.strLastName,
    }));
  } catch (error) {
    console.error(error);
  }
};
