import React, { Suspense } from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import './i18next';
import reportWebVitals from './reportWebVitals';
import ServiceWorkerWrapper from './serviceWorkerWrapper';
import { SnackbarProvider } from 'notistack';


ReactDOM.render(
  <Suspense fallback="loading">
    <SnackbarProvider maxSnack={3}>
      <App />
    <ServiceWorkerWrapper />
    </SnackbarProvider>
  </Suspense>,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
