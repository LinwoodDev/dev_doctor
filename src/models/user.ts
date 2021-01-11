import CoursesServer from "./server";

export default class User {
    public name : string = '';
    public servers : CoursesServer[];
    public constructor(init : Partial<User>){
        Object.assign(this, init);
        var currentData = this['servers'] as any;
        this.servers = [new CoursesServer({name: 'Dev-Doctor', url: 'https://backend.dev-doctor.cf'})];
        if(currentData != null){
            try{
            var json = JSON.parse(currentData);
            this.servers = json.map((server : Partial<CoursesServer>) => new CoursesServer(server));
            }catch(ignored){

            }
        }
    }

    public save(){
        localStorage.setItem('user', JSON.stringify(this));
    }

    static load(){
        return new User(JSON.parse(localStorage.getItem('user')));
    }
}