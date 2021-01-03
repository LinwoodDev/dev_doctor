import { CircularProgress, Container } from '@material-ui/core';
import React, { ReactElement, useEffect, useState } from 'react'
import { Route, Switch, useParams, useRouteMatch } from 'react-router-dom';
import CoursesPage from '.';
import MyAppBar from '../../components/appbar';
import Course from '../../models/course'
import CourseHomePage from './home';
import CourseStatsPage from './stats';
import CourseHeader from './header';
import { useTranslation } from 'react-i18next';
import CourseMaterialsPage from './materials';

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
    <Container>
      <Container maxWidth="lg">
        <CourseHeader course={course} scrollToTab={false} />
        <Switch>
      <Route exact path={path}>
        <CourseHomePage course={course} />
      </Route>
      <Route path={`${path}/stats`}>
        <CourseStatsPage course={course} />
      </Route>
      <Route path={`${path}/materials`}>
        <CourseMaterialsPage course={course} />
      </Route>
    </Switch></Container></Container>
    </>;
}

export interface CourseProps {
    course: Course;
}