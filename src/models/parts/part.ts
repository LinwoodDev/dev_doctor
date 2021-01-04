import Course from '../course';
export default class CoursePart {
    public readonly course : Course;
    public readonly name : string;
    public readonly slug : string;

    public get server() {
        return this.course.server;
    }
    
    public constructor(init?:Partial<CoursePart>) {
        Object.assign(this, init);
    }
}