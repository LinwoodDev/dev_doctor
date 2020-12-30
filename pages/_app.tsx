import { CssBaseline, ThemeProvider } from '@material-ui/core'
import router, { AppProps } from 'next/dist/next-server/lib/router/router'
import Head from 'next/head'
import React from 'react'
import 'typeface-roboto'
import theme from '../src/theme'
import { appWithTranslation } from '../src/next-i18next'
import App from 'next/app'
import { AppContextType } from 'next/dist/next-server/lib/utils'


const MyApp = ({ Component, pageProps }: AppProps) => {
  return (
    <>
      <Head>
        <meta charSet="utf-8" />
        <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
        <meta
          name="viewport"
          content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"
        />
        <meta name="description" content="Description" />
        <meta name="keywords" content="Keywords" />
        <title>Next.js PWA Example</title>

        <link rel="manifest" href="/manifest.json" />
        <link
          href="/icons/favicon-16x16-dunplab-manifest-25130.png"
          rel="icon"
          type="image/png"
          sizes="16x16"
        />
        <link
          href="/icons/favicon-32x32-dunplab-manifest-25130.png"
          rel="icon"
          type="image/png"
          sizes="32x32"
        />
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
        <link rel="apple-touch-icon" href="/apple-icon.png"></link>
        <meta name="theme-color" content="#317EFB" />
      </Head>
  <ThemeProvider theme={theme}>
    <CssBaseline />
      <Component {...pageProps} />
  </ThemeProvider>
    </>
  )
};
MyApp.getInitialProps = async (appContext: AppContextType<router>) => ({ ...await App.getInitialProps(appContext) })

export default appWithTranslation(MyApp);
