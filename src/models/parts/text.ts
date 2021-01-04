import CoursePart from "./part";

export default class TextPart extends CoursePart {
    public readonly body : string;

    public constructor(init?:Partial<TextPart>) {
        super(init);
        Object.assign(this, init);
    }
    
}