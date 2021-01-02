import CoursePart from "../../../models/part";
import { CourseProps } from "../route";

export interface CoursePartProps extends CourseProps {
    part: CoursePart;
}