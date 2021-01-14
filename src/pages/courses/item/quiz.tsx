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
import QuizPartItem from "../../../models/items/quiz";
import { CoursePartItemProps } from "./route";
import { QuizQuestion } from "../../../models/items/quiz";
import { useTranslation } from "react-i18next";

const useStyles = makeStyles((theme) => ({
  formControl: {
    margin: theme.spacing(3),
    display: 'block'
  },
  button: {
    margin: theme.spacing(1, 1, 0, 0),
  },
}));
export default function CourseQuizPage(
  props: CoursePartItemProps<QuizPartItem>
): ReactElement {
  const classes = useStyles();
  const {t} = useTranslation('course');
  const [evaluate, setEvaluate] = useState(false);

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setEvaluate(true);
  };

  return (
    <form onSubmit={handleSubmit}>
      {props.item.questions.map((question, index) => (
        <QuizQuestionForm
          index={index}
          question={question}
          evaluate={evaluate}
          key={index}
        />
      ))}
      <Button
        type="submit"
        variant="outlined"
        color="primary"
        className={classes.button}
      >
        {t('question.check')}
      </Button>
    </form>
  );
}

interface Props {
  evaluate: boolean;
  question: QuizQuestion;
  index: number;
}

export function QuizQuestionForm({
  question,
  index,
  evaluate,
}: Props): ReactElement {
  const classes = useStyles();
  const {t} = useTranslation('course');
  const [value, setValue] = React.useState("");
  const [error, setError] = React.useState(false);
  const [helperText, setHelperText] = React.useState<string>(t('question.choose'));

  const handleRadioChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setValue((event.target as HTMLInputElement).value);
    setHelperText(" ");
    setError(false);
    question.answers[+value].answered = false;
  };
  function evaluateForm() {
    var newHelperText: string;
    var newError: boolean;
    if (!question.answers[+value]) {
      newHelperText = t('question.select');
      newError = true;
      return;
    } else if (question.answers[+value].correct) {
      newHelperText = t('question.correct');
      newError = false;
    } else {
      newHelperText = t('question.wrong');
      newError = true;
    }
    question.answers[+value].answered = true;
    setHelperText(newHelperText);
    setError(newError);
  }
  if (
    evaluate &&
    (!question.answers[+value] ||
      (question.answers[+value] && !question.answers[+value].answered))
  )
    evaluateForm();

  return (
    <FormControl
      error={error}
      className={classes.formControl}
    >
      <FormLabel component="legend">{question.title}</FormLabel>
      <RadioGroup
        aria-label="quiz"
        name="quiz"
        value={value}
        onChange={handleRadioChange}
      >
        {question.answers.map((answer, answerIndex) => (
          <FormControlLabel
            key={`${index}-${answerIndex}`}
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
