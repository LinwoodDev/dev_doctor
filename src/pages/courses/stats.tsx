import { Paper, Box, Typography } from "@material-ui/core";
import React, { ReactElement } from "react";
import { useTranslation } from "react-i18next";
import { useStyles } from "./header";
import { CourseProps } from "./route";

export default function CourseStatsPage({}: CourseProps): ReactElement {
  const classes = useStyles();
  const { t } = useTranslation(["course", "common"]);

  return (
    <Paper className={classes.paper}>
      <Box p={1}>
        <Typography>{t("common:coming-soon")}</Typography>
      </Box>
    </Paper>
  );
}
