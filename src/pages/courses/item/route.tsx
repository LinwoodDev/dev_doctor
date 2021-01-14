import { CircularProgress } from "@material-ui/core";
import React, { ReactElement, useEffect } from "react";
import {
  Redirect,
  Route,
  Switch,
  useParams,
  useRouteMatch,
} from "react-router-dom";
import CoursePartItem from "../../../models/items/item";
import TextPartItem from "../../../models/items/text";
import VideoPartItem from "../../../models/items/video";
import CoursePart from "../../../models/part";
import { CourseParamTypes, CourseProps } from "../route";
import CoursePartItemLayout from "./layout";
import CourseTextPage from "./text";
import CourseVideoPage from "./video";
import QuizPartItem from '../../../models/items/quiz';
import CourseQuizPage from "./quiz";

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
          to={`/courses/${serverId}/${courseId}/start/${parts[0].slug}`}
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
  parts
}: CoursePartRouteProps): ReactElement {
  return (
    <CoursePartItemLayout parts={parts} />
  );
}
export interface CoursePartParamTypes extends CourseParamTypes {
  itemId: string;
}
export interface CoursePartProps {
  part: CoursePart;
}
export interface CoursePartItemProps<T extends CoursePartItem> {
  item: T;
}
export function CoursePartItemRoute({ part }: CoursePartProps): ReactElement {
  const { itemId } = useParams<CoursePartParamTypes>();
  const current = part.items[itemId];
  const buildPage = () => {
      if (current instanceof TextPartItem) {
        return <CourseTextPage item={current} />;
      } else if (current instanceof VideoPartItem) {
        return <CourseVideoPage item={current} />;
      } else if (current instanceof QuizPartItem) {
        return <CourseQuizPage item={current} />;
      }
      return <p>Error!</p>;
  }
  return buildPage();
}
