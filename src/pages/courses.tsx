import React, { ReactElement, useEffect, useState } from 'react'
import MyAppBar from '../components/appbar';
import { useTranslation } from 'react-i18next';
import { Button, Card, CardActions, CardContent, CardMedia, CircularProgress, Container, Grid, makeStyles, Typography } from '@material-ui/core';
import YAML from 'yaml'

const useStyles = makeStyles((theme) => ({
    icon: {
      marginRight: theme.spacing(2),
    },
    heroContent: {
      backgroundColor: theme.palette.background.paper,
      padding: theme.spacing(8, 0, 6),
    },
    heroButtons: {
      marginTop: theme.spacing(4),
    },
    cardGrid: {
      paddingTop: theme.spacing(8),
      paddingBottom: theme.spacing(8),
    },
    card: {
      height: '100%',
      display: 'flex',
      flexDirection: 'column',
    },
    cardMedia: {
      paddingTop: '56.25%', // 16:9
    },
    cardContent: {
      flexGrow: 1,
    },
    footer: {
      backgroundColor: theme.palette.background.paper,
      padding: theme.spacing(6),
    },
  }));

export default function CoursesPage(): ReactElement {
    const classes = useStyles();
    const {t} = useTranslation('courses');

  const [courses, setCourses] = useState(null);
  const getData=()=>{
    fetch('/assets/courses/config.yml')
      .then((response) => response.text())
      .then(function(text) {
        var yaml = YAML.parse(text);
        
        var newCourses = courses ?? [];
        (yaml['courses'] as Array<Array<any>>).forEach(course => {
          fetch(`/assets/courses/${course}/config.yml`).then((response) => response.text()).then(function(response){
            var data = YAML.parse(response);
            newCourses.push({
              name: data['name'],
              description: data['description'],
              author: data['author'],
              icon: data['icon'],
              slug: course
            });
            setCourses([...newCourses]);
          });
        });
      });
  }
  useEffect(()=>{
    if(!courses)
      getData()
  })
  return (
        <>
          <MyAppBar title={t('title')} />
        <Container className={classes.cardGrid} maxWidth="md">
          {/* End hero unit */}
          <Grid container spacing={4}>
            {courses == null ? <CircularProgress /> : courses.map((course) => 
              <Grid item key={course['slug']} xs={12} sm={6} md={4}>
                <Card className={classes.card}>
                  <Button onClick={() => navigator.serviceWorker.controller.postMessage({type: 'ADD', course: course['slug']})}>add</Button>
                  <Button onClick={() => navigator.serviceWorker.controller.postMessage({type: 'REMOVE', course: course['slug']})}>remove</Button>
                  {course['icon'] &&
                    <CardMedia
                      className={classes.cardMedia}
                      image={`/assets/courses/${course['slug']}/icon.png`}
                      title="Image title"
                    />
                  }
                  <CardContent className={classes.cardContent}>
                    <Typography gutterBottom variant="h5" component="h2">
                      {course['name']}
                    </Typography>
                    <Typography color="textSecondary" gutterBottom>
                      {course['author']}
                    </Typography>
                    <Typography variant="body2" component="p">
                      {course['description']}
                    </Typography>
                  </CardContent>
                  <CardActions>
                    <Button size="small" color="primary">
                      View
                    </Button>
                    <Button size="small" color="primary">
                      Edit
                    </Button>
                  </CardActions>
                </Card>
              </Grid>
            )}
          </Grid>
        </Container>
        </>
    )
}
