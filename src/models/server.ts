import YAML from "yaml";
import Course from "./course";
import User from "./user";

export default class CoursesServer {
  public readonly url: string;

  public readonly icon: string;

  public readonly name: string;

  public readonly support: string;

  public readonly user: User;

  public constructor(init?: Partial<CoursesServer>) {
    Object.assign(this, init);
  }

  public async fetchCourses(): Promise<Course[]> {
    const response = await fetch(`${this.url}/config.yml`);
    const text = await response.text();
    const yaml = YAML.parse(text);
    return Promise.all(
      (yaml.courses as Array<string>).map((slug) => this.fetchCourse(slug))
    );
  }

  public async fetchCourse(slug: string): Promise<Course> {
    const response = await fetch(`${this.url}/${slug}/config.yml`);
    const text = await response.text();
    const data = YAML.parse(text);
    data.installed = await caches.has(`course-${slug}`);
    data.slug = slug;
    data.server = this;
    return new Course(data);
  }
}
