import React, { lazy, ReactElement } from "react";
import "./App.css";
import { ThemeProvider } from "@material-ui/core";
import { Route, HashRouter as Router, Switch } from "react-router-dom";
import theme from "./theme";

const IndexPage = lazy(() => import("./pages/index"));
const CoursesRoute = lazy(() => import("./pages/courses/route"));
const SettingsPage = lazy(() => import("./pages/settings/route"));
const AddServerPage = lazy(() => import("./pages/settings/add"));

function App(): ReactElement {
  return (
    <ThemeProvider theme={theme}>
      <Router>
        <Switch>
          <Route path="/courses" component={CoursesRoute} />
          <Route exact path="/" component={IndexPage} />
          <Route path="/settings" component={SettingsPage} />
          <Route path="/add" component={AddServerPage} />
        </Switch>
      </Router>
    </ThemeProvider>
  );
}

export default App;
