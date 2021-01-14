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
    var response = await fetch(`${this.server.url}/${this.slug}/config.yml`);
    var text = await response.text();
    var yaml = YAML.parse(text);
    return await Promise.all(
      (yaml["parts"] as Array<string>).map((part) => this.fetchPart(part))
    );
  }
  public async fetchPart(part: string): Promise<CoursePart> {
    var response = await fetch(
      `${this.server.url}/${this.slug}/${part}/config.yml`
    );
    var text = await response.text();
    var data = YAML.parse(text);
    data["course"] = this;
    data["slug"] = part;
    return new CoursePart(data);
  }
}
