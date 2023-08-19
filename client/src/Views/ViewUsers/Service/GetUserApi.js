import axios from "../../../Common/Utils/AxiosAgent";

export default async function GetUser(pageNumber, pageSize, blnIsVerified, blnIsBlacklisted) {
    try {
        const params = {
            pageNumber,
            pageSize,
            blnIsVerified: blnIsVerified ? "true" : "false",
            blnIsBlacklisted: blnIsBlacklisted ? "true" : "false"
        };

        return await axios.get("api/users/citizens", { params });
    } catch (error) {
        console.error(error);
        throw error;
    }
}
