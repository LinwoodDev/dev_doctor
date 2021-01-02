import { CircularProgress } from '@material-ui/core';
import React, { ReactElement, useEffect, useState } from 'react'
import { Route, Switch, useParams, useRouteMatch } from 'react-router-dom';
import CoursesPage from '.';
import Course from '../../models/course'
import CourseHomePage from './home';

interface ParamTypes {
  courseId : string;
}

export default function CoursesRoute(): ReactElement {
  let { path } = useRouteMatch();  
  return (
      <Switch>
        <Route exact path={path}>
            <CoursesPage />
        </Route>
        <Route path={`${path}/:courseId`}>
            <CourseRoute />
        </Route>
      </Switch>
  )
}
export function CourseRoute(): ReactElement {
    const { courseId } = useParams<ParamTypes>();
    const [course, setCourse] = useState<Course>(null);
    useEffect(() => {
      if(course == null)
      updateCourse();
    });
    const updateCourse = async () => {
      var course = new Course({slug: courseId, update: false});
      await course.Update();
      console.log(course);
      setCourse(course);
    }
    return course == null ? <CircularProgress /> :<CourseHomePage course={course} />
}

export interface CourseProps {
    course: Course;
}