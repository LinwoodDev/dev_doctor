import { Button, Container, Grid, makeStyles, Typography } from '@material-ui/core'
import React from 'react'
import { useTranslation } from "react-i18next";
import MyAppBar from '../components/appbar';


const useStyles = makeStyles((theme) => ({
  heroButtons: {
    marginTop: theme.spacing(8),
  },
  heroContent: {
    backgroundColor: theme.palette.background.paper,
    padding: theme.spacing(8, 0, 6),
  }
}));
const IndexPage = () => {
  const {t} = useTranslation('common');
  const classes = useStyles();
  return (
    <>
    <MyAppBar title="Home" />
    <div className={classes.heroContent}>
      <Container maxWidth="sm">
        <Typography align="center" variant="h2" component="h1">
          {t('title')}
        </Typography>
        <Typography align="center" variant="h5" color="textSecondary">
          {t('subtitle')}
        </Typography>
            <div className={classes.heroButtons}>
              <Grid container spacing={2} justify="center">
                <Grid item>
                  <Button href="/courses" variant="contained" color="primary">
                    {t('courses')}
                  </Button>
                </Grid>
                <Grid item>
                  <Button variant="outlined" color="primary">
                    {t('discord')}
                  </Button>
                </Grid>
              </Grid>
            </div>
      </Container>
      </div>
    </>
  );
};

export default IndexPage

