import React, { useState } from "react";
import { Typography, TextField, Button, Grid } from "@mui/material";
import { IdentityHelper } from "../../../Common/Utils/IdentityHelper";
import { UpdateInfoApi } from "../Service/UpdateInfoApi";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

function CitizenViewAccountDetails() {
  //use struct
  const [user, setUser] = useState(IdentityHelper.UserData);
  const [newUserName, setNewUserName] = useState(user.username);
  const [newPhoneNumber, setNewPhoneNumber] = useState(user.phoneNumber);
  const [newPassword, setNewPassword] = useState("");
  const [oldPassword, setOldPassword] = useState("");

  const handleUpdate = async () => {
    UpdateInfoApi({
      strNewUserName: newUserName,
      strNewPhoneNumber: newPhoneNumber,
      strNewPassword: newPassword,
      strOldPassword: oldPassword,
    })
      .then((response) => {
        if (response.data) {
          setUser(IdentityHelper.UserData);
          IdentityHelper.removeToken();
          IdentityHelper.token = response.data;
          toast.success("Info successfully updated!");
        } else {
          console.log("test");
          // Display error message from response if it exists
          const errorMessage =
            response && response.data
              ? response.data
              : "Unknown error occurred";
          toast.error(
            `An error occurred while updating user information. ${errorMessage}`
          );
        }
      })
      .catch((error) => {
        console.log("test");
        // console.log(error.response.status);
        // console.log(error.response.data);
        console.log(error.request);
        if (error.response && error.response.data) {
          console.log("test");
          const errorMessage = error.response.data;
          toast.error(
            `An error occurred while updating user information. ${errorMessage}`
          );
        } else {
          toast.error("An error occurred while updating user information.");
        }
      });

    // try {
    //   const response = await UpdateInfoApi({
    //     strNewUserName: newUserName,
    //     strNewPhoneNumber: newPhoneNumber,
    //     strNewPassword: newPassword,
    //     strOldPassword: oldPassword,
    //   });

    //   console.log("Response:", response); // Debugging: Log the entire response object

    //   if (response.data) {
    //     setUser(IdentityHelper.UserData);
    //     IdentityHelper.removeToken();
    //     IdentityHelper.token = response.data;
    //     toast.success("Info successfully updated!");
    //   } else {
    //     console.log("test");
    //     // Display error message from response if it exists
    //     const errorMessage =
    //       response && response.data ? response.data : "Unknown error occurred";
    //     toast.error(
    //       `An error occurred while updating user information. ${errorMessage}`
    //     );
    //   }
    // } catch (error) {
    //   console.log("test");
    //   if (error.response && error.response.data) {
    //     const errorMessage = error.response.data;
    //     toast.error(
    //       `An error occurred while updating user information. ${errorMessage}`
    //     );
    //   } else {
    //     toast.error("An error occurred while updating user information.");
    //   }
    // }
  };

  return (
    <div style={{ 
      backgroundColor: '#ffffff', 
      padding: '1.5rem ',
      width: '73.125rem',
      marginRight: 'Auto',
      marginLeft: 'Auto',
      borderRadius:'5px',
      border:'1px solid #c5c5c5',
      }} >
      <Typography variant="h1" component="h1" sx={{
        padding: '0.5rem',
        margin: '0.5rem', 
        textAlign:'center',
        width: '100%',
      }}>
        Edit Account Details
      </Typography>

      <Grid container spacing={2} alignItems="center" sx={{
        width: '100%',
        margin: '0.5rem',

      }}>
        <Grid item xs={6}>
          <TextField
            label="First Name"
            value={user.firstName}
            disabled
            fullWidth
            margin="normal"
          />
        </Grid>
        <Grid item xs={6}>
          <TextField
            label="Last Name"
            value={user.lastName}
            disabled
            fullWidth
            margin="normal"
          />
        </Grid>
      </Grid>

      <TextField
        label="Username"
        value={newUserName}
        onChange={(e) => setNewUserName(e.target.value)}
        fullWidth
        margin="normal"
      />

      <TextField
        label="Phone Number"
        value={newPhoneNumber}
        onChange={(e) => setNewPhoneNumber(e.target.value)}
        fullWidth
        margin="normal" 
      />

      <TextField
        label="Old Password"
        value={oldPassword}
        onChange={(e) => setOldPassword(e.target.value)}
        type="password"
        fullWidth
        margin="normal"
      />
      <TextField
        label="New Password"
        value={newPassword}
        onChange={(e) => setNewPassword(e.target.value)}
        type="password"
        fullWidth
        margin="normal"
      />
      <TextField
        label="Confirm New Password"
        value={newPassword}
        onChange={(e) => setNewPassword(e.target.value)}
        type="password"
        fullWidth
        margin="normal"
      />
      <br />
      <br />
      <div style={{ 
      padding: '0.5rem 30rem',
      width: '100%',
      }}>

      <Button variant="contained" color="primary" onClick={handleUpdate} sx={{ width: "100%", padding:'15px 30px',  marginRight: 'Auto',
      marginLeft: 'Auto', }}>
        Update
      </Button>
      </div>

      <ToastContainer />
    </div>
  );
}

export default CitizenViewAccountDetails;
