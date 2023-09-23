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
import { Link } from "react-router-dom"; // Import the Link component


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
        { field: "intId", headerName: "رقم", flex: 0.5 },
        { field: "strUsername", headerName: "اسم المستخدم", flex: 0.5 },
        {
            field: "name",
            headerName: "الاسم",
            flex: 0.5,
            valueGetter: (params) => {
                const firstName = params.row.strFirstNameAr || params.row.strFirstName;
                const LastName = params.row.strLastNameAr || params.row.strLastName;
                return `${firstName} ${LastName}`
            }
        },
        {
            field: "Action",
            headerName: "عرض",
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
        <Box margin="2rem 0 0 0" height="75vh" sx={{ flex: 1, width: '100%' }}>
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
                <DialogTitle sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>معلومات المستخدم</DialogTitle>
                <DialogContent>
                    {selectedUser && (

                        <div className="Users-container">
                            <div className="user-info1">
                                <FlexBetween>
                                    <Typography variant="h2" id="Name">
                                        {selectedUser.strFirstName}
                                        <br />
                                        <Typography variant="h6" id="ntid" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
                                            {selectedUser.strFirstName} {selectedUser.strLastName} :الاسم الكامل
                                        </Typography>
                                    </Typography>
                                    <Link to={`/auth/message?name=${selectedUser.strFirstName}`}>
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

                                        <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>رقم <br />  {selectedUser.intId}</Typography>
                                        <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>الاسم الاول<br /> {selectedUser.strFirstName}</Typography>
                                        <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>الاسم الاخير<br /> {selectedUser.strLastName}</Typography>
                                    </Stack >

                                    <Stack >

                                        <Typography variant="h3" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>حظر المستخدم</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
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

                                                <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>المستخدم لن يستطيع التصويت او الابلاغ عن مشاكل</Typography>


                                            </FlexBetween>

                                        </Typography>

                                        <br />
                                        <br />
                                        <Typography variant="h3" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>توثيق المستخدم</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
                                                <Switch
                                                    checked={selectedUser?.boolIsVerified === true}
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

                                                <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>تفعيل هذا الخيار يعطي صاحب الحساب افضلية</Typography>
                                            </FlexBetween>

                                        </Typography>
                                        <br />
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
