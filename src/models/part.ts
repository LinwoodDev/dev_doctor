import CoursePartItem from "./items/item";
import Course from "./course";
import TextPartItem from "./items/text";
import VideoPartItem from "./items/video";
import QuizPartItem from "./items/quiz";
import CoursesServer from "./server";

export default class CoursePart {
  public readonly name: string;

  public readonly description: string;

  public readonly slug: string;

  public readonly course: Course;

  public readonly items: CoursePartItem[];

  public get server(): CoursesServer {
    return this.course.server;
  }

  public constructor(init?: Partial<CoursePart>) {
    Object.assign(this, init);
    this.items = (this.items as any[]).map((item, index) => {
      item.part = this;
      item.index = index;
      switch ((item.type as string)?.toLowerCase()) {
        case "text":
          return new TextPartItem(item);
        case "video":
          return new VideoPartItem(item);
        case "quiz":
          return new QuizPartItem(item);
        default:
          return null;
      }
    });
  }
}
