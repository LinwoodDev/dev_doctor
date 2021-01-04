import { Box, Button, Container, Paper, Typography } from "@material-ui/core";
import React, { ReactElement } from "react";
import { useTranslation } from "react-i18next";
import { Route, Switch, useRouteMatch } from "react-router-dom";
import { useStyles } from "./header";
import CourseHeader from "./header";
import { CourseProps } from "./route";

export default function CourseMaterialsPage({
  course,
}: CourseProps): ReactElement {
  const classes = useStyles();
  let { path } = useRouteMatch();
  const { t } = useTranslation(["course", "common"]);
  // const part = new CoursePart({course: '', slug: ''});

  return (
    <Switch>
      <Route exact path={path}>
        <CourseHeader course={course} scrollToTab={false} />
        <Container>
        <Paper className={classes.paper}>
          <Box p={1} textAlign="center">
            <Typography>{t("common:coming-soon")}</Typography>
            <Button color="primary" variant="contained">START</Button>
          </Box>
        </Paper>
        </Container>
      </Route>
    </Switch>
  );
}
