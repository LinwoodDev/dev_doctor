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
    const { t } = useTranslation('course');
    
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
    </Switch></div>
    </>;
}

export interface CourseProps {
    course: Course;
}