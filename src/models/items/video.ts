import CoursePartItem from "./item";
enum VideoType {
    youtube,
    url
}
export default class VideoPartItem extends CoursePartItem {
    public readonly body : string;
    public readonly type : VideoType;

    public constructor(init?:Partial<VideoPartItem>) {
        super(init);
        Object.assign(this, init);
    }
}