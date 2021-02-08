import {
  Button,
  Container,
  Grid,
  IconButton,
  makeStyles,
  Toolbar,
  Typography,
} from "@material-ui/core";
import React, { ReactElement } from "react";
import { Trans, useTranslation } from "react-i18next";
import { Link as RouterLink } from "react-router-dom";
import MyAppBar from "../components/appbar";
import User from "../models/user";
import { ReactComponent as Vercel } from "../powered-by-vercel.svg";

const useStyles = makeStyles((theme) => ({
  heroButtons: {
    marginTop: theme.spacing(8),
  },
  heroContent: {
    backgroundColor: theme.palette.background.paper,
    padding: theme.spacing(12, 0, 6),
  },
}));
const IndexPage = (): ReactElement => {
  const { t } = useTranslation("common");
  const classes = useStyles();
  const user = User.load();
  return (
    <>
      <MyAppBar title="Home" />
      <Toolbar />
      <div className={classes.heroContent}>
        <Container maxWidth="sm">
          <Typography align="center" variant="h2" component="h1">
            {t("title")}
          </Typography>
          <Typography align="center" variant="h5" color="textSecondary">
            {t("subtitle")}
          </Typography>
          {user.name?.trim() && (
            <Typography align="center">
              <Trans t={t} i18nKey="welcome" values={{ name: user.name }} />
            </Typography>
          )}
          <div className={classes.heroButtons}>
            <Grid container spacing={2} justify="center">
              <Grid item>
                <Button
                  component={RouterLink}
                  to="/courses"
                  variant="contained"
                  color="primary"
                >
                  {t("courses")}
                </Button>
              </Grid>
              <Grid item>
                <Button
                  href="https://discord.linwood.tk"
                  variant="outlined"
                  color="primary"
                >
                  {t("discord")}
                </Button>
              </Grid>
              <Grid item>
                <IconButton href="https://vercel.com?utm_source=Linwood&utm_campaign=oss">
                  <Vercel />
                </IconButton>
              </Grid>
            </Grid>
          </div>
        </Container>
      </div>
    </>
  );
};

export default IndexPage;
