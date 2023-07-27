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
  Divider 
} from '@mui/material';
import { useNavigate, Link } from "react-router-dom";
import { styled } from '@mui/material/styles';
import { Inbox, Mail, ChevronLeft, ChevronRight } from '@mui/icons-material';
import GetMenus from "../../../Routes/SideBarMenus";

const RTLSideBar = ({ isOpen, onClose, user }) => {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [activeListItem, setActiveListItem] = useState(null);

  const navigate = useNavigate();

  const ColoredDivider = styled(Divider)(({ theme }) => ({
    backgroundColor: '#C9BD40',
    width: '80%',
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
    backgroundColor: "#C92C6A",
    color: "#FFFFFF",
    width: '100%',
    borderRadius: "15px",
  };
  
  const renderSubMenuItems = (menuItems) => {
    return (
      <List component="div" disablePadding>
        {menuItems.map((menu, index) => (
          <ListItem
            button
            key={index}
            component={Link}
            to={menu.path}
            sx={{
              pl: 4,
              color: '#18AAC9',
              ...(menu.path === window.location.pathname && activeListItemStyle),
            }}
            onClick={() => handleListItemClick(index, menu.path, true)}
          >
            <ListItemIcon>{menu.icon}</ListItemIcon>
            <ListItemText primary={menu.text} />
          </ListItem>
        ))}
      </List>
    );
  };
  
  const renderMenuItems = (menuItems) => {
    return (
      <Box width="80%" mx="auto">
        <List sx={{ width: '100%' }}>
          {menuItems.map((menu, index) => {
            if (menu.children) {
              return (
                <React.Fragment key={index}>
                  {index > 0 && <ColoredDivider />}
                  <ListItem button onClick={() => handleListItemClick(index, menu.path, false)}>
                    <ListItemIcon>{menu.icon}</ListItemIcon>
                    <ListItemText primary={menu.text} />
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
                    color: '#18AAC9',
                    ...(index === activeListItem && activeListItemStyle),
                  }}
                  onClick={() => handleListItemClick(index, menu.path, false)}
                >
                  <ListItemIcon>{menu.icon}</ListItemIcon>
                  <ListItemText primary={menu.text} />
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
        },
      }}
    >
      <Box display="flex" flexDirection="column" height="100%" width="100%">
        <Box sx={{ p: 2 }}>
          <h1>Road Damage</h1>
        </Box>
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
