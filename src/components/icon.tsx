import React, { ReactElement } from "react";
import SubjectOutlinedIcon from "@material-ui/icons/SubjectOutlined";
import InsertDriveFileOutlinedIcon from "@material-ui/icons/InsertDriveFileOutlined";
import PlayCircleOutlineOutlinedIcon from "@material-ui/icons/PlayCircleOutlineOutlined";
import QuestionAnswerOutlinedIcon from "@material-ui/icons/QuestionAnswerOutlined";
import VideoPartItem from "../models/items/video";
import TextPartItem from "../models/items/text";
import CoursePartItem from "../models/items/item";
import QuizPartItem from "../models/items/quiz";
import CoursePartItemProps from "../pages/courses/item/props";

export default function CoursePartItemIcon({
  item,
}: CoursePartItemProps<CoursePartItem>): ReactElement {
  if (item instanceof VideoPartItem) return <PlayCircleOutlineOutlinedIcon />;
  if (item instanceof TextPartItem) return <SubjectOutlinedIcon />;
  if (item instanceof QuizPartItem) return <QuestionAnswerOutlinedIcon />;
  return <InsertDriveFileOutlinedIcon />;
}
