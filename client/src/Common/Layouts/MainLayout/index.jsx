import React, { useState, useEffect } from "react";
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
import "./Components/style.css";

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
  marginRight: isSidebarOpen ? "290px" : "0",
  marginLeft: isSidebarOpen ? "0" : "10",
  transition: "margin 0.3s ease",
  width: isSidebarOpen ? "calc(100vw - 270px)" : "100%", 
  flexDirection: "row-reverse",
}));

function Layout() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const user = IdentityHelper.UserData;

  const handleSidebarToggle = () => {
    setIsSidebarOpen(!isSidebarOpen);
  };

  useEffect(() => {
    const handleResize = () => {
      if (!isSidebarOpen) {
        window.dispatchEvent(new Event("resize"));
      }
    };

    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, [isSidebarOpen]);

  return (
    <Main dir="rtl">
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



//LTR
/*
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
*/