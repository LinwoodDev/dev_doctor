import CoursePartItem from "./item";

export default class QuizPartItem extends CoursePartItem {
  public readonly questions: QuizQuestion[];
  public readonly time: number;
  public constructor(init?: Partial<QuizQuestion>) {
    super(init);
    this.questions = init["questions"].map((question) => {
      question["quiz"] = this;
      return new QuizQuestion(question);
    });
  }
}
export class QuizQuestion {
  public readonly quiz: QuizPartItem;
  public readonly title: string;
  public readonly description: string;
  public readonly answers: QuizAnswer[];
  public constructor(init?: Partial<QuizQuestion>) {
    Object.assign(this, init);
    this.answers = (this["answers"] as any[]).map((answer) => {
        answer["question"] = this;
      return new QuizAnswer(answer);
    });
  }
}
export class QuizAnswer {
  public readonly correct: boolean;
  public readonly name: string;
  public readonly description: string;
  public readonly question : QuizQuestion;

  public constructor(init?: Partial<QuizAnswer>) {
    Object.assign(this, init);
  }
}
