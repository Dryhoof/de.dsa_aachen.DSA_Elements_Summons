import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import de from './de.json';
import en from './en.json';

const savedLang = localStorage.getItem('dsa-language') ??
  (navigator.language.startsWith('de') ? 'de' : 'en');

i18n
  .use(initReactI18next)
  .init({
    resources: {
      de: { translation: de },
      en: { translation: en },
    },
    lng: savedLang,
    fallbackLng: 'en',
    interpolation: { escapeValue: false },
  });

export default i18n;

export function setLanguage(lang: string) {
  i18n.changeLanguage(lang);
  localStorage.setItem('dsa-language', lang);
}
