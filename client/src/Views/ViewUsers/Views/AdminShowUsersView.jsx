import { useEffect, useState } from "react";
import ShowUsersDataGrid from "../Components/showUsersDataGrid";
import GetUser from "../Service/GetUserApi";
import {
    Button,
    Snackbar,
    Stack,
    Typography,
    useTheme,
    SwipeableDrawer,
    Grid,
    Box,
} from "@mui/material";

// Icons
import { ArrowCircleUp, ArrowCircleDown } from "@mui/icons-material";
import CustomFilter from "../Components/CustomFilter";


const AdminShowUsersView = () => {
    const pageSize = 20

    const [users, setUsers] = useState([])
    const [userId, setUserId] = useState(null)
    const [pageNumber, setPageNumber] = useState(1);
    const [verifiedUser, setVerifiedUser] = useState(false)
    const [blacklistedUser, setBlacklistedUser] = useState(false);

    const selectedUser = users.find((user) => user.intId === userId) || null;

    useEffect(() => {
        const setShowUser = async () => {
            const response = await GetUser(
                pageNumber,
                pageSize,
                verifiedUser, 
                blacklistedUser 
            );
            setUsers(response.data);
        };
        setShowUser();
    }, [pageNumber, pageSize, verifiedUser, blacklistedUser]);


    const handleFilterChange = (filterType, value) => {
        if (filterType === "verified") {
            setVerifiedUser(value);
        } else if (filterType === "blacklisted") {
            setBlacklistedUser(value);
        }
        setPageNumber(1);
    };


    const handleForwardClick = () => {
        setPageNumber(prevPageNumber => prevPageNumber + 1);
    };

    const handleBackClick = () => {
        setPageNumber(prevPageNumber => prevPageNumber - 1);
    };



    return (
        <Grid container spacing={2}>
            <Grid item xs={12} md={8}>
                <ShowUsersDataGrid data={users} id={selectedUser} />
                <Box sx={{ float: 'right' }}>
                    <Button
                        variant="contained"
                        color="primary"
                        onClick={handleForwardClick}
                        disabled={users.length < pageSize} 
                    >
                        <ArrowCircleDown />
                    </Button>

                    <Button
                        variant="contained"
                        color="primary"
                        onClick={handleBackClick}
                        disabled={pageNumber == 1} 
                    >
                        <ArrowCircleUp />
                    </Button>
                </Box>
            </Grid>
            <Grid item xs={12} md={4}>
                <CustomFilter onFilterChange={handleFilterChange} />
            </Grid>
        </Grid>
    )
}

export default AdminShowUsersView;
