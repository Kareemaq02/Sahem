import { Box } from "@mui/material";
import { useEffect, useState } from "react";
import GetWatchlist from "../Services/GetWatchlist";
import ShowWatchlist from "../Components/ShowWatchlist";
import GetComplaintImage from "../../Home/Service/GetComplaintImage";

const UserWatchlistView = () => {
    const [watchlists, setWatchlists] = useState([]);

    useEffect(() => {
        const fetchWatchlist = async () => {
            try {
                const response = await GetWatchlist();
                const complaintsWithData = await Promise.all(response.data.map(async (complaint) => {
                    const imageDataResponse = await GetComplaintImage(complaint.intComplaintId); 
                    const imageData = imageDataResponse.data.lstMedia[0]?.data || ""; 
          
                    return { ...complaint, imageData };
                  }));
                setWatchlists(complaintsWithData); 
            } catch (error) {
                console.error(error);
            }
        };

        fetchWatchlist();
    }, []);

    return (
        <Box>
            <ShowWatchlist data={watchlists} />
        </Box>
    );
};

export default UserWatchlistView;
