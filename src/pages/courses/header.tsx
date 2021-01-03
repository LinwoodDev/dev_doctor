import { AppBar, Tab, Tabs } from "@material-ui/core";
import React, { useEffect, useRef } from "react";
import { useTranslation } from "react-i18next";
import LanguageOutlinedIcon from "@material-ui/icons/LanguageOutlined";
import { CourseProps } from "./route";
import {
  Box,
  createStyles,
  Grid,
  makeStyles,
  Paper,
  Theme,
  Typography,
} from "@material-ui/core";
import {RouteComponentProps, withRouter} from 'react-router-dom';

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

function CourseHeader(props: Props) {
  const classes = useStyles();
  const { t } = useTranslation(["course", "common"]);
  const tabRef = useRef(null);
  useEffect(() => {
    if(props.scrollToTab)
      tabRef.current.scrollIntoView()
  });
  const handleCallToRouter = (event: React.ChangeEvent<{}>, value: any) => {
    console.log(value);
    props.history.push(value);
  }
  return (
    <>
      <Paper className={classes.paper}>
        <Grid container alignItems="stretch">
          <Grid item lg={5} md={7} sm={12}>
            {props.course.icon && (
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
                {props.course.name}
              </Typography>
              <Typography color="textSecondary" gutterBottom>
                {props.course["author"]}
              </Typography>
              <Grid container direction="row" alignItems="center">
                <Grid item>
                  <LanguageOutlinedIcon className={classes.icon} />
                </Grid>
                <Grid item>
                  <Typography variant="body1" component="p">
                    {t("common:language." + props.course["lang"])}
                  </Typography>
                </Grid>
              </Grid>
              <Typography>{props.course.description}</Typography>
            </Box>
          </Grid>
        </Grid>
      </Paper>
      <AppBar position="sticky" color="inherit" ref={tabRef}>
        <Tabs
        onChange={handleCallToRouter}
        value={props.history.location.pathname} centered>
          <Tab label={t("home")} value={`/courses/${props.course.slug}`} />
          <Tab label={t("statistics")} value={`/courses/${props.course.slug}/stats`} />
          <Tab label={t("materials")} value={`/courses/${props.course.slug}/materials`} />
        </Tabs>
      </AppBar>
    </>
  );
}
CourseHeader.defaultProps = {
  scrollToTab: true
};
export default withRouter(CourseHeader);
