import React, { PropsWithChildren } from "react";
import { createStyles, Theme, makeStyles } from "@material-ui/core/styles";
import Drawer from "@material-ui/core/Drawer";
import CssBaseline from "@material-ui/core/CssBaseline";
import Toolbar from "@material-ui/core/Toolbar";
import { CoursePartParamTypes, CoursePartProps } from './route';
import CoursePartItem from "../../../models/items/item";
import {
  Hidden,
  Paper,
  Tab,
  Tabs,
  CircularProgress,
  AppBar,
  Box,
  Typography,
} from "@material-ui/core";
import theme from "../../../theme";
import {
  RouteComponentProps,
  useParams,
  useRouteMatch,
  withRouter,
} from "react-router-dom";
import CoursePartItemIcon from "../../../components/icon";
import CoursePart from "../../../models/part";
import { CourseParamTypes } from "../route";

const drawerWidth = 240;

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      display: "flex",
      height: "100%",
      width: "100%",
    },
    drawer: {
      [theme.breakpoints.up("sm")]: {
        width: drawerWidth,
        flexShrink: 0,
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
    // necessary for content to be below app bar
    toolbar: theme.mixins.toolbar,
    content: {
      flexGrow: 1,
      width: "100%",
      backgroundColor: theme.palette.background.paper,
      overflow: "auto",
    },
  })
);
interface Props
  extends PropsWithChildren<CoursePartProps>,
    RouteComponentProps {
  parts: CoursePart[];
}

export function CoursePartItemLayout({
  part,
  parts,
  children,
  history,
}: Props) {
  const [mobileOpen, setMobileOpen] = React.useState(false);
  let match = useRouteMatch<CoursePartParamTypes>({
    path: `/courses/:serverId/:courseId/start/:partId/:itemId`,
  });

  let item: CoursePartItem = part.items[match?.params?.itemId];

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };
  const handleCallToRouter = (_event: React.ChangeEvent<{}>, value: any) => {
    history.push(value);
  };
  const handlePartCallToRouter = (
    _event: React.ChangeEvent<{}>,
    value: any
  ) => {
    history.push(`/courses/${serverId}/${part.course.slug}/start/${value}`);
  };
  const { serverId } = useParams<CourseParamTypes>();

  const classes = useStyles();
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
            value={part.slug}
          >
            {parts.map((part) => (
              <Tab label={part.name} key={part.slug} value={part.slug} />
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
      <nav className={classes.drawer} aria-label="mailbox folders">
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
            onChange={handleCallToRouter}
            value={history.location.pathname}
            variant="scrollable"
            scrollButtons="auto"
            indicatorColor="primary"
            textColor="primary"
          >
            {part.items
              .filter((current) => current != null)
              .map((current, index) => (
                <Tab
                  key={current.name}
                  label={current.name}
                  icon={<CoursePartItemIcon item={current} />}
                  value={`/courses/${serverId}/${current.part.course.slug}/start/${current.part.slug}/${index}`}
                />
              ))}
          </Tabs>
        </AppBar>
        <Paper>
          <Box p={4}>
            {item != null && (
              <>
                <Typography variant="h3" component="h2">
                  {item.name}
                </Typography>
                {children}
                <Typography component="p">{item.description}</Typography>
              </>
            )}
          </Box>
        </Paper>
      </main>
    </div>
  );
}
export default withRouter(CoursePartItemLayout);
