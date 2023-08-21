import React, { useEffect, useState } from "react";
import { Box, Dialog, DialogTitle, DialogContent, Button, IconButton, Paper, Typography, Stack, Divider } from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
//import "../index.css"
import SendIcon from '@mui/icons-material/Send';
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import Switch from '@mui/material/Switch';
import { BlackListUser } from "../Service/BlackListUser";
import { WhiteListUser } from "../Service/WhiteListUser";
import { VerifyUser } from "../Service/VerifyUser";
import { UnVerifyUser } from "../Service/UnVerifyUser";


const ShowUsersDataGrid = ({ data, id }) => {
    const [open, setOpen] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null);
    const [blacklistUser, setBlacklistUser] = useState([]);
    const [isBlacklistChecked, setIsBlacklistChecked] = useState(false);
    const [isVerifyChecked, setIsVerifyChecked] = useState(false)


    const setBlacklistUsers = async (userId) => {
        await BlackListUser(userId);
        setIsBlacklistChecked(true);
    }

    const setWhitelistUsers = async (userId) => {
        await WhiteListUser(userId);
        setIsBlacklistChecked(false)
    }

    const setVerifyUsers = async (userId) => {
        await VerifyUser(userId);
        setIsVerifyChecked(true);
    }

    const setUnVerifyUser = async (userId) => {
        await UnVerifyUser(userId);
        setIsVerifyChecked(false);
    }

    const handleOpen = (user) => {
        setSelectedUser(user);
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
    };

    const columns = [
        { field: "intId", headerName: "ID", flex: 0.5 },
        { field: "strUsername", headerName: "User Name", flex: 0.5 },
        {
            field: "name",
            headerName: "Name",
            flex: 0.5,
            valueGetter: (params) => {
                const firstName = params.row.strFirstName || "";
                const LastName = params.row.strLastName || "";
                return `${firstName} ${LastName}`
            }
        },
        {
            field: "Action",
            headerName: "Action",
            renderCell: (params) => (
                <div>
                    <IconButton
                        variant="contained"
                        color="primary"
                        onClick={() => handleOpen(params.row)}
                    >
                        <RemoveRedEyeIcon />
                    </IconButton>
                </div>
            ),
        },
    ];

    return (
        <Box margin="2rem 0 0 0" height="75vh" sx={{flex:1, width:'100%'}}>
            <DataGrid
                rows={data}
                columns={columns}
                getRowId={(row) => row.intId}
                components={{
                    Toolbar: GridToolbar,
                }}
                density="compact"
                className="responsive-grid"
            />

            <Dialog
                open={open}
                onClose={handleClose}
                maxWidth="md"
                fullWidth
            >
                <DialogTitle>User Information</DialogTitle>
                <DialogContent>
                    {selectedUser && (

                        <div className="Users-container">
                            <div className="user-info1">
                                <FlexBetween>
                                    <Typography variant="h2" id="Name">
                                        {selectedUser.strFirstName}
                                        <br />
                                        <Typography variant="h6" id="ntid">
                                            national_id: 20020123
                                        </Typography>
                                    </Typography>
                                    <Button id="msgbtn" variant="contained" endIcon={<SendIcon />}>
                                        Message
                                    </Button>
                                </FlexBetween>
                            </div>
                            <hr />
                            <div className="basicInfo">
                                <Typography variant="h4" id="basicInfoTitle">Basic Details</Typography>
                                <br />
                                <br />
                                <Stack direction="row" spacing={2} sx={{ width: "90%" }}>

                                    <Stack spacing={2} sx={{ flexGrow: 1, }}>

                                        <Typography>ID: <br />  {selectedUser.intId}</Typography>
                                        <Typography>First Name:<br /> {selectedUser.strFirstName}</Typography>
                                        <Typography>Last Name:<br /> {selectedUser.strLastName}</Typography>
                                    </Stack >

                                    <Stack >

                                        <Typography variant="h3">Suspend User Activities</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
                                                User will no longer be able to vote or report a complaint

                                                <Switch
                                                    checked={selectedUser?.boolIsBlacklisted === true}
                                                    onChange={async (event) => {
                                                        const newChecked = event.target.checked;
                                                        setIsBlacklistChecked(newChecked);

                                                        if (newChecked) {
                                                            await setBlacklistUsers(selectedUser.intId);
                                                        } else {
                                                            await setWhitelistUsers(selectedUser.intId);
                                                        }

                                                        setSelectedUser(prevSelectedUser => ({
                                                            ...prevSelectedUser,
                                                            boolIsBlacklisted: newChecked
                                                        }));
                                                    }}
                                                />

                                            </FlexBetween>

                                        </Typography>

                                        <br />
                                        <br />
                                        <Typography variant="h3">Verify User</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
                                                Toggling this will make the user's reports have a higher over others

                                                <Switch 
                                                    checked = {selectedUser?.boolIsVerified === true}
                                                    onChange={async (event) => {
                                                        const newVerifyChecked = event.target.checked;
                                                        setIsVerifyChecked(newVerifyChecked)

                                                        if (newVerifyChecked) {
                                                            await setVerifyUsers(selectedUser.intId);
                                                        } else {
                                                            await setUnVerifyUser(selectedUser.intId);
                                                        }

                                                        setSelectedUser(prevSelectedUser => ({
                                                            ...prevSelectedUser,
                                                            boolIsVerified: newVerifyChecked
                                                        }));
                                                    }}
                                                
                                                />
                                            </FlexBetween>

                                        </Typography>
                                        <br />
                                        <br />
                                        <Typography variant="h3">Data Management</Typography>
                                        <Typography sx={{ fontSize: "10px" }} variant="h6">Warning</Typography>
                                        <Button variant="outlined" color="error">
                                            Delete Account
                                        </Button>
                                    </Stack>
                                </Stack>


                            </div>



                        </div>
                    )}
                </DialogContent>
            </Dialog>
        </Box>
    );
};

export default ShowUsersDataGrid;
