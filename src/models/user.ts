export default class User {
    public name : string = '';
    public constructor(init : Partial<User>){
        Object.assign(this, init);
    }

    public save(){
        localStorage.setItem('user', JSON.stringify(this));
    }

    static load(){
        return new User(JSON.parse(localStorage.getItem('user')));
    }
}