import {
  AppBar,
  Box,
  Button,
  createStyles,
  Divider,
  Drawer,
  Grid,
  Hidden,
  IconButton,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  makeStyles,
  Paper,
  Theme,
  Toolbar,
  Typography,
  useTheme,
} from '@material-ui/core';
import React, { ReactElement } from 'react';
import { useTranslation } from 'react-i18next';
import HomeOutlinedIcon from '@material-ui/icons/HomeOutlined';
import MenuIcon from '@material-ui/icons/Menu';
import {
  Route,
  RouteComponentProps,
  Switch,
  useRouteMatch,
} from 'react-router-dom';
import GetAppOutlinedIcon from '@material-ui/icons/GetAppOutlined';
import TuneOutlinedIcon from '@material-ui/icons/TuneOutlined';
import ListOutlinedIcon from '@material-ui/icons/ListOutlined';
import SettingsHomePage from './home';
import AppearanceSettingsPage from './appearance';
import MyAppBar from '../../components/appbar';
import User from '../../models/user';
import ServersSettingsPage from './servers';

const drawerWidth = 240;

const useStyles = makeStyles((theme: Theme) => createStyles({
  root: {
    display: 'flex',
  },
  drawer: {
    [theme.breakpoints.up('sm')]: {
      width: drawerWidth,
      flexShrink: 0,
    },
  },
  appBar: {
    [theme.breakpoints.up('sm')]: {
      width: `calc(100% - ${drawerWidth}px)`,
      marginLeft: drawerWidth,
    },
  },
  menuButton: {
    marginRight: theme.spacing(2),
    [theme.breakpoints.up('sm')]: {
      display: 'none',
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
    width: '100%',
    overflow: 'auto',
  },
  titleBar: {
    display: 'inline',
  },
}));
enum SettingsPage {
  HOME = '',
  APPEARANCE = 'appearance',
  DOWNLOADS = 'downloads',
  SERVERS = 'servers',
}
interface SettingsParamTypes {
  page: SettingsPage;
}

export interface SettingsProps {
  user: User;
}
export default function SettingsPageRoute(
  props: RouteComponentProps,
): ReactElement {
  const { t } = useTranslation('settings');
  const classes = useStyles();
  const theme = useTheme();
  const [mobileOpen, setMobileOpen] = React.useState(false);

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };
  const pushSettings = (page: SettingsPage) => {
    props.history.push(`/settings/${page}`);
  };
  const match = useRouteMatch<SettingsParamTypes>({
    path: '/settings/:page?',
  });
  const { page } = match.params;
  const createSettingsPageIcon = (page: SettingsPage) => {
    switch (page) {
      case SettingsPage.HOME:
        return <HomeOutlinedIcon />;
      case SettingsPage.APPEARANCE:
        return <TuneOutlinedIcon />;
      case SettingsPage.DOWNLOADS:
        return <GetAppOutlinedIcon />;
      case SettingsPage.SERVERS:
        return <ListOutlinedIcon />;
    }
  };
  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    user.save();
  };
  const drawer = (
    <div>
      <div className={classes.toolbar} />
      <Divider />
      <List>
        {Object.keys(SettingsPage).map((current: string) => (
          <ListItem
            key={current}
            button
            selected={SettingsPage[current] === (page ?? '')}
            onClick={() => pushSettings(SettingsPage[current])}
          >
            <ListItemIcon>
              {createSettingsPageIcon(SettingsPage[current])}
            </ListItemIcon>
            <ListItemText primary={t(`${current.toLowerCase()}.title`)} />
          </ListItem>
        ))}
      </List>
    </div>
  );
  const { path } = useRouteMatch();
  const user = User.load();

  return (
    <div className={classes.root}>
      <MyAppBar title={t('settings')} />
      <nav className={classes.drawer}>
        {/* The implementation can be swapped with js to avoid SEO duplication of links. */}
        <Hidden smUp implementation="css">
          <Drawer
            variant="temporary"
            anchor={theme.direction === 'rtl' ? 'right' : 'left'}
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
        <AppBar position="sticky" color="default">
          <Toolbar>
            <IconButton
              color="inherit"
              aria-label="open drawer"
              edge="start"
              onClick={handleDrawerToggle}
              className={classes.menuButton}
            >
              <MenuIcon />
            </IconButton>
            <Typography>
              {t(
                `${Object.keys(SettingsPage)
                  .filter((x) => SettingsPage[x] === (page ?? ''))[0]
                  ?.toLowerCase()}.title`,
              )}
            </Typography>
          </Toolbar>
        </AppBar>
        <div className={classes.toolbar} />
        <Paper>
          <Box p={2}>
            <form onSubmit={handleSubmit}>
              <Grid container spacing={2}>
                <Grid item xs={12}>
                  <Switch>
                    <Route exact path={path}>
                      <SettingsHomePage user={user} />
                    </Route>
                    <Route path={`${path}/appearance`}>
                      <AppearanceSettingsPage user={user} />
                    </Route>
                    <Route path={`${path}/servers`}>
                      <ServersSettingsPage user={user} />
                    </Route>
                  </Switch>
                </Grid>
                <Grid item xs={12}>
                  <Button type="submit" variant="outlined" color="primary">
                    {t('update')}
                  </Button>
                </Grid>
              </Grid>
            </form>
          </Box>
        </Paper>
      </main>
    </div>
  );
}
