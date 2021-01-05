import { CircularProgress } from '@material-ui/core';
import React, { ReactElement, useEffect, useState } from 'react'
import { Route, Switch, useParams, useRouteMatch } from 'react-router-dom';
import CoursesPage from '.';
import MyAppBar from '../../components/appbar';
import Course from '../../models/course'
import CourseHomePage from './home';
import CourseStatsPage from './stats';
import CourseHeader from './header';
import { useTranslation } from 'react-i18next';
import CoursesServer from '../../models/server';
import CoursePartsRoute from './item/route';

export interface CourseParamTypes {
  serverId : string;
  courseId : string;
}
export interface ServerProps {
  server : CoursesServer;
}

export default function CoursesRoute({server} : ServerProps): ReactElement {
  let { path } = useRouteMatch();  
  return (
      <Switch>
        <Route exact path={path}>
            <CoursesPage server={server} />
        </Route>
        <Route path={`${path}/:serverId/:courseId`}>
            <CourseRoute />
        </Route>
      </Switch>
  )
}

export function CourseRoute(): ReactElement {
    const { serverId, courseId } = useParams<CourseParamTypes>();
    const [course, setCourse] = useState<Course>(null);
    const { t } = useTranslation('course');
    
    useEffect(() => {
      if(course == null)
      updateCourse();
    });
    const updateCourse = async () => setCourse(await CoursesServer.getServer(+serverId).getCourse(courseId));
    let { path } = useRouteMatch();
    return course == null ? <CircularProgress /> :
    <>
    <MyAppBar title={t("course")} subtitle={course.slug} />
    <div>
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
    </Switch></div>
    </>;
}

export interface CourseProps {
    course: Course;
}