import React, { ReactElement, useEffect, useState } from "react";
import LanguageOutlinedIcon from "@material-ui/icons/LanguageOutlined";
import { useTranslation } from "react-i18next";
import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Card,
  CardActionArea,
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
import { Link as RouterLink, useRouteMatch } from "react-router-dom";
import Course from "../../models/course";
import MyAppBar from "../../components/appbar";
import CoursesServer from "../../models/server";
import User from "../../models/user";

export interface ServerProps {
  server: CoursesServer;
}
const useStyles = makeStyles((theme) => ({
  icon: {
    marginRight: theme.spacing(2),
  },
  action: {
    height: "100%",
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
  item: {
    margin: theme.spacing(2),
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
  header: {
    marginBottom: theme.spacing(6),
  },
  chip: {
    margin: 2,
  },
  accordion: {
    width: "100%",
  },
  noLabel: {
    marginTop: theme.spacing(3),
  },
  footer: {
    backgroundColor: theme.palette.background.paper,
    padding: theme.spacing(6),
  },
}));
function getStyles(
  server: CoursesServer,
  servers: CoursesServer[],
  theme: Theme
) {
  return {
    fontWeight:
      servers.indexOf(server) === -1
        ? theme.typography.fontWeightRegular
        : theme.typography.fontWeightMedium,
  };
}

export default function CoursesPage({ server }: ServerProps): ReactElement {
  const classes = useStyles();
  const { t } = useTranslation(["courses", "common"]);
  const [servers, setServers] = React.useState<CoursesServer[]>(null);
  const [courses, setCourses] = useState<Map<CoursesServer, Course[]>>(null);
  const theme = useTheme();
  const user = User.load();
  const { path } = useRouteMatch();
  const getData = async () => {
    const data = await user.fetchServers();
    setServers(server == null ? data : [server]);
    const map = new Map<CoursesServer, Course[]>();
    console.log(servers);
    await Promise.all(
      data.map(async (current) => {
        map.set(current, await current.fetchCourses());
      })
    );
    setCourses(map);
    setCurrentServers(data);
  };
  useEffect(() => {
    if (!courses) getData();
  });
  const [expanded, setExpanded] = React.useState<string | false>(false);
  // const addCourse = (course: string) => {
  //   if (!courses) setCourses(null);
  //   caches
  //     .open(`course-${course}`)
  //     .then((cache) => cache.add(`assets/courses/${course}/icon.png`))
  //     .then(getData);
  // };
  // const removeCourse = (course: string) => {
  //   if (!courses) setCourses(null);
  //   caches.delete(`course-${course}`).then(getData);
  // };
  const [currentServers, setCurrentServers] = React.useState<CoursesServer[]>(
    servers
  );

  const handleChange = async (event: React.ChangeEvent<{ value: unknown }>) => {
    setCurrentServers(
      servers.filter((current) =>
        (event.target.value as string[]).includes(current.url)
      )
    );
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
  const handleExpandChange = (panel: string) => {
    setExpanded(panel);
  };
  const buildCoursesView = (
    currentServer: CoursesServer,
    serverCourses: Course[]
  ) => (
    <Grid container>
      {serverCourses.map((course: Course) => (
        <Grid
          item
          className={classes.item}
          key={`${course.server.url}/${course.slug}`}
          xs={12}
          sm={6}
          md={4}
        >
          <Card className={classes.card}>
            {/* {course["installed"] ? (
              <Button onClick={() => removeCourse(course["slug"])}>
                remove
              </Button>
            ) : (
              <Button onClick={() => addCourse(course["slug"])}>add</Button>
            )} */}

            <CardActionArea
              className={classes.action}
              component={RouterLink}
              to={`${path}/${Array.from(courses.keys()).indexOf(
                currentServer
              )}/${course.slug}`}
            >
              {course.icon && (
                <CardMedia
                  className={classes.cardMedia}
                  image={`${course.server.url}/${course.slug}/icon.${course.icon}`}
                  title="Image title"
                />
              )}
              <CardContent className={classes.cardContent}>
                <Typography gutterBottom variant="h5" component="h2">
                  {course.name}
                </Typography>
                <Typography color="textSecondary" gutterBottom>
                  {course.author}
                </Typography>
                <Grid container direction="row" alignItems="center">
                  <Grid item>
                    <LanguageOutlinedIcon className={classes.icon} />
                  </Grid>
                  <Grid item>
                    <Typography variant="body1" component="p">
                      {t(`common:language.${course.lang}`)}
                    </Typography>
                  </Grid>
                </Grid>
                <Typography variant="body2" component="p">
                  {course.description}
                </Typography>
              </CardContent>
            </CardActionArea>
          </Card>
        </Grid>
      ))}
    </Grid>
  );

  const buildView = (currentServer: CoursesServer, serverCourses: Course[]) => {
    if (currentServers.length === 1) {
      return (
        <React.Fragment key={currentServer.url}>
          {buildCoursesView(currentServer, serverCourses)}
        </React.Fragment>
      );
    }
    if (currentServers.length === 0) {
      return null;
    }
    return (
      <Accordion
        key={currentServer.url}
        className={classes.accordion}
        expanded={expanded === currentServer.url}
        onChange={() => handleExpandChange(currentServer.url)}
      >
        <AccordionSummary>
          <Typography className={classes.heading}>
            {currentServer.name}
          </Typography>
        </AccordionSummary>
        <AccordionDetails>
          <div>{buildCoursesView(currentServer, serverCourses)}</div>
        </AccordionDetails>
      </Accordion>
    );
  };
  return currentServers == null ? (
    <CircularProgress />
  ) : (
    <>
      <MyAppBar title={t("title")} />
      <Container className={classes.cardGrid} maxWidth="md">
        <Paper className={classes.header}>
          <FormControl className={classes.formControl}>
            <InputLabel id="demo-mutiple-chip-label">{t("servers")}</InputLabel>
            <Select
              labelId="demo-mutiple-chip-label"
              id="demo-mutiple-chip"
              multiple
              value={currentServers.map((current) => current.url)}
              onChange={handleChange}
              input={<Input />}
              renderValue={(selected) => (
                <div className={classes.chips}>
                  {(selected as string[]).map((value) => (
                    <Chip
                      key={value}
                      label={
                        currentServers.filter((current) =>
                          current.url.includes(value)
                        )[0].name
                      }
                      className={classes.chip}
                    />
                  ))}
                </div>
              )}
              MenuProps={MenuProps}
            >
              {servers.map((current) => (
                <MenuItem
                  key={current.url}
                  value={current.url}
                  style={getStyles(current, currentServers, theme)}
                >
                  {current.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Paper>
        <Grid container spacing={4}>
          {courses == null ? (
            <CircularProgress />
          ) : (
            Array.from(courses.keys())
              .filter((key) =>
                currentServers.map((current) => current.url).includes(key.url)
              )
              .map((key) => buildView(key, courses.get(key)))
          )}
        </Grid>
      </Container>
    </>
  );
}
