import React, { useState, useEffect } from "react";

// Mui
import { Typography, SwipeableDrawer } from "@mui/material";


import {GetComplaintApi} from "../Service/GetComplaintsApi"
import { DateFormatterEn } from "../../../Common/Utils/DateFormatter";
import GeneralCompDataGrid from "../Components/generalCompDateGrid";



const CitizenViewGeneralComplaints = () => {
    const [complaints, setComplaints] = useState([]);

    useEffect(() => {
        const setComplaintsView = async () => {
            const response = await GetComplaintApi();
            setComplaints(response.data);
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
            <Typography variant="h1">General Complaints</Typography>
            <GeneralCompDataGrid  data={FormatDate(complaints)}/>
        </div>
    );
};

export default CitizenViewGeneralComplaints