import CoursePartItem from "./item";

export default class TextPartItem extends CoursePartItem {
    public readonly body : string;

    public constructor(init?:Partial<TextPartItem>) {
        super(init);
        Object.assign(this, init);
    }
}