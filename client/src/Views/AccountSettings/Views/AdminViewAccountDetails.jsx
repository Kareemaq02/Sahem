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
    <div>
      <Typography variant="h1" component="h1">
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

      <Button variant="contained" color="primary" onClick={handleUpdate}>
        Update
      </Button>
    </div>
  );
}

export default AdminViewAccountDetails;
