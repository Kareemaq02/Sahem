import React, { useState, useEffect } from "react";

// Mui
import { Typography, SwipeableDrawer } from "@mui/material";


import { GetComplaintApi } from "../Service/GetComplaintsApi"
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";
import GeneralCompDataGrid from "../Components/generalCompDateGrid";
import GetComplaintImage from "../../Home/Service/GetComplaintImage";


const CitizenViewGeneralComplaints = () => {
    const [complaints, setComplaints] = useState([]);

    useEffect(() => {
        const setComplaintsView = async () => {
            const response = await GetComplaintApi();

            const complaintsWithData = await Promise.all(response.data.map(async (complaint) => {
                const imageDataResponse = await GetComplaintImage(complaint.intComplaintId);
                const imageData = imageDataResponse.data.lstMedia[0]?.data || "";

                return { ...complaint, imageData };
            }));
            setComplaints(complaintsWithData);
        };
        setComplaintsView();
    }, []);

    const FormatDate = () => {
        const rows = [...complaints];
        rows.forEach((c) => (c.dtmDateCreated = DateFormatterEn(c.dtmDateCreated)));
        return rows;
    };

    return (
        <div>
            <GeneralCompDataGrid data={FormatDate(complaints)} />
        </div>
    );
};

export default CitizenViewGeneralComplaints