import React, { ReactElement } from "react";
import { createStyles, Theme, makeStyles } from "@material-ui/core/styles";
import {
  Hidden,
  Paper,
  Tab,
  Tabs,
  CircularProgress,
  AppBar,
  Box,
  Typography,
  Grid,
  IconButton,
  Toolbar,
  CssBaseline,
  Drawer,
} from "@material-ui/core";
import {
  Route,
  RouteComponentProps,
  Switch,
  useParams,
  useRouteMatch,
  withRouter,
} from "react-router-dom";
import MenuIcon from "@material-ui/icons/Menu";
import CoursePartItem from "../../../models/items/item";
import CoursePartItemIcon from "../../../components/icon";
import CoursePart from "../../../models/part";
import {
  CoursePartItemParamTypes,
  CoursePartItemRoute,
  CoursePartParamTypes,
} from "./route";
import theme from "../../../theme";

const drawerWidth = 240;

const useStyles = makeStyles((current: Theme) =>
  createStyles({
    root: {
      display: "flex",
    },
    drawer: {
      [current.breakpoints.up("sm")]: {
        width: drawerWidth,
        flexShrink: 0,
      },
    },
    menuButton: {
      marginRight: current.spacing(2),
      [current.breakpoints.up("sm")]: {
        display: "none",
      },
    },
    drawerPaper: {
      width: drawerWidth,
    },
    drawerContainer: {
      overflow: "auto",
    },
    indicator: {
      left: "0px",
    },
    noOverflow: {
      maxWidth: "100%",
    },
    // necessary for content to be below app bar
    toolbar: current.mixins.toolbar,
    content: {
      flexGrow: 1,
      width: "100%",
      backgroundColor: current.palette.background.paper,
      overflow: "auto",
    },
    item: {
      width: "100%",
    },
  })
);
interface Props extends RouteComponentProps {
  parts: CoursePart[];
}

export default function CoursePartItemLayout({
  parts,
  history,
}: Props): ReactElement {
  const [mobileOpen, setMobileOpen] = React.useState(false);
  const match = useRouteMatch<CoursePartItemParamTypes>({
    path: `/courses/:serverId/:courseId/start/:partId/:itemId`,
  });
  const { serverId, courseId, partId } = useParams<CoursePartParamTypes>();
  const { path } = useRouteMatch();
  const part = parts.find((current) => current.slug === partId);

  const item: CoursePartItem = part.items[match?.params?.itemId];

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };
  const handleItemCallToRouter = (_event: React.ChangeEvent, value: any) => {
    history.push(
      `/courses/${serverId}/${part.course.slug}/start/${part.slug}/${value}`
    );
  };
  const handlePartCallToRouter = (_event: React.ChangeEvent, value: any) => {
    history.push(`/courses/${serverId}/${part.course.slug}/start/${value}`);
  };

  const classes = useStyles();
  console.log(part.slug);
  console.log(parts?.map((current) => current.slug));
  if (!item) history.push(`/courses/${serverId}/${courseId}/start/${partId}/0`);
  const drawer = (
    <>
      <Toolbar />
      <div className={classes.drawerContainer}>
        {parts == null ? (
          <CircularProgress />
        ) : (
          <Tabs
            classes={{
              indicator: classes.indicator,
            }}
            orientation="vertical"
            variant="scrollable"
            onChange={handlePartCallToRouter}
            value={part.slug || false}
          >
            {parts.map((current) => (
              <Tab
                label={current.name}
                key={current.slug}
                value={current.slug}
              />
            ))}
          </Tabs>
        )}
        {/* <Divider />
        <List>
          {["All mail", "Trash", "Spam"].map((text, index) => (
            <ListItem button key={text}>
              <ListItemIcon>
                {index % 2 === 0 ? <InboxIcon /> : <MailIcon />}
              </ListItemIcon>
              <ListItemText primary={text} />
            </ListItem>
          ))}
        </List> */}
      </div>
    </>
  );

  return (
    <div className={classes.root}>
      <CssBaseline />
      <nav className={classes.drawer}>
        {/* The implementation can be swapped with js to avoid SEO duplication of links. */}
        <Hidden smUp implementation="css">
          <Drawer
            container={window.document.body}
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
        <AppBar position="sticky" color="default">
          <Tabs
            onChange={handleItemCallToRouter}
            value={item ? item.index : false}
            variant="scrollable"
            scrollButtons="auto"
            indicatorColor="primary"
            textColor="primary"
          >
            {part.items
              .filter((current) => current != null)
              .map((current) => (
                <Tab
                  key={current.name}
                  label={current.name}
                  icon={<CoursePartItemIcon item={current} />}
                  value={current.index}
                />
              ))}
          </Tabs>
        </AppBar>
        <Paper elevation={3}>
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
          <Box p={4}>
            {item != null && (
              <Paper elevation={3}>
                <Grid container spacing={4} alignItems="stretch">
                  <Grid item lg={4} md={6} sm={12} container direction="column">
                    <Box p={2} className={classes.noOverflow}>
                      <Typography
                        variant="h4"
                        component="h2"
                        className={classes.noOverflow}
                      >
                        {item.name}
                      </Typography>
                      <Typography component="p">{item.description}</Typography>
                    </Box>
                  </Grid>
                  <Grid item lg={8} md={6} sm={12} className={classes.item}>
                    <Box p={2}>
                      <Switch>
                        <Route path={`${path}/:itemId`}>
                          <CoursePartItemRoute part={part} />
                        </Route>
                      </Switch>
                    </Box>
                  </Grid>
                </Grid>
              </Paper>
            )}
          </Box>
        </Paper>
      </main>
    </div>
  );
}
export const CoursePartItemLayoutRouter = withRouter(CoursePartItemLayout);
