import YAML from "yaml";
import CoursesServer from "./server";

export default class User {
  public name = "";

  public urls: string[] = ["https://backend.dev-doctor.cf"];

  public constructor(init: Partial<User>) {
    Object.assign(this, init);
  }

  public fetchServers(): Promise<CoursesServer[]> {
    return Promise.all(this.urls.map((url) => this.fetchServer(url)));
  }

  public async fetchServer(url: string): Promise<CoursesServer> {
    const response = await fetch(`${url}/config.yml`);
    const text = await response.text();
    const data = YAML.parse(text);
    data.user = this;
    data.url = url;
    return new CoursesServer(data);
  }

  public save(): void {
    localStorage.setItem("user", JSON.stringify(this));
  }

  static load(): User {
    return new User(JSON.parse(localStorage.getItem("user")));
  }
}
