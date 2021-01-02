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
        
        var newCourses = [];
        Promise.all((yaml['courses'] as Array<Array<any>>).map(course => 
          fetch(`/assets/courses/${course}/config.yml`).then((response) => response.text()).then(async function(response){
            var data = YAML.parse(response);
            var installed = await caches.has(`course-${course}`);
            var courseItem = {
              name: data['name'],
              description: data['description'],
              author: data['author'],
              icon: data['icon'],
              installed: installed,
              slug: course
            };
            newCourses.push(courseItem);
            console.log(courseItem);
          })
        )).then(() => setCourses(newCourses)
        );
      });
  }
  useEffect(()=>{
    if(!courses)
      getData()
  })
  const addCourse = (course : string) => {
    if(!courses)
      setCourses(null);
    caches.open(`course-${course}`).then((cache) => cache.add(`assets/courses/${course}/icon.png`)).then(getData);
  }
  const removeCourse = (course : string) => {
    if(!courses)
      setCourses(null);
    caches.delete(`course-${course}`).then(getData);
  }
  return (
        <>
          <MyAppBar title={t('title')} />
        <Container className={classes.cardGrid} maxWidth="md">
          {/* End hero unit */}
          <Grid container spacing={4}>
            {courses == null ? <CircularProgress /> : courses.map((course) =>
              <Grid item key={course['slug']} xs={12} sm={6} md={4}>
                <Card className={classes.card}>
                  {course['installed'] ? <Button onClick={() => removeCourse(course['slug'])}>remove</Button> :<Button onClick={() => addCourse(course['slug'])}>add</Button>}
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
