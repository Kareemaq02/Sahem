import React, { useState } from "react";
import { Typography, TextField, Button } from "@mui/material";
import axios from "axios";

function AdminViewAccountDetails() {
  const [newUserName, setNewUserName] = useState("");
  const [newEmail, setNewEmail] = useState("");
  const [newPhoneNumber, setNewPhoneNumber] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [oldPassword, setOldPassword] = useState("");

  const handleUpdate = async () => {
    try {
      const response = await axios.put("/api/account/update", {
        strNewUserName: newUserName,
        strNewEmail: newEmail,
        strNewPhoneNumber: newPhoneNumber,
        strNewPassword: newPassword,
        strOldPassword: oldPassword,
      });

      console.log(response.data); // Handle the response as needed
    } catch (error) {
      console.error(error); // Handle the error as needed
    }
  };

  return (
    <div style={{
      backgroundColor: '#ffffff',
      padding: '1.5rem ',
      width: '73.125rem',
      marginRight: 'Auto',
      marginLeft: 'Auto',
      borderRadius: '5px',
      border: '1px solid #c5c5c5',
    }}>
      <Typography vavariant="h1" component="h1" sx={{
        padding: '0.5rem',
        margin: '0.5rem',
        textAlign: 'center',
        width: '100%',
      }}>
        Admin View Account Details
      </Typography>

      <TextField
        label="New Username"
        value={newUserName}
        onChange={(e) => setNewUserName(e.target.value)}
        fullWidth
        margin="normal"
      />

      <TextField
        label="New Email"
        value={newEmail}
        onChange={(e) => setNewEmail(e.target.value)}
        fullWidth
        margin="normal"
      />

      <TextField
        label="New Phone Number"
        value={newPhoneNumber}
        onChange={(e) => setNewPhoneNumber(e.target.value)}
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
        label="Old Password"
        value={oldPassword}
        onChange={(e) => setOldPassword(e.target.value)}
        type="password"
        fullWidth
        margin="normal"
      />

      <div style={{ 
      padding: '0.5rem 30rem',
      width: '100%',}}>
        <Button variant="contained" color="primary" onClick={handleUpdate} sx={{
          width: "100%", padding: '15px 30px', marginRight: 'Auto',
          marginLeft: 'Auto',
        }}>
          Update
        </Button>
      </div>

    </div>
  );
}

export default AdminViewAccountDetails;
