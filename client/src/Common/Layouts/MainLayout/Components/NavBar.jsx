import React, { useContext } from "react";
import {
  LightModeOutlined,
  DarkModeOutlined,
  SettingsOutlined,
} from "@mui/icons-material";
import { AppBar, Chip, IconButton, Toolbar, useTheme } from "@mui/material";
import { Link } from "react-router-dom";
import { styled } from "@mui/system";
import FaceIcon from '@mui/icons-material/Face';
import "./style.css"
// Project Imports
import { FlexBetween } from "../../../Components/FlexBetween";
import AccSetting from "../../../../Views/AccountSettings/index"

// png
import amman from './amman.png'

// Context
import AppContext from "../../../Context/AppContext";
import AccountMenu from "./AccountMenu";

const Navbar = ({ user }) => {
  const theme = useTheme();
  const { ToggleDisplayMode } = useContext(AppContext);

  // Custom styled Chip for the icon buttons
  /*const IconChip = styled(Chip)({
    borderRadius: '50%',
    padding: '25px',
    backgroundColor: '#E1F1FD', // Corrected color value
    '& .MuiChip-avatar': {
      borderRadius: '50%', // Use '50%' to create a circular shape
      backgroundColor: '#FFFFFF', // White background
    },
  });*/

  return (
    <AppBar
      theme={theme}
      sx={{
        height: "5rem",
        position: "static",
        background: "none",
        boxShadow: "none",
      }}
      dir="rtl"
    >
      <Toolbar sx={{ justifyContent: "space-between" }}>
        <img
          src={amman}
          alt="امانة عمان الكبري"
          style={{
            maxWidth: '100%',
            maxHeight: '80px',
            height: 'auto',
            width: 'auto',
            display: 'block',
            padding: '5px',
            margin: '0'
          }}
        />
        {/* LEFT SIDE */}
        <FlexBetween />
        {/* RIGHT SIDE */}
        <FlexBetween gap="1.5rem" className="iconChip">
          <div>
            <IconButton onClick={ToggleDisplayMode}>
              {theme.palette.mode === "dark" ? (
                <DarkModeOutlined
                  color="primary"
                  sx={{ fontSize: "25px" }}
                />
              ) : (
                <LightModeOutlined
                  color="#FFFFFF"
                  sx={{ fontSize: "25px" }}
                />
              )}
            </IconButton>
            <IconButton component={Link} to="/auth/account">
              <SettingsOutlined color="primary" sx={{ fontSize: "25px", color: 'gray' }} />
            </IconButton>
            <IconButton>
              <AccountMenu user={user} sx={{ color: '#18AAC9', }} id="accMenue" />
            </IconButton>

          </div>
        </FlexBetween>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;
