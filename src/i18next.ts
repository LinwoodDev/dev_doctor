import i18next from 'i18next';
import Backend from 'i18next-http-backend';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';

const i18n = i18next
  .use(Backend)
  .use(initReactI18next)
  .use(LanguageDetector)
  .init({
    backend: {
      // for all available options read the backend's repository readme file
      loadPath: '/locales/{{lng}}/{{ns}}.json'
    },
    fallbackLng: ['en', 'de'],
    debug: true,
    supportedLngs: ['en', 'de'],
    ns: ['translation', 'common', 'courses'],

    interpolation: {
      escapeValue: false, // not needed for react as it escapes by default
    }
  });
export default i18n;