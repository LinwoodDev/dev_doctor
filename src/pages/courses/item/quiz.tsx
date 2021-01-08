import { FormControl, FormLabel, RadioGroup, FormControlLabel, Radio, FormHelperText, Button, makeStyles } from '@material-ui/core'
import React, { ReactElement } from 'react'
import QuizPartItem from '../../../models/items/quiz';
import { CoursePartItemProps } from './route';
import { QuizQuestion } from '../../../models/items/quiz';


const useStyles = makeStyles((theme) => ({
    formControl: {
      margin: theme.spacing(3),
    },
    button: {
      margin: theme.spacing(1, 1, 0, 0),
    },
  }));
export default function CourseQuizPage(props: CoursePartItemProps<QuizPartItem>): ReactElement {
    const classes = useStyles();
    const [value, setValue] = React.useState([]);
    const [error, setError] = React.useState([]);
    const [helperText, setHelperText] = React.useState([]);
  
    const handleRadioChange = (event: React.ChangeEvent<HTMLInputElement>, index : number) => {
      var newValue = value;
      newValue[index] = (event.target as HTMLInputElement).value;
      var newHelperText = helperText;
      newHelperText[index] = ' ';
      var newError = error;
      newError[index] = false;
      setValue(newValue);
      setHelperText(newHelperText);
      setError(newError);
    };
  
    const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
      event.preventDefault();
      var newHelperText = helperText;
      var newError = error;
      props.item.questions.forEach((current, index) => {
        if(!current.answers[value[index]]){
          newHelperText[index] = 'Please select an option.';
          newError[index] = true;
        } else if (current.answers[value[index]].correct) {
          newHelperText[index] = 'You got it!';
          newError[index] = false;
        } else {
          newHelperText[index] = 'Sorry, wrong answer!';
          newError[index] = true;
        }
      });
      setError(newError);
      setHelperText(newHelperText);
    };
    console.log(value);
    let questionForm = (question : QuizQuestion, index: number) => (
      <FormControl key={index} component="fieldset" error={error[index]} className={classes.formControl}>
        <FormLabel component="legend">{question.title}</FormLabel>
        {console.log("REBUILD")}
        <RadioGroup aria-label="quiz" name="quiz" value={value[index]} onChange={(event) => handleRadioChange(event, index)}>
          {question.answers.map((answer, answerIndex) =>
            <FormControlLabel key={`${index}-${answerIndex}`} value={String(answerIndex)} control={<Radio />} label={answer.name} />
          )}
        </RadioGroup>
        <FormHelperText>{helperText[index]}</FormHelperText>
      </FormControl>);
  
    return (
        <form onSubmit={handleSubmit}>
        {console.log("FEEFEF")}
          {props.item.questions.map((question, index) => questionForm(question, index))}
        <Button type="submit" variant="outlined" color="primary" className={classes.button}>
          Check Answer
        </Button>
        </form>
    )
}
