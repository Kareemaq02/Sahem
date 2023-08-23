import axios from "../../../Common/Utils/AxiosAgent";


const GetWatchlist = async () => {
    try {
        return await axios.get("api/complaints/mywatchlist")
    } catch (error) {
        console.error(error);
    }
};


export default GetWatchlist;