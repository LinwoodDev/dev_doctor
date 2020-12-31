import React from 'react';
import './App.css';
import theme from './theme';
import { ThemeProvider } from '@material-ui/core';
import IndexPage from './pages/index';
import {
  Route,
  BrowserRouter as Router, Switch
} from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import MyAppBar from './components/appbar';

function App() {
  return (
    <ThemeProvider theme={theme}>
      <MyAppBar />
      <Router>
        <Switch>
          <Route path="/" component={IndexPage} />
        </Switch>
      </Router>
    </ThemeProvider>
  );
}

export default App;
