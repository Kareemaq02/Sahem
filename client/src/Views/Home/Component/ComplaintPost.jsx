import React, { useEffect, useState } from "react";
import { Card, CardContent, Typography, IconButton, Box, Chip } from "@mui/material";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import StatusTracker from "./StatusTracker";
import "../Style/style.css"
import { PostComplaintWatch } from "../Service/PostComplaintWatch";
// Import the SetVote function
import { SetVote, getVoteStatus, setDownvote, removeVote } from "../Service/SetVoteApi";
import VerifiedOutlinedIcon from '@mui/icons-material/VerifiedOutlined';

// css style
import "../Style/style.css"
import "../Style/button-style.css"

//icons
import RadioButtonCheckedIcon from '@mui/icons-material/RadioButtonChecked';
import { ThumbDown, ThumbUp, ThumbUpOutlined, ThumbDownOutlined } from "@mui/icons-material";
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';
import WatchLaterIcon from '@mui/icons-material/WatchLater';


const ComplaintPost = ({ data }) => {
    const [complaintData, setComplaintData] = useState([]);
    const [loggedInUser, setLoggedInUser] = useState(null);


    useEffect(() => {
        setComplaintData(data);

    }, [data]);



    const handleVote = async (complaintId, isDownvote) => {
        try {
            // debugger;

            const singleComplaint = complaintData.find(c => c.intComplaintId === complaintId);

            if (singleComplaint.intVoted != 0) {

                await removeVote(complaintId);


                const updatedData = complaintData.map((complaint) => {
                    if (complaint.intComplaintId === complaintId) {
                        complaint.intVoted = 0;
                        complaint.intVotersCount += isDownvote ? 1 : -1;
                    }
                    return complaint;
                });

                setComplaintData(updatedData);
                return;
            }

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
                    complaint.intVoted = !isDownvote ? 1 : -1;
                    complaint.intVotersCount += !isDownvote ? 1 : -1;
                }
                return complaint;
            });

            setComplaintData(updatedData);
        } catch (error) {
            console.error(error);
        }
    };

    const toggleWatch = async (complaintId) => {
        try {
            await PostComplaintWatch(complaintId);
            // Update the blnIsOnWatchList property in the complaintData state
            const updatedData = complaintData.map((complaint) => {
                if (complaint.intComplaintId === complaintId) {
                    complaint.blnIsOnWatchList = !complaint.blnIsOnWatchList;
                }
                return complaint;
            });
            setComplaintData(updatedData);
        } catch (error) {
            console.error(error);
        }
    };

    return (

        <Box sx={{ display: "grid", gap: 2, width: '100%' }}>
            {complaintData.map((complaint) => (
                <Card key={complaint.intComplaintId} className="filterStyle">
                    <CardContent>
                        <Typography variant="h3" component="div" className="app">
                            <FlexBetween>
                                <div style={{ display: 'flex', alignItems: 'center', }}>
                                    <div className="avatar">{complaint.strFirstNameAr[0]}</div>
                                    <span style={{ marginLeft: '10px' }}>{complaint.strFirstNameAr} {complaint.strLastNameAr}</span>
                                    <FlexBetween>
                                        {
                                            complaint.blnIsVerified === true ? (
                                                <VerifiedOutlinedIcon />
                                            ) : (
                                                <span> </span>
                                            )
                                        }
                                    </FlexBetween>
                                </div>


                                <Chip
                                    className="status-chip"
                                    icon={<RadioButtonCheckedIcon />}
                                    color="primary"
                                    label={complaint.strStatusAr}
                                    variant="outlined"
                                    sx={{ p: 1 }}
                                />
                                <div className="status-box">
                                    <Typography variant="body2" >الحالة العامة: <StatusTracker currentStage={complaint.strStatusEn} /> </Typography>
                                </div>
                            </FlexBetween>
                        </Typography>
                        <FlexBetween>
                            <Typography variant="h5" component="div" sx={{ paddingRight: 6, }}>
                                <FlexBetween>
                                    <WatchLaterIcon sx={{ color: 'gray' }} />
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
                                className="fixed-size-image"
                            />


                            <FlexBetween>
                                <div style={{ paddingRight: '36px', marginTop: '13px' }}>
                                    <IconButton
                                        aria-label="Upvote"
                                        // className={complaint.intVoted == 1 ? 'upvote_green' : '' }

                                        className={`${complaint.intVoted === 1 ? 'upvote_green' : ''} ${complaint.intVoted === -1 ? 'disabled' : ''}`}




                                        onClick={() => handleVote(complaint.intComplaintId, false)}
                                    >
                                        {complaint.isDownVote === false ? <ThumbUp /> : <ThumbUpOutlined />}
                                        {/* {complaint.isDownVote === false ? <ThumbUp /> : <ThumbUp />} */}
                                    </IconButton>
                                    <span>{complaint.intVotersCount}</span>
                                    <IconButton
                                        aria-label="Downvote" className={`${complaint.intVoted == -1 ? 'downvote_red' : ''} ${complaint.intVoted === 1 ? 'disabled' : ''}`}
                                        onClick={() => handleVote(complaint.intComplaintId, true)}
                                    // disabled={clickedVote === 1}
                                    >
                                        {complaint.isDownVote === true ? <ThumbDown /> : <ThumbDownOutlined />}
                                        {/* {complaint.isDownVote === true ? <ThumbDown /> : <ThumbDown />} */}
                                    </IconButton>
                                    <IconButton onClick={() => toggleWatch(complaint.intComplaintId)}>
                                        <RemoveRedEyeIcon sx={{ color: complaint.blnIsOnWatchList ? '#e74c3c' : 'inherit' }} />
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
