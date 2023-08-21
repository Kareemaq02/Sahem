import React, { useState } from "react";
import { Box, Dialog, DialogTitle, DialogContent, Button, IconButton, Paper, Typography, Stack, Divider } from "@mui/material";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
//import "../index.css"
import SendIcon from '@mui/icons-material/Send';
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import Switch from '@mui/material/Switch';



const ShowWorkersDataGrid = ({data}) => {

    const [open, setOpen] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null);

    const handleOpen = (user) => {
        setSelectedUser(user);
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
    };

    const columns = [
        { field: "intId", headerName: "ID", flex: 0.5 },
        {
             field: "Name",
             headerName: "Name",
            flex: 0.5,
            valueGetter: (params) => {
                const firstName = params.row.strFirstName || "";
                const lastName = params.row.strLastName || "";
                return `${firstName} ${lastName}`
            }
        },
        { field: "strPhoneNumber", headerName: "Date", flex: 0.5 },
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
        <Box margin="2rem 0 0 0" height="75vh" sx={{flex:1, overflow:'hidden'}}>
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

                                        <Typography>Email: <br />  {selectedUser.intId}</Typography>
                                        <Typography>Phone:<br /> {selectedUser.strFirstName}</Typography>
                                        <Typography>Country:<br /> {selectedUser.strLastName}</Typography>
                                        
                                    </Stack >

                                    <Stack >

                                        <Typography variant="h3">Suspend Worker Activities</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
                                                Worker will no longer be able to work or recieve a task

                                                <Switch />
                                            </FlexBetween>

                                        </Typography>

                                        <br />
                                        <br />
                                        <Typography variant="h3">Verify Worker</Typography>

                                        <Typography sx={{ fontSize: "10px" }} variant="h6" id="justify">
                                            <FlexBetween>
                                                Toggling this will make the Worker's reports have a higher over others

                                                <Switch />
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
}

export default ShowWorkersDataGrid