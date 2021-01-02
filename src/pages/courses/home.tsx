import {
  AppBar,
  Box,
  Container,
  createStyles,
  Grid,
  makeStyles,
  Paper,
  Tab,
  Tabs,
  Theme,
  Typography,
} from "@material-ui/core";
import React, { ReactElement } from "react";
import MyAppBar from "../../components/appbar";
import { CourseProps } from "./route";
import MyMarkdown from "../../components/markdown";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      flexGrow: 1,
    },
    paper: {
      marginTop: theme.spacing(4),
      marginBottom: theme.spacing(4),
    },
    img: {
      margin: "auto",
      display: "block",
      maxWidth: "100%",
      maxHeight: "100%",
    },
  })
);
export default function CourseHomePage({ course }: CourseProps): ReactElement {
  const classes = useStyles();
  return (
    <div>
      <MyAppBar title="Course" subtitle={course.slug} />
      <AppBar position="sticky" color="inherit">
        <Tabs value={0} 
    centered>
          <Tab label="HOME" />
          <Tab label="STATISTICS" />
          <Tab label="COURSE" />
        </Tabs>
      </AppBar>
      <Container>
        <Container maxWidth="lg">
          <Paper className={classes.paper}>
            <Grid container alignItems="stretch">
              <Grid item lg={5} md={7} sm={12}>
                {course.icon && (
                  <img
                    className={classes.img}
                    src="/assets/courses/example/icon.png"
                    alt="icon"
                  />
                )}
              </Grid>
              <Grid item lg={7} md={5} sm={12}>
                <Box p={1}>
                  <Typography variant="h4" color="primary">
                    {course.name}
                  </Typography>
                  <Typography>{course.description}</Typography>
                </Box>
              </Grid>
            </Grid>
          </Paper>
          <Paper className={classes.paper}>
            <Box p={1}>
              <MyMarkdown body={course.body} />
            </Box>
          </Paper>
        </Container>
      </Container>
    </div>
  );
}
