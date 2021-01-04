import React, { ReactElement, useEffect, useState } from "react";
import MyAppBar from "../../components/appbar";
import { useTranslation } from "react-i18next";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";
import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Button,
  Card,
  CardActions,
  CardContent,
  CardMedia,
  Chip,
  CircularProgress,
  Container,
  FormControl,
  Grid,
  Input,
  InputLabel,
  makeStyles,
  MenuItem,
  Paper,
  Select,
  Theme,
  Typography,
  useTheme,
} from "@material-ui/core";
import Course from "../../models/course";
import { Link as RouterLink, useRouteMatch } from "react-router-dom";
import LanguageOutlinedIcon from "@material-ui/icons/LanguageOutlined";
import { ServerProps } from "./route";
import CoursesServer from "../../models/server";

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
    height: "100%",
    display: "flex",
    flexDirection: "column",
  },
  cardMedia: {
    paddingTop: "56.25%", // 16:9
  },
  cardContent: {
    flexGrow: 1,
  },
  heading: {
    fontSize: theme.typography.pxToRem(15),
    fontWeight: theme.typography.fontWeightRegular,
  },
  formControl: {
    margin: theme.spacing(1),
    minWidth: 120,
    maxWidth: 300,
  },
  chips: {
    display: "flex",
    flexWrap: "wrap",
  },
  chip: {
    margin: 2,
  },
  noLabel: {
    marginTop: theme.spacing(3),
  },
  footer: {
    backgroundColor: theme.palette.background.paper,
    padding: theme.spacing(6),
  },
}));

const names = [
  "Oliver Hansen",
  "Van Henry",
  "April Tucker",
  "Ralph Hubbard",
  "Omar Alexander",
  "Carlos Abbott",
  "Miriam Wagner",
  "Bradley Wilkerson",
  "Virginia Andrews",
  "Kelly Snyder",
];
function getStyles(name: string, personName: string[], theme: Theme) {
  return {
    fontWeight:
      personName.indexOf(name) === -1
        ? theme.typography.fontWeightRegular
        : theme.typography.fontWeightMedium,
  };
}

export default function CoursesPage({ server }: ServerProps): ReactElement {
  const classes = useStyles();
  const { t } = useTranslation(["courses", "common"]);
  const servers: CoursesServer[] =
    server == null ? CoursesServer.servers : [server];
  const [courses, setCourses] = useState<Map<string, Course[]>>(null);
  const theme = useTheme();
  let { path } = useRouteMatch();
  useEffect(() => {
    if (!courses) getData();
  });
  const getData = async () => {
    var map = new Map<string, Course[]>();
    for (const server of servers) {
      map.set(server.url, await server.fetchCourses());
    }
    console.log(map);
    setCourses(map);
  };
  const addCourse = (course: string) => {
    if (!courses) setCourses(null);
    caches
      .open(`course-${course}`)
      .then((cache) => cache.add(`assets/courses/${course}/icon.png`))
      .then(getData);
  };
  const removeCourse = (course: string) => {
    if (!courses) setCourses(null);
    caches.delete(`course-${course}`).then(getData);
  };
  const [personName, setPersonName] = React.useState<string[]>([]);

  const handleChange = (event: React.ChangeEvent<{ value: unknown }>) => {
    setPersonName(event.target.value as string[]);
  };
  const ITEM_HEIGHT = 48;
  const ITEM_PADDING_TOP = 8;
  const MenuProps = {
    PaperProps: {
      style: {
        maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
        width: 250,
      },
    },
  };
  const buildView = (url: string, serverCourses: Course[]) => {
    console.log(serverCourses);
    if (servers.length === 1) {
      return buildCoursesView(serverCourses);
    } else {
      return (
        <Accordion>
          <AccordionSummary expandIcon={<ExpandMoreIcon />}>
            <Typography className={classes.heading}>{url}</Typography>
          </AccordionSummary>
          <AccordionDetails>{buildCoursesView(serverCourses)}</AccordionDetails>
        </Accordion>
      );
    }
  };
  const buildCoursesView = (serverCourses: Course[]) => (
    <>
      {serverCourses.map((course) => (
        <Grid item key={course["slug"]} xs={12} sm={6} md={4}>
          <Card className={classes.card}>
            {course["installed"] ? (
              <Button onClick={() => removeCourse(course["slug"])}>
                remove
              </Button>
            ) : (
              <Button onClick={() => addCourse(course["slug"])}>add</Button>
            )}
            {course["icon"] && (
              <CardMedia
                className={classes.cardMedia}
                image={`/assets/courses/${course["slug"]}/icon.png`}
                title="Image title"
              />
            )}
            <CardContent className={classes.cardContent}>
              <Typography gutterBottom variant="h5" component="h2">
                {course["name"]}
              </Typography>
              <Typography color="textSecondary" gutterBottom>
                {course["author"]}
              </Typography>
              <Grid container direction="row" alignItems="center">
                <Grid item>
                  <LanguageOutlinedIcon className={classes.icon} />
                </Grid>
                <Grid item>
                  <Typography variant="body1" component="p">
                    {t("common:language." + course["lang"])}
                  </Typography>
                </Grid>
              </Grid>
              <Typography variant="body2" component="p">
                {course["description"]}
              </Typography>
            </CardContent>
            <CardActions>
              <Button
                component={RouterLink}
                to={`${path}/${course["slug"]}`}
                size="small"
                color="primary"
              >
                View
              </Button>
              <Button size="small" color="primary">
                Edit
              </Button>
            </CardActions>
          </Card>
        </Grid>
      ))}
    </>
  );
  if (courses != null){
    console.log(Array.from(courses.keys()));
    console.log(courses.keys());
  } 
  return (
    <>
      <MyAppBar title={t("title")} />
      <Container className={classes.cardGrid} maxWidth="md">
        <Paper>
          <FormControl className={classes.formControl}>
            <InputLabel id="demo-mutiple-chip-label">Chip</InputLabel>
            <Select
              labelId="demo-mutiple-chip-label"
              id="demo-mutiple-chip"
              multiple
              value={personName}
              onChange={handleChange}
              input={<Input id="select-multiple-chip" />}
              renderValue={(selected) => (
                <div className={classes.chips}>
                  {(selected as string[]).map((value) => (
                    <Chip key={value} label={value} className={classes.chip} />
                  ))}
                </div>
              )}
              MenuProps={MenuProps}
            >
              {names.map((name) => (
                <MenuItem
                  key={name}
                  value={name}
                  style={getStyles(name, personName, theme)}
                >
                  {name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Paper>
        <Grid container spacing={4}>
          {courses == null ? (
            <CircularProgress />
          ) : (
            Array.from(courses.keys()).map((key) =>
              buildView(key as string, courses.get(key))
            )
          )}
        </Grid>
      </Container>
    </>
  );
}
