import CoursePart from "../../../models/parts/part";
import { CourseProps } from "../route";

export interface CoursePartProps<T extends CoursePart> extends CourseProps {
    part: T;
}
