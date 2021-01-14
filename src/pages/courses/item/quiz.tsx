import {
  FormControl,
  FormLabel,
  RadioGroup,
  FormControlLabel,
  Radio,
  FormHelperText,
  Button,
  makeStyles,
  Typography,
} from "@material-ui/core";
import React, { ReactElement, useState } from "react";
import { useTranslation } from "react-i18next";
import QuizPartItem, { QuizQuestion } from "../../../models/items/quiz";
import CoursePartItemProps from "./props";

const useStyles = makeStyles((theme) => ({
  formControl: {
    margin: theme.spacing(3),
    display: "block",
  },
  button: {
    margin: theme.spacing(1, 1, 0, 0),
  },
}));

export function QuizQuestionForm({ question, evaluate }: Props): ReactElement {
  const classes = useStyles();
  const { t } = useTranslation("course");
  const [value, setValue] = React.useState("");
  const [error, setError] = React.useState(false);
  const [helperText, setHelperText] = React.useState<string>(
    t("question.choose")
  );

  const handleRadioChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setValue((event.target as HTMLInputElement).value);
    setHelperText(" ");
    setError(false);
    question.answers[+value].answered = false;
  };
  const evaluateForm = () => {
    let newHelperText: string;
    let newError: boolean;
    if (!question.answers[+value]) {
      newHelperText = t("question.select");
      newError = true;
      return;
    }
    if (question.answers[+value].correct) {
      newHelperText = t("question.correct");
      newError = false;
    } else {
      newHelperText = t("question.wrong");
      newError = true;
    }
    question.answers[+value].answered = true;
    setHelperText(newHelperText);
    setError(newError);
  };
  if (
    evaluate &&
    (!question.answers[+value] ||
      (question.answers[+value] && !question.answers[+value].answered))
  )
    evaluateForm();

  return (
    <FormControl error={error} className={classes.formControl}>
      <FormLabel component="legend">{question.title}</FormLabel>
      <RadioGroup
        aria-label="quiz"
        name="quiz"
        value={value}
        onChange={handleRadioChange}
      >
        {question.answers.map((answer, answerIndex) => (
          <FormControlLabel
            key={`${question.index}-${answer.index}`}
            value={String(answerIndex)}
            control={<Radio />}
            label={answer.name}
          />
        ))}
      </RadioGroup>
      <FormHelperText>{helperText}</FormHelperText>
      {evaluate && <Typography component="p">{question.evaluation}</Typography>}
    </FormControl>
  );
}

export default function CourseQuizPage({
  item,
}: CoursePartItemProps<QuizPartItem>): ReactElement {
  const classes = useStyles();
  const { t } = useTranslation("course");
  const [evaluate, setEvaluate] = useState(false);

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setEvaluate(true);
  };

  return (
    <form onSubmit={handleSubmit}>
      {item.questions.map((question) => (
        <QuizQuestionForm
          question={question}
          evaluate={evaluate}
          key={question.index}
        />
      ))}
      <Button
        type="submit"
        variant="outlined"
        color="primary"
        className={classes.button}
      >
        {t("question.check")}
      </Button>
    </form>
  );
}

interface Props {
  evaluate: boolean;
  question: QuizQuestion;
}
