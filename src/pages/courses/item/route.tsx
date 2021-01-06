import { CircularProgress } from "@material-ui/core";
import React, { ReactElement, useEffect } from "react";
import {
  Redirect,
  Route,
  Switch,
  useParams,
  useRouteMatch,
} from "react-router-dom";
import TextPartItem from "../../../models/items/text";
import VideoPartItem from "../../../models/items/video";
import CoursePart from "../../../models/part";
import { CourseParamTypes, CourseProps } from "../route";
import CourseTextPage from "./text";
import CourseVideoPage from "./video";

export default function CoursePartsRoute({
  course,
}: CourseProps): ReactElement {
  let { path } = useRouteMatch();
  const { serverId, courseId } = useParams<CourseParamTypes>();
  const [parts, setParts] = React.useState<CoursePart[]>(null);
  useEffect(() => {
    if (parts == null) getData();
  });
  const getData = async () => {
    setParts(await course.fetchParts());
  };
  return parts == null ? (
    <CircularProgress />
  ) : (
    <Switch>
      <Route path={path} exact>
        <Redirect
          to={`/courses/${serverId}/${courseId}/start/${parts[0].slug}/`}
        />
      </Route>
      <Route path={`${path}/:partId`}>
        <CoursePartRoute course={course} parts={parts} />
      </Route>
    </Switch>
  );
}
export interface CoursePartParamTypes extends CourseParamTypes {
  partId: string;
}
export interface CoursePartRouteProps extends CourseProps {
  parts: CoursePart[];
}
export function CoursePartRoute({
  course,
  parts,
}: CoursePartRouteProps): ReactElement {
  const { serverId, courseId, partId } = useParams<CoursePartParamTypes>();
  let { path } = useRouteMatch();
  const part = parts[partId];
  console.log(course);
  console.log(parts);
  return (
    <Switch>
      <Route path={path} exact>
          {console.log("REDIRECT")}
        <Redirect to={`/courses/${serverId}/${courseId}/start/${partId}/0/`} />
      </Route>
      <Route path={`${path}/:itemId`}>
        <CoursePartItemRoute course={course} part={part} />
      </Route>
    </Switch>
  );
}
export interface CoursePartParamTypes extends CourseParamTypes {
  itemId: string;
}
export interface CoursePartProps extends CourseProps {
  part: CoursePart;
}
export interface CoursePartItemProps extends CoursePartProps {
  item: number;
}
export function CoursePartItemRoute({
  course,
  part,
}: CoursePartProps): ReactElement {
  const { itemId } = useParams<CoursePartParamTypes>();
  const current = part.items[itemId];
  if (current instanceof TextPartItem) {
    return <CourseTextPage course={course} part={part} item={+itemId} />;
  } else if (current instanceof VideoPartItem) {
    return <CourseVideoPage course={course} part={part} item={+itemId} />;
  }
}
