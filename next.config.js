const withPWA = require('next-pwa')
const nextTranslate = require('next-translate')
module.exports = withPWA(nextTranslate({
  pwa: {
        dest: 'public'
    }
}))