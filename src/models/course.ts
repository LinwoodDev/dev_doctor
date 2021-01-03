import CoursePart from "./part";
import YAML from 'yaml';

export default class Course {
    public readonly slug : string;
    private _name : string;
    private _description : string;
    private _icon : boolean;
    private _author : string;
    private _installed : boolean;
    private _body : string;
    private _lang : string;
    

    constructor({slug, update = false} : {slug: string, update?: boolean}){
        this.slug = slug;
        if(update)
            this.Update();
    }

    public get parts() : Array<CoursePart> {
        return [];
    }

    public get name() : string {return this._name;}
    public get author() : string {return this._author;}
    public get installed() : boolean {return this._installed;}
    public get description() : string {return this._description;}
    public get icon(): boolean {return this._icon;}
    public get body(): string {return this._body;}
    public get lang(): string {return this._lang;}

    async Update() : Promise<void> {
        var response = await fetch(`/assets/courses/${this.slug}/config.yml`);
        var text = await response.text();
        this._installed = await caches.has(`course-${this.slug}`);
        var data = YAML.parse(text);
        console.log(data);
        this._name = data['name'];
        this._description = data['description'];
        this._author = data['author'];
        this._icon = data['icon'];
        this._body = data['body'];
        this._lang = data['lang'];
    }
}