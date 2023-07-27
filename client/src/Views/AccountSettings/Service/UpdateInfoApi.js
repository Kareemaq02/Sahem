import axios from "../../../Common/Utils/AxiosAgent";

export const UpdateInfoApi = async (userUpdateDTO) => {
  try {
    return  axios.put("api/account/update", userUpdateDTO);
  } catch (error) {
    console.error(error);
  }
};
