import React, { useContext } from "react";
import {
  LightModeOutlined,
  DarkModeOutlined,
  SettingsOutlined,
} from "@mui/icons-material";
import { AppBar, Chip, IconButton, Toolbar, useTheme } from "@mui/material";
import { styled } from "@mui/system";
import FaceIcon from '@mui/icons-material/Face';


// Project Imports
import { FlexBetween } from "../../../Components/FlexBetween";

// Context
import AppContext from "../../../Context/AppContext";
import AccountMenu from "./AccountMenu";

const Navbar = ({ user }) => {
  const theme = useTheme();
  const { ToggleDisplayMode } = useContext(AppContext);

  // Custom styled Chip for the icon buttons
  const IconChip = styled(Chip)({
    borderRadius: "50%",
    padding: '25px',
    backgroundColor: '##E1F1FD',
    "& .MuiChip-avatar": {
      borderRadius: "60%",
      backgroundColor: '##E1F1FD',

    },
  });

  return (
    <AppBar
      theme={theme}
      sx={{
        height: "4rem",
        position: "static",
        background: "none",
        boxShadow: "none",
      }}
    >
      <Toolbar sx={{ justifyContent: "space-between" }}>
        {/* LEFT SIDE */}
        <FlexBetween />
        {/* RIGHT SIDE */}
        <FlexBetween gap="1.5rem">
          <IconChip
            avatar={
              <>
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
                <IconButton>
                  <SettingsOutlined color="primary" sx={{ fontSize: "25px", color: 'gray' }} />
                </IconButton>
                
                <Chip sx={{p:1}} icon={<FaceIcon />} label={<AccountMenu user={user} sx={{color: '#18AAC9'}} />} variant="outlined" />
              </>
            }
          />
          
        </FlexBetween>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;
