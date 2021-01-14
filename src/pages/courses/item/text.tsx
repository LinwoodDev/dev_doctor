import { Typography } from "@material-ui/core";
import React, { ReactElement } from "react";
import MyMarkdown from "../../../components/markdown";
import TextPartItem from "../../../models/items/text";
import CoursePartItemProps from "./props";

export default function CourseTextPage({
  item,
}: CoursePartItemProps<TextPartItem>): ReactElement {
  return (
    <div>
      <MyMarkdown body={item.text} />
    </div>
  );
}
