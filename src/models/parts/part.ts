export default class CoursePart {
    public readonly course : string;
    public readonly name : string;
    public readonly slug : string;
    
    constructor(course: string, slug: string){
        this.course = course;
        this.slug = slug;
    }
}