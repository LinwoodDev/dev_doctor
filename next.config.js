const withPWA = require('next-pwa')
const { nextI18NextRewrites } = require('next-i18next/rewrites')

const localeSubpaths = {
  de: 'de',
  en: 'en'
}
module.exports = withPWA({

  rewrites: async () => nextI18NextRewrites(localeSubpaths),
  publicRuntimeConfig: {
    localeSubpaths,
  },
  shallowRender: true,
  pwa: {
        dest: 'public'
    }
})