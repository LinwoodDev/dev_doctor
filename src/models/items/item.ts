import CoursePart from "../part";
import CoursesServer from "../server";
import UniqueObject from "../unique";

export default abstract class CoursePartItem implements UniqueObject {
  public readonly part: CoursePart;

  public readonly name: string;

  public readonly description: string;

  public readonly index: number;

  public get server(): CoursesServer {
    return this.part.server;
  }

  public constructor(init?: Partial<CoursePartItem>) {
    Object.assign(this, init);
  }
}
