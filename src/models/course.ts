export default class Course {
    public readonly slug : string;
    public readonly name : string;
    public readonly author : string;
    

    constructor(slug : string){
        
    }

    public get parts() : Array<CoursePart> {
        return [];
    }
}