import React from "react";
import { Card, CardContent, Typography, IconButton, Box, Chip } from "@mui/material";
import { ThumbDown, ThumbUp } from "@mui/icons-material";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import RadioButtonCheckedIcon from '@mui/icons-material/RadioButtonChecked';

// Import the SetVote function
import SetVote from "../Service/SetVoteApi";

const ComplaintPost = ({ data }) => {


    const handleUpvote = async (complaintId) => {
        console.log(complaintId)
        try {
            const result = await SetVote(complaintId);
            console.log(result); // Optional: Handle the result as needed
        } catch (error) {
            console.error(error);
        }
    };


    return (

        <Box sx={{ display: "grid", gap: 2, width: '100%' }}>
            {data.map((complaint) => (
                <Card key={complaint.intComplaintID}>
                    <CardContent>
                        <Typography variant="h3" component="div">
                            <FlexBetween>
                                {complaint.strUserName}
                                <Chip
                                    icon={<RadioButtonCheckedIcon />}
                                    color="primary"
                                    label={complaint.strStatus}
                                    variant="outlined"
                                    sx={{ p: 1 }}
                                />
                            </FlexBetween>
                        </Typography>
                        <Typography variant="h5" component="div">
                            {complaint.strComplaintTypeEn}
                        </Typography>
                        <Typography variant="body1" color="text.secondary">
                            {complaint.strComment}
                        </Typography>
                        <div>
                            <IconButton
                                aria-label="Upvote"
                                onClick={() => handleUpvote(complaint.intComplaintID)}
                            >
                                <ThumbUp />
                            </IconButton>
                            <span>{complaint.intVotersCount}</span>
                            <IconButton
                                aria-label="Downvote"
                            >
                                <ThumbDown />
                            </IconButton>
                        </div>
                    </CardContent>
                </Card>
            ))}
        </Box>

    );
};

export default ComplaintPost;
