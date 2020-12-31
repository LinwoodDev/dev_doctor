import React from 'react';
import './App.css';
import theme from './theme';
import { ThemeProvider } from '@material-ui/core';
import IndexPage from './pages/index';
import CoursesPage from './pages/courses';
import {
  Route,
  BrowserRouter as Router, Switch
} from 'react-router-dom';

function App() {
  return (
    <ThemeProvider theme={theme}>
      <Router>
        <Switch>
          <Route path="/courses" component={CoursesPage} />
          <Route path="/" component={IndexPage} />
        </Switch>
      </Router>
    </ThemeProvider>
  );
}

export default App;
