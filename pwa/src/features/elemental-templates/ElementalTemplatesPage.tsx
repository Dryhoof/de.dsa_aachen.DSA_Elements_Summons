import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Layout } from '../../components/Layout';
import { useToast } from '../../components/Toast';
import {
  getTemplatesForCharacter, deleteTemplate, getCharacterById,
  getHiddenPredefinedIds, hidePredefined, unhidePredefined,
} from '../../core/db/database';
import { ElementalTemplate } from '../../core/models/elemental-template';
import { predefinedSummonings, getPredefinedName } from '../../core/constants/predefined-summonings';
import { DsaElement } from '../../core/models/element';
import { SummoningType } from '../../core/models/summoning-type';
import styles from './ElementalTemplates.module.css';

const ELEMENT_ICONS: Record<DsaElement, string> = {
  [DsaElement.Fire]: '🔥',
  [DsaElement.Water]: '💧',
  [DsaElement.Life]: '🌿',
  [DsaElement.Ice]: '❄️',
  [DsaElement.Stone]: '🪨',
  [DsaElement.Air]: '💨',
};

export function ElementalTemplatesPage() {
  const { id } = useParams<{ id: string }>();
  const characterId = Number(id);
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();
  const { showToast } = useToast();

  const [templates, setTemplates] = useState<ElementalTemplate[]>([]);
  const [hiddenIds, setHiddenIds] = useState<string[]>([]);
  const [showHidden, setShowHidden] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState<ElementalTemplate | null>(null);
  const [charName, setCharName] = useState('');

  const locale = i18n.language.startsWith('de') ? 'de' : 'en';

  function load() {
    getTemplatesForCharacter(characterId).then(setTemplates);
    getHiddenPredefinedIds(characterId).then(setHiddenIds);
  }

  useEffect(() => {
    load();
    getCharacterById(characterId).then(c => { if (c) setCharName(c.characterName); });
  }, [characterId]); // eslint-disable-line react-hooks/exhaustive-deps

  async function handleDeleteTemplate(tmpl: ElementalTemplate) {
    if (!tmpl.id) return;
    await deleteTemplate(tmpl.id);
    load();
    setDeleteTarget(null);
    showToast(t('templateDeleted'));
  }

  async function handleToggleHide(predefinedId: string) {
    if (hiddenIds.includes(predefinedId)) {
      await unhidePredefined(characterId, predefinedId);
    } else {
      await hidePredefined(characterId, predefinedId);
    }
    load();
  }

  const visiblePredefined = predefinedSummonings.filter(p => !hiddenIds.includes(p.id));
  const hiddenPredefined = predefinedSummonings.filter(p => hiddenIds.includes(p.id));

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

  return (
    <Layout
      title={`${charName} – ${t('elementalTemplates')}`}
      showBack
      actions={
        <button
          type="button"
          style={{
            background: 'none', border: '1px solid var(--border)',
            borderRadius: 'var(--radius-sm)', padding: '6px 10px',
            color: 'var(--text-secondary)', cursor: 'pointer', fontSize: 12
          }}
          onClick={() => setShowHidden(v => !v)}
        >
          {showHidden ? t('hideHidden') : t('managePredefined')}
        </button>
      }
    >
      <div className={styles.page}>

        {/* User templates */}
        <div className={styles.sectionTitle}>{t('elementalTemplates')}</div>
        {templates.length === 0 ? (
          <div className={styles.emptyState}>
            <span>📋</span>
            <span>{t('noTemplates')}</span>
          </div>
        ) : (
          templates.map(tmpl => (
            <div key={tmpl.id} className={styles.templateCard}>
              <div className={styles.templateIcon}>
                {ELEMENT_ICONS[tmpl.element as DsaElement] ?? '⚗️'}
              </div>
              <div className={styles.templateInfo}>
                <div className={styles.templateName}>{tmpl.templateName}</div>
                <div className={styles.templateMeta}>
                  {elementName(tmpl.element as DsaElement)} · {typeName(tmpl.summoningType as SummoningType)}
                </div>
              </div>
              <div className={styles.templateActions}>
                <button type="button" className={styles.iconBtn}
                  title={t('summon')}
                  onClick={() => navigate(`/summon/${characterId}?templateId=${tmpl.id}`)}>
                  ⚡
                </button>
                <button type="button" className={styles.iconBtn}
                  title={t('edit')}
                  onClick={() => navigate(`/character/${characterId}/elementals/${tmpl.id}`)}>
                  ✏️
                </button>
                <button type="button" className={`${styles.iconBtn} ${styles.iconBtnDanger}`}
                  title={t('deleteTemplate')}
                  onClick={() => setDeleteTarget(tmpl)}>
                  🗑
                </button>
              </div>
            </div>
          ))
        )}

        {/* Predefined summonings */}
        <div className={styles.sectionTitle}>{t('predefinedSummonings')}</div>
        {visiblePredefined.map(p => (
          <div key={p.id} className={styles.templateCard}>
            <div className={styles.templateIcon}>
              {ELEMENT_ICONS[p.element] ?? '⚗️'}
            </div>
            <div className={styles.templateInfo}>
              <div className={styles.templateName}>{getPredefinedName(p.id, locale)}</div>
              <div className={styles.templateMeta}>
                {elementName(p.element)} · {typeName(p.summoningType)} · {p.baseSummonMod}/{p.baseControlMod}
              </div>
            </div>
            <div className={styles.templateActions}>
              <button type="button" className={styles.iconBtn}
                title={t('summon')}
                onClick={() => navigate(`/summon/${characterId}?predefinedId=${p.id}`)}>
                ⚡
              </button>
              <button type="button" className={styles.iconBtn}
                title={t('hide')}
                onClick={() => handleToggleHide(p.id)}>
                👁
              </button>
            </div>
          </div>
        ))}

        {/* Hidden predefined */}
        {showHidden && hiddenIds.length > 0 && (
          <>
            <div className={styles.sectionTitle}>{t('hiddenPredefined')}</div>
            {hiddenPredefined.map(p => (
              <div key={p.id} className={styles.templateCard} style={{ opacity: 0.5 }}>
                <div className={styles.templateIcon}>{ELEMENT_ICONS[p.element] ?? '⚗️'}</div>
                <div className={styles.templateInfo}>
                  <div className={styles.templateName}>
                    {getPredefinedName(p.id, locale)}
                    <span className={styles.hiddenTag}>{t('hide')}</span>
                  </div>
                </div>
                <div className={styles.templateActions}>
                  <button type="button" className={styles.iconBtn}
                    title={t('unhide')}
                    onClick={() => handleToggleHide(p.id)}>
                    👁
                  </button>
                </div>
              </div>
            ))}
          </>
        )}

      </div>

      {/* FAB */}
      <button type="button" className={styles.fab}
        onClick={() => navigate(`/character/${characterId}/elementals/new`)}
        aria-label={t('newTemplate')}>
        +
      </button>

      {/* Delete dialog */}
      {deleteTarget && (
        <div className={styles.dialog}>
          <div className={styles.dialogBox}>
            <div className={styles.dialogTitle}>{t('deleteConfirmTitle')}</div>
            <div className={styles.dialogMsg}>{t('deleteTemplateConfirm')}</div>
            <div className={styles.dialogBtns}>
              <button type="button" className={styles.dialogBtn}
                onClick={() => setDeleteTarget(null)}>{t('cancel')}</button>
              <button type="button" className={`${styles.dialogBtn} ${styles.dialogBtnDanger}`}
                onClick={() => handleDeleteTemplate(deleteTarget)}>{t('delete')}</button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
