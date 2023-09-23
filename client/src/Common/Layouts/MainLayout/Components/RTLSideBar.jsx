import React, { useState } from 'react';
import {
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  IconButton,
  Box,
  Collapse,
  Divider,
  Typography
} from '@mui/material';
import { useNavigate, Link } from "react-router-dom";
import { styled } from '@mui/material/styles';
import { Inbox, Mail, ChevronLeft, ChevronRight } from '@mui/icons-material';
import GetMenus from "../../../Routes/SideBarMenus";
import logo from "./e3maar.png"
// css style
import "../Components/style.css"
const CustomTypography = styled(Typography)({
  margin: 0,
  fontSize: '1rem', // Your desired font size
  color: '#181818', // Your desired font color
  fontWeight: 400, // Your desired font weight
  fontFamily: 'Arial, sans-serif', // Your desired font family
  lineHeight: 1.5, // Your desired line height
  transition: 'all 0.25s',

  '&:hover': {
    color: '#181818',

    // Change font color on hover
    // Add other hover styles
  }, '&:active': {
    color: '#181818',
    // Change font color on hover
    // Add other hover styles,
  }
});
const RTLSideBar = ({ isOpen, onClose, user }) => {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [activeListItem, setActiveListItem] = useState(null);

  const navigate = useNavigate();

  const ColoredDivider = styled(Divider)(({ theme }) => ({
    backgroundColor: '#C9BD40',
    width: '100%',
    margin: 'auto',
    marginTop: '1rem',
    marginBottom: '1rem',
  }));

  const handleCollapseToggle = () => {
    setIsCollapsed(!isCollapsed);
    if (isCollapsed) {
      setActiveListItem(null);
    }
  };

  const handleListItemClick = (index, path, hasChildren) => {
    if (!hasChildren) {
      setActiveListItem(index);
      navigate(path);
    } else {
      setActiveListItem(null);
    }
  };

  const sidebarMenus = GetMenus(user.userType);

  const activeListItemStyle = {
    backgroundColor: "#c92c6b22",
    border: "1px solid #c92c6b",
    width: '100%',
    borderRadius: "5px",
    transition: 'all 0.25s',

  };
  const StyledListItem = styled(ListItem)(({ theme, isActive }) => ({
    paddingLeft: theme.spacing(4),
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(1), border: "1px solid transparent",

    transition: 'all 0.25s',


    '&:hover': {
      borderRadius: "5px",
      border: "1px solid #c92c6b",
      transition: 'all 0.25s',

    },
    // Change font color on hover
    // Add other hover styles

    ...(isActive && activeListItemStyle),
  }));
  const renderSubMenuItems = (menuItems) => {
    return (
      <List component="div" disablePadding>
        {menuItems.map((menu, index) => (
          <StyledListItem
            button
            key={index}
            component={Link}
            to={menu.path}
            className='menuItemStyle'
            sx={{
              pl: 8,
              ...(menu.path === window.location.pathname && activeListItemStyle),
            }}
            isActive={menu.path === window.location.pathname}

            onClick={() => handleListItemClick(index, menu.path, true)}
          >
            <ListItemIcon>{menu.icon}</ListItemIcon>
            <CustomTypography variant='h5'  >{menu.text}</CustomTypography>
          </StyledListItem>
        ))}
      </List>
    );
  };

  const renderMenuItems = (menuItems) => {
    return (
      <Box width="80%" mx="auto" sx={{ fontWeight: 'bold' }}>
        <List sx={{ width: '100%', fontSize: '16px' }}>
          {menuItems.map((menu, index) => {
            if (menu.children) {
              return (
                <React.Fragment key={index}>
                  {index > 0 && <ColoredDivider />}
                  <ListItem sx={{ fontSize: '5rem', pl: 8, }} button onClick={() => handleListItemClick(index, menu.path, false)}>
                    <ListItemIcon>{menu.icon}</ListItemIcon>
                    <Typography variant='h4' sx={{ color: "#181818" }}>{menu.text}</Typography>
                  </ListItem>
                  <Collapse in={true} timeout="auto" unmountOnExit>
                    {renderSubMenuItems(menu.children)}
                  </Collapse>
                </React.Fragment>
              );
            } else {
              return (
                <ListItem
                  button
                  key={index}
                  component={Link}
                  to={menu.path}
                  sx={{
                    color: '#181818',
                    fontWeight: 'bold',
                    pl: 16,
                    ...(index === activeListItem && activeListItemStyle),
                  }}
                  onClick={() => handleListItemClick(index, menu.path, false)}
                >
                  <ListItemIcon>{menu.icon}</ListItemIcon>
                  <Typography variant='h4' sx={{ color: "#181818" }}>{menu.text}</Typography>
                </ListItem>
              );
            }
          })}
        </List>
      </Box>
    );
  };

  return (
    <Drawer
      anchor="right"
      open={isOpen}
      onClose={onClose}
      variant="persistent"
      PaperProps={{
        sx: {
          width: isCollapsed ? "0px" : "300px",
          overflowX: isCollapsed ? "hidden" : "visible",
          transition: "width 0.3s ease",
          marginLeft:'1rem ',
        },
      }}
    >
      <Box display="flex" flexDirection="column" height="100%" width="100%" sx={{ backgroundColor: 'transparent' }}>
        <img
          src={logo}
          alt="اعمار"
          style={
            {
              maxWidth: '100%',
              maxHeight: '100px',
              width: 'auto',
              height: 'auto',
              display: 'block',
              margin: '0 auto',
              backgroundColor: 'red'
            }
          }
        />
        {!isCollapsed && (
          <List>
            {renderMenuItems(sidebarMenus)}
          </List>
        )}
      </Box>
    </Drawer>
  );
};

export default RTLSideBar;
