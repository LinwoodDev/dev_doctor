import { CircularProgress, makeStyles, Toolbar } from "@material-ui/core";
import React, { ReactElement, useEffect, useState } from "react";
import { Route, Switch, useParams, useRouteMatch } from "react-router-dom";
import { useTranslation } from "react-i18next";
import CoursesPage from ".";
import Course from "../../models/course";
import CourseHomePage from "./home";
import CourseStatsPage from "./stats";
import CourseHeader from "./header";
import CoursesServer from "../../models/server";
import CoursePartsRoute from "./item/route";
import MyAppBar from "../../components/appbar";


export default function CoursesRoute({ server }: ServerProps): ReactElement {
  const { path } = useRouteMatch();
  return (
    <Switch>
      <Route exact path={path}>
        <CoursesPage server={server} />
      </Route>
      <Route path={`${path}/:serverId/:courseId`}>
        <CourseRoute />
      </Route>
    </Switch>
  );
}
const useStyles = makeStyles(() => ({
  root: {},
}));

export function CourseRoute(): ReactElement {
  const { serverId, courseId } = useParams<CourseParamTypes>();
  const [course, setCourse] = useState<Course>(null);
  const { t } = useTranslation("course");
  const classes = useStyles();

  useEffect(() => {
    if (course == null) updateCourse();
  });
  const updateCourse = async () =>
    setCourse(await CoursesServer.getServer(+serverId).fetchCourse(courseId));
  const { path } = useRouteMatch();
  return course == null ? (
    <CircularProgress />
  ) : (
    <div className={classes.root}>
      <MyAppBar title={t("course")} subtitle={course.slug} />
      <Toolbar />
      <Switch>
        <Route exact path={path}>
          <CourseHeader course={course} scrollToTab={false} />
          <CourseHomePage course={course} />
        </Route>
        <Route path={`${path}/stats`}>
          <CourseHeader course={course} scrollToTab={false} />
          <CourseStatsPage course={course} />
        </Route>
        <Route path={`${path}/start`}>
          <CoursePartsRoute course={course} />
        </Route>
      </Switch>
    </div>
  );
}

