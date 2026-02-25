import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import styles from './InstallPage.module.css';

type Platform =
  | 'ios'
  | 'safari-mac'
  | 'firefox'
  | 'chromium' // Chrome/Edge on Android or Desktop
  | 'other';

function detectPlatform(): Platform {
  const ua = navigator.userAgent;
  const isIos = /iPhone|iPad|iPod/.test(ua) && !(window as Window & { MSStream?: unknown }).MSStream;
  const isSafari = /^((?!chrome|android).)*safari/i.test(ua);
  const isMac = /Macintosh/.test(ua);
  const isFirefox = /Firefox/.test(ua);
  const isChromium = /Chrome|Chromium|Edg/.test(ua);

  if (isIos && isSafari) return 'ios';
  if (isMac && isSafari && !isChromium) return 'safari-mac';
  if (isFirefox) return 'firefox';
  if (isChromium) return 'chromium';
  return 'other';
}

interface BeforeInstallPromptEvent extends Event {
  prompt: () => Promise<void>;
  userChoice: Promise<{ outcome: 'accepted' | 'dismissed' }>;
}

export function InstallPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [deferredPrompt, setDeferredPrompt] = useState<BeforeInstallPromptEvent | null>(null);
  const platform = detectPlatform();

  // If already in standalone mode, redirect to home immediately
  useEffect(() => {
    const isStandalone =
      window.matchMedia('(display-mode: standalone)').matches ||
      (navigator as Navigator & { standalone?: boolean }).standalone === true;
    if (isStandalone) {
      navigate('/home', { replace: true });
    }
  }, [navigate]);

  // Capture beforeinstallprompt event (Chrome/Edge)
  useEffect(() => {
    const handler = (e: Event) => {
      e.preventDefault();
      setDeferredPrompt(e as BeforeInstallPromptEvent);
    };
    window.addEventListener('beforeinstallprompt', handler);
    return () => window.removeEventListener('beforeinstallprompt', handler);
  }, []);

  async function handleInstall() {
    if (deferredPrompt) {
      await deferredPrompt.prompt();
      const result = await deferredPrompt.userChoice;
      if (result.outcome === 'accepted') {
        navigate('/home', { replace: true });
      }
      setDeferredPrompt(null);
    }
  }

  function renderInstructions() {
    switch (platform) {
      case 'ios':
        return (
          <div className={styles.instructions}>
            <div className={styles.instrTitle}>{t('installApp')}</div>
            <div className={styles.instrStep}>
              <span className={styles.instrNum}>1</span>
              <span>{t('iosInstallStep1')} ⎙</span>
            </div>
            <div className={styles.instrStep}>
              <span className={styles.instrNum}>2</span>
              <span>{t('iosInstallStep2')}</span>
            </div>
          </div>
        );
      case 'safari-mac':
        return (
          <div className={styles.instructions}>
            <div className={styles.instrTitle}>{t('installApp')}</div>
            <div className={styles.instrStep}>
              <span className={styles.instrNum}>1</span>
              <span>{t('safariMacInstall')}</span>
            </div>
          </div>
        );
      case 'firefox':
        return (
          <div className={styles.instructions}>
            <div className={styles.instrTitle}>{t('installApp')}</div>
            <div className={styles.instrStep}>
              <span className={styles.instrNum}>1</span>
              <span>{t('firefoxInstall')}</span>
            </div>
          </div>
        );
      case 'chromium':
        return (
          <>
            {deferredPrompt && (
              <button className={styles.installBtn} onClick={handleInstall}>
                ⬇ {t('installApp')}
              </button>
            )}
            <div className={styles.instructions}>
              <div className={styles.instrTitle}>{t('installApp')}</div>
              <div className={styles.instrStep}>
                <span className={styles.instrNum}>1</span>
                <span>{t('chromeInstallStep1')}</span>
              </div>
              <div className={styles.instrStep}>
                <span className={styles.instrNum}>2</span>
                <span>{t('chromeInstallStep2')}</span>
              </div>
            </div>
          </>
        );
      default:
        return null;
    }
  }

  return (
    <div className={styles.page}>
      <div className={styles.iconWrap}>
        <img src="/icons/icon-192.png" alt="DSA Elements Summons" />
      </div>

      <div>
        <h1 className={styles.appName}>DSA Elements Summons</h1>
      </div>

      <p className={styles.description}>{t('installDescription')}</p>

      {renderInstructions()}

      <button
        type="button"
        className={styles.continueLnk}
        onClick={() => navigate('/home')}
      >
        {t('continueInBrowser')}
      </button>
    </div>
  );
}
