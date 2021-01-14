import YAML from "yaml";
import CoursesServer from "./server";
import CoursePart from "./part";

export default class Course {
  public readonly server: CoursesServer;

  public readonly slug: string;

  public readonly name: string;

  public readonly description: string;

  public readonly icon: string;

  public readonly author: string;

  public readonly installed: boolean;

  public readonly body: string;

  public readonly lang: string;

  public constructor(init?: Partial<Course>) {
    Object.assign(this, init);
  }

  public async fetchParts(): Promise<CoursePart[]> {
    const response = await fetch(`${this.server.url}/${this.slug}/config.yml`);
    const text = await response.text();
    const yaml = YAML.parse(text);
    return Promise.all(
      (yaml.parts as Array<string>).map((part, index) =>
        this.fetchPart(part, index)
      )
    );
  }

  public async fetchPart(part: string, index: number): Promise<CoursePart> {
    const response = await fetch(
      `${this.server.url}/${this.slug}/${part}/config.yml`
    );
    const text = await response.text();
    const data = YAML.parse(text);
    data.course = this;
    data.slug = part;
    data.index = index;
    return new CoursePart(data);
  }
}
