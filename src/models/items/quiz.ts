import CoursePartItem from "./item";
import UniqueObject from '../unique';

export default class QuizPartItem extends CoursePartItem {
  public readonly questions: QuizQuestion[];

  public readonly time: number;

  public constructor(init?: Partial<QuizPartItem>) {
    super(init);
    this.questions = init['questions'].map((question : any, index) => {
      question['quiz'] = this;
      question['index'] = index;
      return new QuizQuestion(question);
    });
  }
}
export class QuizQuestion implements UniqueObject {
  public readonly quiz: QuizPartItem;

  public readonly title: string;

  public readonly description: string;

  public readonly evaluation: boolean;

  public readonly answers: QuizAnswer[];

  public readonly index : number;

  public constructor(init?: Partial<QuizQuestion>) {
    Object.assign(this, init);
    this.answers = (this.answers as any[]).map((answer, index) => {
      answer.question = this;
      answer.index = index;
      return new QuizAnswer(answer);
    });
  }

  public calculatePoints() {
    let points = 0;
    this.answers.forEach(
      (answer) =>
        (points += answer.answered && answer.correct ? answer.points : 0)
    );
    return points;
  }
}
export class QuizAnswer implements UniqueObject {
  public readonly index : number;

  public readonly correct: boolean;

  public readonly name: string;

  public readonly description: string;

  public readonly question: QuizQuestion;

  public readonly points: number;

  public answered: boolean;

  public constructor(init?: Partial<QuizAnswer>) {
    Object.assign(this, init);
    this.answered = false;
  }
}
