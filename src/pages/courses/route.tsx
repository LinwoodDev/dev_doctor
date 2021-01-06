import { CircularProgress } from '@material-ui/core';
import React, { ReactElement, useEffect, useState } from 'react'
import { Route, Switch, useParams, useRouteMatch } from 'react-router-dom';
import CoursesPage from '.';
import Course from '../../models/course'
import CourseHomePage from './home';
import CourseStatsPage from './stats';
import CourseHeader from './header';
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
    
    useEffect(() => {
      if(course == null)
      updateCourse();
    });
    const updateCourse = async () => setCourse(await CoursesServer.getServer(+serverId).fetchCourse(courseId));
    let { path } = useRouteMatch();
    console.log(course);
    return course == null ? <CircularProgress /> :
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
    </Switch>;
}

export interface CourseProps {
    course: Course;
}