import CoursePartItem from "./item";

type VideoSource = "youtube" | "url";
export default class VideoPartItem extends CoursePartItem {
  public readonly url: string;

  public readonly source: VideoSource;

  public constructor(init?: Partial<VideoPartItem>) {
    super(init);
    Object.assign(this, init);
  }
}
