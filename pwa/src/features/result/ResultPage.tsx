import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Layout } from '../../components/Layout';
import { lastResult } from '../summoning/SummoningPage';
import { DsaElement, getCounterElement } from '../../core/models/element';
import { SummoningType } from '../../core/models/summoning-type';
import styles from './ResultPage.module.css';

export function ResultPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();

  if (!lastResult) {
    return (
      <Layout title={t('result')} showBack>
        <div style={{ padding: 40, textAlign: 'center', color: 'var(--text-muted)' }}>
          {t('noData')}
        </div>
      </Layout>
    );
  }

  const r = lastResult;

  function elementName(el: DsaElement): string {
    const map: Record<DsaElement, string> = {
      [DsaElement.Fire]: t('fire'),
      [DsaElement.Water]: t('water'),
      [DsaElement.Life]: t('life'),
      [DsaElement.Ice]: t('ice'),
      [DsaElement.Stone]: t('stone'),
      [DsaElement.Air]: t('air'),
    };
    return map[el];
  }

  function typeName(st: SummoningType): string {
    if (st === SummoningType.Servant) return t('elementalServant');
    if (st === SummoningType.Djinn) return t('djinn');
    return t('masterOfElement');
  }

  function modClass(v: number) {
    if (v >= 15) return styles.high;
    if (v >= 8) return styles.medium;
    return styles.low;
  }

  const counter = getCounterElement(r.element);

  return (
    <Layout title={t('result')} showBack>
      <div className={styles.page}>

        {/* Hero */}
        <div className={styles.hero}>
          <div className={styles.heroType}>{typeName(r.summoningType)}</div>
          <div className={styles.heroName}>{elementName(r.element)}</div>
          <div className={styles.heroElement}>{t('element')} {elementName(r.element)}</div>
        </div>

        {/* Modifiers */}
        <div className={styles.modRow}>
          <div className={styles.modCard}>
            <div className={styles.modCardLabel}>{t('summonLabel')}</div>
            <div className={`${styles.modCardValue} ${modClass(r.summonDifficulty)}`}>
              {r.summonDifficulty > 0 ? '+' : ''}{r.summonDifficulty}
            </div>
          </div>
          <div className={styles.modCard}>
            <div className={styles.modCardLabel}>{t('controlLabel')}</div>
            <div className={`${styles.modCardValue} ${modClass(r.controlDifficulty)}`}>
              {r.controlDifficulty > 0 ? '+' : ''}{r.controlDifficulty}
            </div>
          </div>
        </div>

        {/* Personality */}
        <div className={styles.personalityCard}>
          <div className={styles.personalityLabel}>{t('personality')}</div>
          <div className={styles.personalityValue}>{r.personality}</div>
        </div>

        {/* Weak against */}
        <div className={styles.weakCard}>
          <div className={styles.weakLabel}>{t('weakAgainst')}</div>
          <div className={styles.weakValue}>{elementName(counter)}</div>
        </div>

        {/* Info */}
        <div className={styles.infoCard}>
          <div className={styles.infoRow}>
            <span className={styles.infoLabel}>{t('element')}</span>
            <span className={styles.infoValue}>{elementName(r.element)}</span>
          </div>
          <div className={styles.infoRow}>
            <span className={styles.infoLabel}>{t('summonElemental')}</span>
            <span className={styles.infoValue}>{typeName(r.summoningType)}</span>
          </div>
          <div className={styles.infoRow}>
            <span className={styles.infoLabel}>{t('summoningModifier')}</span>
            <span className={styles.infoValue}>{r.summonDifficulty > 0 ? '+' : ''}{r.summonDifficulty}</span>
          </div>
          <div className={styles.infoRow}>
            <span className={styles.infoLabel}>{t('controlTestModifier')}</span>
            <span className={styles.infoValue}>{r.controlDifficulty > 0 ? '+' : ''}{r.controlDifficulty}</span>
          </div>
        </div>

        <button type="button" className={styles.backBtn} onClick={() => navigate(-1)}>
          {t('back')}
        </button>
      </div>
    </Layout>
  );
}
