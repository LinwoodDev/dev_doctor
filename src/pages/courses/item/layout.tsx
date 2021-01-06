import React, { PropsWithChildren, useEffect, useState } from "react";
import { createStyles, Theme, makeStyles } from "@material-ui/core/styles";
import Drawer from "@material-ui/core/Drawer";
import CssBaseline from "@material-ui/core/CssBaseline";
import Toolbar from "@material-ui/core/Toolbar";
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemText from "@material-ui/core/ListItemText";
import { CoursePartItemProps, CoursePartParamTypes } from "./route";
import CoursePartItem from "../../../models/items/item";
import { Hidden, Paper, Tab, Tabs, CircularProgress } from "@material-ui/core";
import theme from "../../../theme";
import { RouteComponentProps, useParams, withRouter } from "react-router-dom";
import CoursePartItemIcon from "../../../components/icon";
import CoursePart from "../../../models/part";

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
    // necessary for content to be below app bar
    toolbar: theme.mixins.toolbar,
    content: {
      flexGrow: 1,
      padding: theme.spacing(3),
    },
    tabPaper: {
      width: "100%",
    },
  })
);
interface Props
  extends PropsWithChildren<CoursePartItemProps<CoursePartItem>>,
    RouteComponentProps {}

export function CoursePartItemLayout({ item, children, history }: Props) {
  const [mobileOpen, setMobileOpen] = React.useState(false);

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };
  const handleCallToRouter = (_event: React.ChangeEvent<{}>, value: any) => {
    history.push(value);
  };
  const { serverId } = useParams<CoursePartParamTypes>();
  const [parts, setParts] = useState<CoursePart[]>(null);
  const getData = async () => {
    setParts(await item.part.course.fetchParts());
  };
  useEffect(() => {
    if(parts == null)
      getData();
  });

  const classes = useStyles();
  const drawer = (
    <>
      <Toolbar />
      <div className={classes.drawerContainer}>
        {parts == null ? (
          <CircularProgress />
        ) : (
          <List>
            {parts.map((part) => (
              <ListItem button key={part.slug}>
                <ListItemText primary={part.name} secondary={part.description} />
              </ListItem>
            ))}
          </List>
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
        <div className={classes.toolbar} />
        <Paper className={classes.tabPaper}>
          <Tabs
            onChange={handleCallToRouter}
            value={history.location.pathname}
            variant="scrollable"
          >
            {console.log(item)}
            {item.part.items
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
        </Paper>
        {children}
      </main>
    </div>
  );
}
export default withRouter(CoursePartItemLayout);
