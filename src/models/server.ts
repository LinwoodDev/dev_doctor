import Course from "./course";
import YAML from "yaml";

export default class CoursesServer {
  public readonly url: string;
  public readonly name : string;

  public constructor(init?: Partial<CoursesServer>) {
    Object.assign(this, init);
  }

  public async fetchCourses(): Promise<Course[]> {
    var response = await fetch(`${this.url}/config.yml`);
    var text = await response.text();
    var yaml = YAML.parse(text);
    return await Promise.all(
      (yaml["courses"] as Array<string>).map((slug) => this.getCourse(slug))
    );
  }
  public async getCourse(slug: string) : Promise<Course> {
    var response = await fetch(`${this.url}/${slug}/config.yml`);
    var text = await response.text();
    var data = YAML.parse(text);
    data['installed'] = await caches.has(`course-${slug}`);
    data['slug'] = slug;
    data['server'] = this;
    return new Course(data);
  }

  static get servers() : CoursesServer[] {
    var currentData = localStorage.getItem('servers');
    var servers = [new CoursesServer({name: 'Programm Chest', url: '/assets/courses'}),new CoursesServer({name: 'FE', url: '/assets/courses'})];
    if(currentData != null){
      servers = JSON.parse(currentData);
    }
    return servers;
  }
  static set servers(value: CoursesServer[]) {
    localStorage.setItem('servers', JSON.stringify(value));
  }
  static getServer(id : number) : CoursesServer {
    return this.servers[id];
  }
}
