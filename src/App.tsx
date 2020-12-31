import React, { Suspense } from 'react';
import './App.css';
import theme from './theme';
import { ThemeProvider } from '@material-ui/core';
import IndexPage from './pages/index';
import { Route, 
    BrowserRouter as Router, Switch } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

function App() {
    const { t, i18n } = useTranslation();
    const changeLanguage = (lng : string) => {
      (i18n as any).changeLanguage(lng);
    }
  return (
    <ThemeProvider theme={theme}>
        <button onClick={() => changeLanguage('de')}>de</button>
        <button onClick={() => changeLanguage('en')}>en</button>
        <Router>
            <Switch>
                <Route path="/" component={IndexPage} />
            </Switch>
        </Router>
    </ThemeProvider>
  );
}

export default App;
