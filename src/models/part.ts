import CoursePartItem from "./items/item";

export default class CoursePart {
    public readonly name : string;
    public readonly slug : string;
    public readonly items : CoursePartItem[];

    public constructor(init?:Partial<CoursePart>) {
        Object.assign(this, init);
    }
}