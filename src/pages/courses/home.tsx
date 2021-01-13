import { Box, Container, Paper } from "@material-ui/core";
import React, { ReactElement } from "react";
import MyMarkdown from "../../components/markdown";
import { CourseProps, useStyles } from "./header";

export default function CourseHomePage({ course }: CourseProps): ReactElement {
  const classes = useStyles();

  return (
    <Container>
      <Paper className={classes.paper}>
        <Box p={1}>
          <MyMarkdown body={course.body} />
        </Box>
      </Paper>
    </Container>
  );
}
