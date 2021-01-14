import React, { useEffect, useRef } from "react";
import { useTranslation } from "react-i18next";
import LanguageOutlinedIcon from "@material-ui/icons/LanguageOutlined";
import {
  Box,
  createStyles,
  Grid,
  makeStyles,
  Paper,
  Theme,
  Button,
  ButtonGroup,
  Typography,
  Container,
  AppBar,
  Tabs,
  Tab,
} from "@material-ui/core";
import {
  RouteComponentProps,
  useParams,
  withRouter,
  Link as RouterLink,
} from "react-router-dom";
import Course from "../../models/course";

export interface CourseParamTypes {
  serverId: string;
  courseId: string;
}
export interface CourseProps {
  course: Course;
}

export const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      flexGrow: 1,
    },
    paper: {
      marginTop: theme.spacing(4),
      marginBottom: theme.spacing(4),
    },
    icon: {
      marginRight: theme.spacing(2),
    },
    img: {
      margin: "auto",
      display: "block",
      maxWidth: "100%",
      maxHeight: "100%",
    },
  })
);
interface Props extends CourseProps, RouteComponentProps {
  scrollToTab?: boolean;
}

function CourseHeader({ course, scrollToTab, history }: Props) {
  const classes = useStyles();
  const { serverId } = useParams<CourseParamTypes>();
  const { t } = useTranslation(["course", "common"]);
  const tabRef = useRef(null);
  useEffect(() => {
    if (scrollToTab) tabRef.current.scrollIntoView();
  });
  const handleCallToRouter = (_event: React.ChangeEvent, value: string) => {
    history.push(value);
  };
  return (
    <>
      <Container>
        <Paper className={classes.paper}>
          <Grid container alignItems="stretch">
            <Grid item lg={5} md={7} sm={12}>
              {course.icon && (
                <img
                  className={classes.img}
                  src={`${course.server.url}/${course.slug}/icon.${course.icon}`}
                  alt="icon"
                />
              )}
            </Grid>
            <Grid item lg={7} md={5} sm={12} container direction="column">
              <Grid item xs>
                <Box p={1}>
                  <Typography variant="h4" color="primary">
                    {course.name}
                  </Typography>
                  <Typography color="textSecondary" gutterBottom>
                    {course.author}
                  </Typography>
                  <Grid container direction="row" alignItems="center">
                    <Grid item>
                      <LanguageOutlinedIcon className={classes.icon} />
                    </Grid>
                    <Grid item>
                      <Typography variant="body1" component="p">
                        {t(`common:language.${course.lang}`)}
                      </Typography>
                    </Grid>
                  </Grid>
                  <Typography>{course.description}</Typography>
                </Box>
              </Grid>
              <Grid item>
                <Box textAlign="center" p={2}>
                  <ButtonGroup variant="text" color="primary">
                    <Button
                      component={RouterLink}
                      to={`/courses/${serverId}/${course.slug}/start`}
                    >
                      {t("start")}
                    </Button>
                    {course.server.support && (
                      <Button component={RouterLink} to={course.server.support}>
                        {t("support")}
                      </Button>
                    )}
                  </ButtonGroup>
                </Box>
              </Grid>
            </Grid>
          </Grid>
        </Paper>
        <AppBar position="sticky" color="inherit" ref={tabRef}>
          <Tabs
            onChange={handleCallToRouter}
            value={history.location.pathname}
            variant="fullWidth"
          >
            <Tab
              label={t("home")}
              value={`/courses/${serverId}/${course.slug}`}
            />
            <Tab
              label={t("statistics")}
              value={`/courses/${serverId}/${course.slug}/stats`}
            />
          </Tabs>
        </AppBar>
      </Container>
    </>
  );
}
CourseHeader.defaultProps = {
  scrollToTab: true,
};
export default withRouter(CourseHeader);
