import { Paper, Box, Typography, Container } from "@material-ui/core";
import React, { ReactElement } from "react";
import { useTranslation } from "react-i18next";
import { useStyles } from "./header";

export default function CourseStatsPage(): ReactElement {
  const classes = useStyles();
  const { t } = useTranslation(["course", "common"]);

  return (
    <Container>
      <Paper className={classes.paper}>
        <Box p={1}>
          <Typography>{t("common:coming-soon")}</Typography>
        </Box>
      </Paper>
    </Container>
  );
}
