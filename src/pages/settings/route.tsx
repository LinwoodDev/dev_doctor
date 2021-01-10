import {
  Box,
  createStyles,
  Divider,
  Drawer,
  Hidden,
  IconButton,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  makeStyles,
  Paper,
  Theme,
  useTheme,
} from "@material-ui/core";
import React, { ReactElement } from "react";
import { useTranslation } from "react-i18next";
import MyAppBar from "../../components/appbar";
import HomeOutlinedIcon from '@material-ui/icons/HomeOutlined';
import MenuIcon from "@material-ui/icons/Menu";
import { Route, RouteComponentProps, Switch, useRouteMatch } from "react-router-dom";
import AppearanceSettingsPage from "./appearance";
import SettingsHomePage from "./home";
import GetAppOutlinedIcon from '@material-ui/icons/GetAppOutlined';
import TuneOutlinedIcon from '@material-ui/icons/TuneOutlined';
import ListOutlinedIcon from '@material-ui/icons/ListOutlined';

const drawerWidth = 240;

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      display: "flex",
    },
    drawer: {
      [theme.breakpoints.up("sm")]: {
        width: drawerWidth,
        flexShrink: 0,
      },
    },
    appBar: {
      [theme.breakpoints.up("sm")]: {
        width: `calc(100% - ${drawerWidth}px)`,
        marginLeft: drawerWidth,
      },
    },
    menuButton: {
      marginRight: theme.spacing(2),
      [theme.breakpoints.up("sm")]: {
        display: "none",
      },
    },
    // necessary for content to be below app bar
    toolbar: theme.mixins.toolbar,
    drawerPaper: {
      width: drawerWidth,
    },
    content: {
      flexGrow: 1,
      padding: theme.spacing(3),
    },
  })
);

export default function SettingsPageRoute(props: RouteComponentProps): ReactElement {
  const { t } = useTranslation("settings");
  const classes = useStyles();
  const theme = useTheme();
  const [mobileOpen, setMobileOpen] = React.useState(false);

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };
  const pushSettings = (page : string) => {
    props.history.push(`/settings/${page}`);
  }
  const drawer = (
    <div>
      <div className={classes.toolbar} />
      <Divider />
      <List>
          <ListItem button onClick={() => pushSettings('')}>
            <ListItemIcon>
              <HomeOutlinedIcon />
            </ListItemIcon>
            <ListItemText primary={t('home.title')} />
          </ListItem>
          <ListItem button onClick={() => pushSettings('')}>
            <ListItemIcon>
              <TuneOutlinedIcon />
            </ListItemIcon>
            <ListItemText primary={t('appearance.title')} />
          </ListItem>
          <ListItem button onClick={() => pushSettings('appearance')}>
            <ListItemIcon>
              <GetAppOutlinedIcon />
            </ListItemIcon>
            <ListItemText primary={t('downloads.title')} />
          </ListItem>
          <ListItem button onClick={() => pushSettings('downloads')}>
            <ListItemIcon>
              <ListOutlinedIcon />
            </ListItemIcon>
            <ListItemText primary={t('servers.title')} />
          </ListItem>
      </List>
    </div>
  );
  let { path } = useRouteMatch();

  return (
    <>
      <MyAppBar title={t("settings")} />x
      <nav className={classes.drawer} aria-label="mailbox folders">
        {/* The implementation can be swapped with js to avoid SEO duplication of links. */}
        <Hidden smUp implementation="css">
          <Drawer
            variant="temporary"
            anchor={theme.direction === "rtl" ? "right" : "left"}
            open={mobileOpen}
            onClose={handleDrawerToggle}
            classes={{
              paper: classes.drawerPaper,
            }}
            ModalProps={{
              keepMounted: true, // Better open performance on mobile.
            }}
          >
            {drawer}
          </Drawer>
        </Hidden>
        <Hidden xsDown implementation="css">
          <Drawer
            classes={{
              paper: classes.drawerPaper,
            }}
            variant="permanent"
            open
          >
            {drawer}
          </Drawer>
        </Hidden>
      </nav>
      <main className={classes.content}>
        <div className={classes.toolbar} />
        <Paper>
          <Box p={2}>
            <IconButton
              color="inherit"
              aria-label="open drawer"
              edge="start"
              onClick={handleDrawerToggle}
              className={classes.menuButton}
            >
              <MenuIcon />
            </IconButton>
          </Box>
        </Paper>
        <Switch>
          <Route exact path={path} component={SettingsHomePage} />
          <Route
            path={`${path}/appearance`}
            component={AppearanceSettingsPage}
          />
        </Switch>
      </main>
    </>
  );
}
