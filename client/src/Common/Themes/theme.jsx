import { createTheme } from "@mui/material/styles";

// Assets
import LightColors from "../../Assets/Styles/_themes-vars.module.scss";

// Project imports
import ThemePalette from "./Palette";
import ThemeTypography from "./Typography";

export const theme = (mode) => {
  // Add Dark Colors then change the code inside Palette.js
  const color = mode === "light" ? LightColors : {};
  const direction = document.documentElement.dir || 'ltr';
  const right = direction === 'ltr' ? 'left' : 'right';
  const left = direction === 'ltr' ? 'right' : 'left';

  const themeOption = {
    colors: color,
    heading: color.grey900,
    paper: color.paper,
    backgroundDefault: color.paper,
    background: color.primaryLight,
    backgroundGradient: color.backgroundGradient,
    darkTextPrimary: color.grey700,
    darkTextSecondary: color.grey500,
    textDark: color.grey900,
    menuSelected: color.secondaryDark,
    menuSelectedBack: color.secondaryLight,
    divider: color.grey200,
    mode: mode,

  };

  const themeOptions = {
    
  };

  const themes = createTheme({
    palette: ThemePalette(themeOption),
    typography: ThemeTypography(themeOption),
    direction: 'rtl',
    left: left,
    right: right,
    marginLeft: `margin-${left}`,
    marginRight: `margin-${right}`,
    paddingLeft: `padding-${left}`,
    paddingRight: `padding-${right}`,
    localCode: document.documentElement.lang
  });

  return themes;
};

export default theme;
