import React, { lazy } from 'react';
import './App.css';
import theme from './theme';
import { ThemeProvider } from '@material-ui/core';
import {
  Route,
  HashRouter as Router, Switch
} from 'react-router-dom';
const IndexPage = lazy(() => import('./pages/index'));
const CoursesRoute = lazy(() => import('./pages/courses/route'));
const SettingsPage = lazy(() => import('./pages/settings/home'));
const AddServerPage = lazy(() => import('./pages/settings/add'));


function App() {
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
