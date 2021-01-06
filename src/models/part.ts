import CoursePartItem from "./items/item";
import Course from "./course";
import TextPartItem from "./items/text";
import VideoPartItem from "./items/video";

export default class CoursePart {
  public readonly name: string;
  public readonly description: string;
  public readonly slug: string;
  public readonly course: Course;
  public readonly items: CoursePartItem[];

  public get server() {
    return this.course.server;
  }

  public constructor(init?: Partial<CoursePart>) {
    Object.assign(this, init);
    this.items = (this["items"] as Array<any>).map((item) => {
      item["part"] = this;
      console.log(item);
      switch ((item["type"] as string)?.toLowerCase()) {
        case "text":
          return new TextPartItem(item);
        case "video":
          return new VideoPartItem(item);
      }
      return null;
    });
  }
}
