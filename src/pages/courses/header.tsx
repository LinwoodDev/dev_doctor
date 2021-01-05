import { AppBar, Container, Tab, Tabs } from "@material-ui/core";
import React, { useEffect, useRef } from "react";
import { useTranslation } from "react-i18next";
import LanguageOutlinedIcon from "@material-ui/icons/LanguageOutlined";
import { CourseParamTypes, CourseProps } from "./route";
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
} from "@material-ui/core";
import { RouteComponentProps, useParams, withRouter } from "react-router-dom";

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
  const { serverId } = useParams<CourseParamTypes>();
  const { t } = useTranslation(["course", "common"]);
  const tabRef = useRef(null);
  useEffect(() => {
    if (props.scrollToTab) tabRef.current.scrollIntoView();
  });
  const handleCallToRouter = (_event: React.ChangeEvent<{}>, value: any) => {
    props.history.push(value);
  };
  return (
    <Container>
      <Paper className={classes.paper}>
        <Grid container alignItems="stretch">
          <Grid item lg={5} md={7} sm={12}>
            {props.course.icon && (
              <img
                className={classes.img}
                src={`${props.course.server.url}/${props.course.slug}/icon.${props.course.icon}`}
                alt="icon"
              />
            )}
          </Grid>
          <Grid item lg={7} md={5} sm={12} container direction="column">
            <Grid item xs>
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
            <Grid item>
              <Box textAlign="center" p={2}>
                <ButtonGroup variant="text" color="primary">
                  <Button>START</Button>
                  <Button>SUPPORT</Button>
                </ButtonGroup>
              </Box>
            </Grid>
          </Grid>
        </Grid>
      </Paper>
      <AppBar position="sticky" color="inherit" ref={tabRef}>
        <Tabs
          onChange={handleCallToRouter}
          value={props.history.location.pathname}
          variant="fullWidth"
        >
          <Tab label={t("home")} value={`/courses/${serverId}/${props.course.slug}`} />
          <Tab
            label={t("statistics")}
            value={`/courses/${serverId}/${props.course.slug}/stats`}
          />
        </Tabs>
      </AppBar>
    </Container>
  );
}
CourseHeader.defaultProps = {
  scrollToTab: true,
};
export default withRouter(CourseHeader);
