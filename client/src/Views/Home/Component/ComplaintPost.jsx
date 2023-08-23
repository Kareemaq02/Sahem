import React, { useEffect, useState } from "react";
import { Card, CardContent, Typography, IconButton, Box, Chip } from "@mui/material";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import StatusTracker from "./StatusTracker";
import "../Style/style.css"
import { PostComplaintWatch } from "../Service/PostComplaintWatch";
// Import the SetVote function
import { SetVote, getVoteStatus, setDownvote, removeVote } from "../Service/SetVoteApi";

// css style
import "../Style/style.css"

//icons
import RadioButtonCheckedIcon from '@mui/icons-material/RadioButtonChecked';
import { ThumbDown, ThumbUp, ThumbUpOutlined, ThumbDownOutlined } from "@mui/icons-material";
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';
import WatchLaterIcon from '@mui/icons-material/WatchLater';


const ComplaintPost = ({ data }) => {
    const [complaintData, setComplaintData] = useState(data);
    const [loggedInUser, setLoggedInUser] = useState(null);

    const handleVote = async (complaintId, isDownvote) => {
        try {
            if (isDownvote) {
                // If it's a downvote, call the setDownvote function
                await setDownvote(complaintId);
            } else {
                // If it's an upvote, call the SetVote function
                await SetVote(complaintId);
            }

            // After voting, update the complaintData state to reflect the new vote status
            const updatedData = complaintData.map((complaint) => {
                if (complaint.intComplaintId === complaintId) {
                    complaint.isDownVote = !isDownvote;
                    complaint.intVotersCount += isDownvote ? 1 : -1;
                }
                return complaint;
            });

            setComplaintData(updatedData);
        } catch (error) {
            console.error(error);
        }
    };


    const setWatch = async (complaintId) => {
        await PostComplaintWatch(complaintId)
    }

    return (

        <Box sx={{ display: "grid", gap: 2, width: '100%' }}>
            {data.map((complaint) => (
                <Card key={complaint.intComplaintId} className="filterStyle">
                    <CardContent>
                        <Typography variant="h3" component="div" className="app">
                            <FlexBetween>
                                <div style={{ display: 'flex', alignItems: 'center', }}>
                                    <div className="avatar">A</div>
                                    <span style={{ marginLeft: '10px' }}>{complaint.strFirstName} {complaint.strLastName}</span>
                                </div>


                                <Chip
                                    className="status-chip"
                                    icon={<RadioButtonCheckedIcon />}
                                    color="primary"
                                    label={complaint.strStatus}
                                    variant="outlined"
                                    sx={{ p: 1 }}
                                />
                                <div className="status-box">
                                    <Typography variant="body2" >الحالة العامة: <StatusTracker currentStage={complaint.strStatus} /> </Typography>
                                </div>
                            </FlexBetween>
                        </Typography>
                        <FlexBetween>
                        <Typography variant="h5" component="div" sx={{ paddingRight: 6, }}>
                           <FlexBetween>
                            <WatchLaterIcon sx={{color: 'gray'}}/>
                            <span >قبل 5 ساعات</span>
                            </FlexBetween>
                           </Typography>
                        </FlexBetween>
                        <br />
                        <Typography variant="body1" color="text.secondary" sx={{ width: '85%', display: 'grid', margin: 'auto' }}>
                            {complaint.strComment}
                        </Typography>
                        <br />
                        <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
                            <img
                                src={complaint.imageData ? `data:image/jpg;base64,${complaint.imageData}` : "https://via.placeholder.com/900x400"}
                                alt={`Image for complaint ${complaint.intComplaintId}`}
                                style={{ flex: 1, objectFit: 'cover', borderRadius: '25px', width: "90%", display: 'grid', marginLeft: 'auto', marginRight: 'auto' }}
                            />

                            <FlexBetween>
                                <div style={{ paddingRight: '36px', marginTop: '13px' }}>
                                    <IconButton
                                        aria-label="Upvote"
                                        onClick={() => handleVote(complaint.intComplaintId, false)}
                                    >
                                        {complaint.isDownVote === false ? <ThumbUp /> : <ThumbUpOutlined />}
                                    </IconButton>
                                    <span>{complaint.intVotersCount}</span>
                                    <IconButton
                                        aria-label="Downvote"
                                        onClick={() => handleVote(complaint.intComplaintId, true)}
                                    >
                                        {complaint.isDownVote === true ? <ThumbDown /> : <ThumbDownOutlined />}
                                    </IconButton>
                                    <IconButton onClick={() => setWatch(complaint.intComplaintId)}>
                                        <RemoveRedEyeIcon />
                                    </IconButton>
                                </div>

                                <Typography variant="h4" sx={{ pl: 8, paddingTop: 3, color: '#18AAC9' }}> ش. المدينة المنورة, عمان</Typography>
                            </FlexBetween>
                        </div>
                    </CardContent>
                </Card>
            ))}

        </Box>

    );
};

export default ComplaintPost;
