import Course from '../course';
import CoursePart from '../part';

export default class CoursePartItem {
    public readonly course : Course;
    public readonly part : CoursePart;
    public readonly name : string;
    public readonly slug : string;

    public get server() {
        return this.course.server;
    }
    
    public constructor(init?:Partial<CoursePartItem>) {
        Object.assign(this, init);
    }
}