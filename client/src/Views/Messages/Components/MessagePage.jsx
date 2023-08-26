import React, { useState } from "react";
import {
  TextField,
  Button,
  Container,
  Paper,
  Typography,
  Divider,
  Box,
} from "@mui/material";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import { useLocation } from "react-router-dom";
import InfoIcon from '@mui/icons-material/Info';

// css
import "../Styles/style.css"

const MessagePage = () => {
  const [message, setMessage] = useState("");
  const [sentMessages, setSentMessages] = useState([]);

  const location = useLocation();
  const queryParams = new URLSearchParams(location.search);
  const userName = queryParams.get("name");

  const handleSendMessage = () => {
    if (message.trim() !== "") {
      setSentMessages((prevMessages) => [...prevMessages, message]);
      setMessage("");
    }
  };

  return (
    <Box>
      <Box display="flex" height="70vh">
        {/* Right side with message input and sent messages */}
        <Box
          width="80%"
          height="100%"
          display="flex"
          flexDirection="column"
          padding="1rem"
        >
          <Paper elevation={3} style={{ padding: "1rem", flex: 1, }}>
            <Typography variant="h5" gutterBottom>
              <FlexBetween>
              <Typography sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif', fontWeight: 'bold', fontSize: '16px'}}>{userName}</Typography>
              <InfoIcon sx={{cursor: 'pointer'}}/>
              </FlexBetween>
            </Typography>
            <Divider />
            <br />
            <div style={{ flex: 1, overflowY: "scroll" }}>
              {sentMessages.map((msg, index) => (
                <Typography key={index} variant="body1">
                  <Typography sx={{fontFamily: 'Droid Arabic Naskh, sans-serif', paddingBottom : '6px' }}>{msg}</Typography>
                </Typography>
              ))}
            </div>
          </Paper>
        </Box>
        {/* Left side with sample contacts */}
        <Box
          width="20%"
          height="100%"
          borderRight="1px solid #ccc"
          padding="1rem"
          overflowY="scroll"
          dir="ltr"
        >
          {/* Sample contacts */}
          <Typography variant="h3" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif', direction: 'rtl' }}>الرسائل</Typography>
          <br />
          <Divider />
          <br />
          <Box>
            <Paper sx={{borderRadius: '25px', cursor: 'pointer'}}>
              <Typography variant="body1" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif', p: 2, }}>Admin</Typography>
            </Paper>
            <br />
            <Paper sx={{borderRadius: '25px', cursor: 'pointer',}}>
              <FlexBetween>
              <Typography variant="body1" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif', p: 2, }}>Ibrahim</Typography>
              <span id="msg">3</span>
              </FlexBetween>
            </Paper>
            <br />
            <Paper sx={{borderRadius: '25px', cursor: 'pointer'}}>
              <Typography variant="body1" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif', p: 2, }}>Kareem</Typography>
            </Paper>
          </Box>
        </Box>

      </Box>
      <Box sx={{ display: 'grid', width: '63vw' }}>
        <TextField
          label="اكتب رسالة"
          variant="outlined"
          fullWidth
          multiline
          rows={4}
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          sx={{
            display: "grid",
            placeItems: "end",
            gap: "0.5rem",
            marginBottom: "1rem",
          }}
        />
        <Button variant="contained" color="primary" onClick={handleSendMessage} >
          Send
        </Button>
      </Box>
    </Box>
  );
};

export default MessagePage;
