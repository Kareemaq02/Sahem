import axios from "../../../Common/Utils/AxiosAgent";

//up vote
export async function SetVote(complaintId) {
  try {
    return await axios.post(`/api/complaints/vote/${complaintId}`);
  } catch (error) {
    console.error(error);
    throw error;
  }
}


// down vote

export async function setDownvote(complaintId) {
  try {
    return await axios.post(`/api/complaints/votedown/${complaintId}`);
  } catch (error) {
    console.error(error);
    throw error;
  }
}

// remove vote
export async function removeVote(complaintId) {
  try {
    return await axios.post(`/api/complaints/voteremove/${complaintId}`);
  } catch (error) {
    console.error(error);
    throw error;
  }
}

