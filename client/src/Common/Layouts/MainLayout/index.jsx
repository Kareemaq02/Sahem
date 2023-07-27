/*import React, { useState, useEffect } from "react";
import { Outlet } from "react-router-dom";
import { Menu, ChevronLeft } from "@mui/icons-material";
import RTLSideBar from "./Components/RTLSideBar";
import Navbar from "./Components/NavBar";

// Mui
import {
  Box,
  CssBaseline,
  IconButton,
  Toolbar,
  Typography,
} from "@mui/material";
import { styled } from "@mui/system";

// Project imports
import ScrollableContent from "../../Components/ScrollableContent";
import { IdentityHelper } from "../../Utils/IdentityHelper";

// Configure JSS

const Main = styled(Box)({
  display: "flex",
  flexFlow: "row",
  height: "100vh",
  width: "100vw",
});

const MainContent = styled("main")(({ theme, isSidebarOpen }) => ({
  backgroundImage: theme?.palette?.background.image,
  flex: "1 1 auto",
  overflow: "hidden",
  marginRight: isSidebarOpen ? "270px" : "0", // Updated: Dynamic marginRight
  marginLeft: isSidebarOpen ? "0" : "25px", // Updated: Dynamic marginLeft
  transition: "margin 0.3s ease", // Updated: Transition for both marginRight and marginLeft
  width: '100vw',
  flexDirection: "row-reverse"
}));

function Layout() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const user = IdentityHelper.UserData;

  const handleSidebarToggle = () => {
    setIsSidebarOpen(!isSidebarOpen);
  };

  useEffect(() => {
    // Function to force Data Grid to resize when sidebar is collapsed
    const handleResize = () => {
      if (!isSidebarOpen) {
        window.dispatchEvent(new Event("resize"));
      }
    };

    // Attach event listener
    window.addEventListener("resize", handleResize);

    // Clean up event listener on component unmount
    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, [isSidebarOpen]);

  return (
    <Main>
      <RTLSideBar
        isOpen={isSidebarOpen}
        onClose={handleSidebarToggle}
        user={user}
      />

      <MainContent isSidebarOpen={isSidebarOpen}>
        <IconButton
          onClick={handleSidebarToggle}
          style={{ zIndex: 1, position: "absolute", right: isSidebarOpen ? "290px" : "25px" }}
        >
          {isSidebarOpen ? <Menu /> : <ChevronLeft />}
        </IconButton>
        <Navbar user={user} />
        <ScrollableContent>
          <Outlet />
        </ScrollableContent>
      </MainContent>
    </Main>
  );
}

export default Layout;
*/


//LTR

import React from "react";
import { useState } from "react";
import { Outlet } from "react-router-dom";

// Mui
import { Box, CssBaseline } from "@mui/material";
import { styled } from "@mui/system";

// Project imports
import Navbar from "./Components/NavBar";
import Sidebar from "./Components/SideBar";
import ScrollableContent from "../../Components/ScrollableContent";
import { IdentityHelper } from "../../Utils/IdentityHelper";

const Main = styled(Box)({
  display: "flex",
  flexFlow: "column",
  height: "100vh",
  width: "100vw",
});

const MainContent = styled("main")(({ theme }) => ({
  backgroundImage: theme?.palette?.background.image,
  height: `calc(100vh - 4rem)`,
  flex: "1 1 auto",
  overflow: "hidden",
}));

function Layout() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const user = IdentityHelper.UserData;

  return user ? (
    <Main>
      <CssBaseline />
      <Navbar user={user} />
      <Sidebar
        isSidebarOpen={isSidebarOpen}
        setIsSidebarOpen={setIsSidebarOpen}
        user={user}
      >
        <MainContent>
          <ScrollableContent>
            <Outlet />
          </ScrollableContent>
        </MainContent>
      </Sidebar>
    </Main>
  ) : (
    <MainContent>
      <ScrollableContent>
        <Outlet />
      </ScrollableContent>
    </MainContent>
  );
}

export default Layout;
