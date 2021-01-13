import CoursePartItem from "../../../models/items/item";

export default interface CoursePartItemProps<T extends CoursePartItem> {
  item: T;
}
