import React, { useState, useEffect } from "react";
import { Box, Dialog, DialogTitle, DialogContent, Button, IconButton, Paper, Typography, Stack, Divider } from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import SendIcon from '@mui/icons-material/Send';
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';
import { BlackListUser } from "../../ViewUsers/Service/BlackListUser";
import { WhiteListUser } from "../../ViewUsers/Service/WhiteListUser";
import { VerifyUser } from "../../ViewUsers/Service/VerifyUser";
import { UnVerifyUser } from "../../ViewUsers/Service/UnVerifyUser";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import Switch from '@mui/material/Switch';
import GetWorkerDetails from "../Service/GetWorkerDetails";
import { Link } from "react-router-dom"; // Import the Link component


const ShowWorkersDataGrid = ({ data }) => {

    const [open, setOpen] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null);
    const [blacklistUser, setBlacklistUser] = useState([]);
    const [isBlacklistChecked, setIsBlacklistChecked] = useState(false);
    const [isVerifyChecked, setIsVerifyChecked] = useState(false)
    const [workerDet, setWorkerDet] = useState([]);


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
        { field: "intId", headerName: "رقم", flex: 0.5 },
        {
            field: "Name",
            headerName: "الاسم",
            flex: 0.5,
            valueGetter: (params) => {
                const firstName = params.row.strFirstName || "";
                const lastName = params.row.strLastName || "";
                return `${firstName} ${lastName}`
            }
        },
        { field: "strPhoneNumber", headerName: "رقم الهاتف", flex: 0.5 },
        {
            field: "Action",
            headerName: "عرض المعلومات",
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

    const fullName = (firstName, secontName) => {
        return `${firstName} ${secontName}`
    }

    return (
        <Box margin="2rem 0 0 0" height="75vh" sx={{ flex: 1, overflow: 'hidden', }}>
            <DataGrid
                rows={data}
                columns={columns}
                getRowId={(row) => row.intId}
                components={{
                    Toolbar: GridToolbar,
                }}
                density="compact"
                className="responsive-grid"
                sx={{ fontWeight: 'bold' }}
            />

            <Dialog
                open={open}
                onClose={handleClose}
                maxWidth="md"
                fullWidth
            >
                <DialogTitle>معلومات المستخدم</DialogTitle>
                <DialogContent>
                    {selectedUser && (
                        <div className="Users-container">
                            <div className="user-info1">
                                <FlexBetween>
                                    <Typography variant="h2" id="Name">
                                        {selectedUser.strFirstName}
                                        <br />
                                        <Typography variant="h6" id="ntid">
                                            {selectedUser.strNationalId}
                                        </Typography>
                                    </Typography>
                                    <Link to={`/auth/message?name=${fullName(selectedUser.strFirstName,selectedUser.strLastName)}`}>
                                        <Button id="msgbtn" variant="contained" endIcon={<SendIcon />}>
                                            مراسلة
                                        </Button>
                                    </Link>
                                </FlexBetween>
                            </div>
                            <hr />
                            <div className="basicInfo">
                                <Typography variant="h4" id="basicInfoTitle" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>المعلومات الشخصية</Typography>
                                <br />
                                <br />
                                <Stack direction="row" spacing={2} sx={{ width: "90%" }}>

                                    <Stack spacing={2} sx={{ flexGrow: 1, }}>

                                        <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>الايميل<br />  {selectedUser.intId}</Typography>
                                        <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>الهاتف<br /> {selectedUser.strFirstName}</Typography>
                                        <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>البلد<br /> {selectedUser.strLastName}</Typography>

                                    </Stack >

                                    <Stack >

                                        <Typography variant="h3" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>حظر العامل</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
                                                <Switch
                                                    checked={isBlacklistChecked}
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
                                                <Typography variant="h5" sx={{ fontSize: '14px', fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
                                                    العامل سيحظر ولن يستلم أي عمل جديد أبدًا
                                                </Typography>

                                            </FlexBetween>

                                        </Typography>

                                        <br />
                                        <br />
                                        <Typography variant="h3" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>توثيق العامل</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
                                                <Switch
                                                    checked={isVerifyChecked}
                                                    onChange={async (event) => {
                                                        const newVerifyChecked = event.target.checked;
                                                        setIsVerifyChecked(newVerifyChecked);

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
                                                <Typography variant="h5" sx={{ fontSize: '14px', fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
                                                    تفعيل هذه سيجعل للعامل افضلية
                                                </Typography>
                                            </FlexBetween>

                                        </Typography>
                                    </Stack>
                                </Stack>


                            </div>



                        </div>
                    )}
                </DialogContent>
            </Dialog>
        </Box>
    );
}

export default ShowWorkersDataGrid