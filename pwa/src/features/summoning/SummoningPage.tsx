import { useEffect, useState, useCallback } from 'react';
import { useNavigate, useParams, useSearchParams } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Layout } from '../../components/Layout';
import { CollapsibleSection } from '../../components/CollapsibleSection';
import {
  getCharacterById, getTemplateById, getTemplatesForCharacter,
  getHiddenPredefinedIds, insertTemplate, updateTemplate,
} from '../../core/db/database';
import { useToast } from '../../components/Toast';
import { Character } from '../../core/models/character';
import { DsaElement, ALL_ELEMENTS, ELEMENT_CLASS } from '../../core/models/element';
import { SummoningType } from '../../core/models/summoning-type';
import { SummoningConfig, PredefinedSummoning, defaultSummoningConfig } from '../../core/models/summoning-config';
import { SummoningResult } from '../../core/models/summoning-result';
import { calculateSummoning } from '../../core/calculation/summoning-calculator';
import { predefinedSummonings, getPredefinedName } from '../../core/constants/predefined-summonings';
import { demonNames } from '../../core/constants/element-data';
import { ElementalTemplate } from '../../core/models/elemental-template';
import styles from './SummoningPage.module.css';

// Store result in session for ResultPage
export let lastResult: SummoningResult | null = null;

// ─── Helper sub-components ────────────────────────────────────────────────────

function CheckRow({
  label, cost, checked, onChange, disabled
}: { label: string; cost?: string; checked: boolean; onChange: (v: boolean) => void; disabled?: boolean }) {
  return (
    <div
      className={`${styles.checkRow} ${checked ? styles.checked : ''} ${disabled ? styles.disabled : ''}`}
      onClick={() => !disabled && onChange(!checked)}
    >
      <div className={styles.checkbox}>
        {checked && <span className={styles.checkmark}>✓</span>}
      </div>
      <span className={styles.checkRowLabel}>{label}</span>
      {cost && <span className={styles.checkRowCost}>{cost}</span>}
    </div>
  );
}

function Stepper({
  value, min = 0, max = 99, onChange, disabled
}: { value: number; min?: number; max?: number; onChange: (v: number) => void; disabled?: boolean }) {
  return (
    <div className={styles.stepperInline}>
      <button type="button" className={styles.stepBtn}
        disabled={disabled || value <= min}
        onClick={() => onChange(Math.max(min, value - 1))}>−</button>
      <span className={styles.stepValue}>{value}</span>
      <button type="button" className={styles.stepBtn}
        disabled={disabled || value >= max}
        onClick={() => onChange(Math.min(max, value + 1))}>+</button>
    </div>
  );
}

const ELEMENT_ICONS: Record<DsaElement, string> = {
  [DsaElement.Fire]: '🔥',
  [DsaElement.Water]: '💧',
  [DsaElement.Life]: '🌿',
  [DsaElement.Ice]: '❄️',
  [DsaElement.Stone]: '🪨',
  [DsaElement.Air]: '💨',
};

function elementLabel(el: DsaElement, t: (k: string) => string): string {
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

// ─── Main component ───────────────────────────────────────────────────────────

export function SummoningPage() {
  const { characterId } = useParams<{ characterId: string }>();
  const [searchParams] = useSearchParams();
  const initialTemplateId = searchParams.get('templateId');
  const initialPredefinedId = searchParams.get('predefinedId');
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();

  const { showToast } = useToast();
  const [character, setCharacter] = useState<Character | null>(null);
  const [config, setConfig] = useState<SummoningConfig | null>(null);
  const [activePredefinedId, setActivePredefinedId] = useState<string | null>(initialPredefinedId ?? null);
  const [showLoadDialog, setShowLoadDialog] = useState(false);
  const [showSaveDialog, setShowSaveDialog] = useState(false);
  const [saveName, setSaveName] = useState('');
  const [loadTemplates, setLoadTemplates] = useState<ElementalTemplate[]>([]);
  const [loadHiddenIds, setLoadHiddenIds] = useState<string[]>([]);
  const [showOverwriteConfirm, setShowOverwriteConfirm] = useState<{ name: string; existingId: number } | null>(null);
  const locale = i18n.language.startsWith('de') ? 'de' : 'en';

  // Load character
  useEffect(() => {
    if (!characterId) return;
    getCharacterById(Number(characterId)).then(char => {
      if (char) {
        setCharacter(char);
        const base = defaultSummoningConfig(char);
        setConfig(base);
      }
    });
  }, [characterId]);

  // Load template if provided
  useEffect(() => {
    if (!initialTemplateId || !character) return;
    getTemplateById(Number(initialTemplateId)).then(template => {
      if (template && config) {
        setConfig(c => c ? applyTemplate(c, template) : c);
      }
    });
  }, [initialTemplateId, character]); // eslint-disable-line react-hooks/exhaustive-deps

  // Apply predefined if provided
  useEffect(() => {
    if (!initialPredefinedId || !config) return;
    const p = predefinedSummonings.find(ps => ps.id === initialPredefinedId);
    if (p) {
      setConfig(c => c ? applyPredefined(c, p) : c);
    }
  }, [initialPredefinedId, character]); // eslint-disable-line react-hooks/exhaustive-deps

  function applyTemplate(base: SummoningConfig, tmpl: ElementalTemplate): SummoningConfig {
    return {
      ...base,
      element: tmpl.element as DsaElement,
      summoningType: tmpl.summoningType as SummoningType,
      astralSense: tmpl.astralSense,
      longArm: tmpl.longArm,
      lifeSense: tmpl.lifeSense,
      regenerationLevel: tmpl.regenerationLevel,
      additionalActionsLevel: tmpl.additionalActionsLevel,
      resistanceMagic: tmpl.resistanceMagic,
      resistanceTraitDamage: tmpl.resistanceTraitDamage,
      immunityMagic: tmpl.immunityMagic,
      immunityTraitDamage: tmpl.immunityTraitDamage,
      resistancesDemonic: JSON.parse(tmpl.resistancesDemonicJson || '{}'),
      immunitiesDemonic: JSON.parse(tmpl.immunitiesDemonicJson || '{}'),
      resistancesElemental: parseElementalMap(tmpl.resistancesElementalJson || '{}'),
      immunitiesElemental: parseElementalMap(tmpl.immunitiesElementalJson || '{}'),
      causeFear: tmpl.causeFear,
      artifactAnimationLevel: tmpl.artifactAnimationLevel,
      aura: tmpl.aura,
      blinkingInvisibility: tmpl.blinkingInvisibility,
      elementalShackle: tmpl.elementalShackle,
      elementalGripLevel: tmpl.elementalGripLevel,
      elementalInferno: tmpl.elementalInferno,
      elementalGrowth: tmpl.elementalGrowth,
      drowning: tmpl.drowning,
      areaAttack: tmpl.areaAttack,
      flight: tmpl.flight,
      frost: tmpl.frost,
      ember: tmpl.ember,
      criticalImmunity: tmpl.criticalImmunity,
      boilingBlood: tmpl.boilingBlood,
      fog: tmpl.fog,
      smoke: tmpl.smoke,
      stasis: tmpl.stasis,
      stoneEatingLevel: tmpl.stoneEatingLevel,
      stoneSkinLevel: tmpl.stoneSkinLevel,
      mergeWithElement: tmpl.mergeWithElement,
      sinking: tmpl.sinking,
      wildGrowth: tmpl.wildGrowth,
      burst: tmpl.burst,
      shatteringArmor: tmpl.shatteringArmor,
      modLeP: tmpl.modLeP,
      modINI: tmpl.modINI,
      modRS: tmpl.modRS,
      modGS: tmpl.modGS,
      modMR: tmpl.modMR,
      modAT: tmpl.modAT,
      modPA: tmpl.modPA,
      modTP: tmpl.modTP,
      modAttribute: tmpl.modAttribute,
      modNewTalent: tmpl.modNewTalent,
      modTaWZfW: tmpl.modTaWZfW,
    };
  }

  function applyPredefined(base: SummoningConfig, p: PredefinedSummoning): SummoningConfig {
    return {
      ...base,
      element: p.element,
      summoningType: p.summoningType,
      predefined: p,
      astralSense: p.astralSense,
      longArm: p.longArm,
      lifeSense: p.lifeSense,
      regenerationLevel: p.regenerationLevel,
      additionalActionsLevel: p.additionalActionsLevel,
      resistanceMagic: p.resistanceMagic,
      resistanceTraitDamage: p.resistanceTraitDamage,
      immunityMagic: p.immunityMagic,
      immunityTraitDamage: p.immunityTraitDamage,
      resistancesDemonic: { ...p.resistancesDemonic },
      immunitiesDemonic: { ...p.immunitiesDemonic },
      resistancesElemental: { ...p.resistancesElemental },
      immunitiesElemental: { ...p.immunitiesElemental },
      causeFear: p.causeFear,
      artifactAnimationLevel: p.artifactAnimationLevel,
      aura: p.aura,
      blinkingInvisibility: p.blinkingInvisibility,
      elementalShackle: p.elementalShackle,
      elementalGripLevel: p.elementalGripLevel,
      elementalInferno: p.elementalInferno,
      elementalGrowth: p.elementalGrowth,
      drowning: p.drowning,
      areaAttack: p.areaAttack,
      flight: p.flight,
      frost: p.frost,
      ember: p.ember,
      criticalImmunity: p.criticalImmunity,
      boilingBlood: p.boilingBlood,
      fog: p.fog,
      smoke: p.smoke,
      stasis: p.stasis,
      stoneEatingLevel: p.stoneEatingLevel,
      stoneSkinLevel: p.stoneSkinLevel,
      mergeWithElement: p.mergeWithElement,
      sinking: p.sinking,
      wildGrowth: p.wildGrowth,
      burst: p.burst,
      shatteringArmor: p.shatteringArmor,
      modLeP: p.modLeP,
      modINI: p.modINI,
      modRS: p.modRS,
      modGS: p.modGS,
      modMR: p.modMR,
      modAT: p.modAT,
      modPA: p.modPA,
      modTP: p.modTP,
      modAttribute: p.modAttribute,
      modNewTalent: p.modNewTalent,
      modTaWZfW: p.modTaWZfW,
    };
  }

  function parseElementalMap(json: string): Partial<Record<DsaElement, boolean>> {
    try {
      const obj = JSON.parse(json);
      const result: Partial<Record<DsaElement, boolean>> = {};
      for (const [k, v] of Object.entries(obj)) {
        result[Number(k) as DsaElement] = v as boolean;
      }
      return result;
    } catch { return {}; }
  }

  const upd = useCallback(<K extends keyof SummoningConfig>(key: K, value: SummoningConfig[K]) => {
    setConfig(c => c ? { ...c, [key]: value } : c);
  }, []);

  // Live calculation
  const result = config ? calculateSummoning(config, i18n.language.startsWith('de') ? 'de' : 'en') : null;

  function handleCalculate() {
    if (!result) return;
    lastResult = result;
    navigate('/result');
  }

  async function openLoadDialog() {
    const templates = await getTemplatesForCharacter(Number(characterId));
    const hiddenIds = await getHiddenPredefinedIds(Number(characterId));
    setLoadTemplates(templates);
    setLoadHiddenIds(hiddenIds);
    setShowLoadDialog(true);
  }

  function handleLoadTemplate(tmpl: ElementalTemplate) {
    setConfig(c => c ? applyTemplate(c, tmpl) : c);
    setActivePredefinedId(null);
    setShowLoadDialog(false);
    showToast(t('templateLoaded'));
  }

  function handleLoadPredefined(p: PredefinedSummoning) {
    setConfig(c => c ? applyPredefined(c, p) : c);
    setActivePredefinedId(p.id);
    setShowLoadDialog(false);
    showToast(t('templateLoaded'));
  }

  function openSaveDialog() {
    setSaveName('');
    setShowSaveDialog(true);
  }

  async function handleSaveTemplate() {
    const name = saveName.trim();
    if (!name || !config) return;

    const templates = await getTemplatesForCharacter(Number(characterId));
    const existing = templates.find(tmpl => tmpl.templateName === name);

    if (existing) {
      setShowSaveDialog(false);
      setShowOverwriteConfirm({ name, existingId: existing.id! });
      return;
    }

    await doSaveTemplate(name, null);
  }

  async function handleConfirmOverwrite() {
    if (!showOverwriteConfirm) return;
    await doSaveTemplate(showOverwriteConfirm.name, showOverwriteConfirm.existingId);
    setShowOverwriteConfirm(null);
  }

  async function doSaveTemplate(name: string, existingId: number | null) {
    if (!config) return;

    function encodeDemonic(m: Record<string, boolean>) { return JSON.stringify(m); }
    function encodeElemental(m: Partial<Record<DsaElement, boolean>>) {
      const obj: Record<string, boolean> = {};
      for (const [k, v] of Object.entries(m)) { obj[k] = v as boolean; }
      return JSON.stringify(obj);
    }

    const tmplData = {
      characterId: Number(characterId),
      templateName: name,
      element: config.element,
      summoningType: config.summoningType,
      astralSense: config.astralSense,
      longArm: config.longArm,
      lifeSense: config.lifeSense,
      regenerationLevel: config.regenerationLevel,
      additionalActionsLevel: config.additionalActionsLevel,
      resistanceMagic: config.resistanceMagic,
      resistanceTraitDamage: config.resistanceTraitDamage,
      immunityMagic: config.immunityMagic,
      immunityTraitDamage: config.immunityTraitDamage,
      resistancesDemonicJson: encodeDemonic(config.resistancesDemonic),
      resistancesElementalJson: encodeElemental(config.resistancesElemental),
      immunitiesDemonicJson: encodeDemonic(config.immunitiesDemonic),
      immunitiesElementalJson: encodeElemental(config.immunitiesElemental),
      causeFear: config.causeFear,
      artifactAnimationLevel: config.artifactAnimationLevel,
      aura: config.aura,
      blinkingInvisibility: config.blinkingInvisibility,
      elementalShackle: config.elementalShackle,
      elementalGripLevel: config.elementalGripLevel,
      elementalInferno: config.elementalInferno,
      elementalGrowth: config.elementalGrowth,
      drowning: config.drowning,
      areaAttack: config.areaAttack,
      flight: config.flight,
      frost: config.frost,
      ember: config.ember,
      criticalImmunity: config.criticalImmunity,
      boilingBlood: config.boilingBlood,
      fog: config.fog,
      smoke: config.smoke,
      stasis: config.stasis,
      stoneEatingLevel: config.stoneEatingLevel,
      stoneSkinLevel: config.stoneSkinLevel,
      mergeWithElement: config.mergeWithElement,
      sinking: config.sinking,
      wildGrowth: config.wildGrowth,
      burst: config.burst,
      shatteringArmor: config.shatteringArmor,
      modLeP: config.modLeP,
      modINI: config.modINI,
      modRS: config.modRS,
      modGS: config.modGS,
      modMR: config.modMR,
      modAT: config.modAT,
      modPA: config.modPA,
      modTP: config.modTP,
      modAttribute: config.modAttribute,
      modNewTalent: config.modNewTalent,
      modTaWZfW: config.modTaWZfW,
    };

    if (existingId !== null) {
      await updateTemplate({ ...tmplData, id: existingId } as ElementalTemplate);
    } else {
      await insertTemplate(tmplData);
    }

    setShowSaveDialog(false);
    showToast(t('templateSaved'));
  }

  const isPredefined = config?.predefined !== null;
  const pred = config?.predefined ?? null;

  if (!config || !character) {
    return <Layout title={t('summonElemental')} showBack>{null}</Layout>;
  }

  const el = config.element;

  // Options for dropdowns
  const placeOptions = Array.from({ length: 14 }, (_, i) => ({ value: i, label: t(`place${i}`) }));
  const timeOptions = Array.from({ length: 7 }, (_, i) => ({ value: i, label: t(`time${i}`) }));
  const giftOptions = Array.from({ length: 15 }, (_, i) => ({ value: i, label: t(`gift${i}`) }));
  const deedOptions = Array.from({ length: 15 }, (_, i) => ({ value: i, label: t(`deed${i}`) }));
  const trueNameOptions = [
    { value: 0, label: t('none') },
    ...Array.from({ length: 7 }, (_, i) => ({ value: i + 1, label: `${t('quality')} ${i + 1}` }))
  ];
  const materialOptions = Array.from({ length: 7 }, (_, i) => ({
    value: i,
    label: `${i - 3 > 0 ? '+' : ''}${i - 3}`
  }));
  const powernodeOptions = [
    'PS 0-1 (0)', 'PS 2-5 (-1)', 'PS 6-9 (-2)', 'PS 10-13 (-3)',
    'PS 14-17 (-4)', 'PS 18-21 (-5)', 'PS 22-25 (-6)', 'PS 26-29 (-7)',
    'PS 30-33 (-8)', 'PS 34-37 (-9)',
  ].map((label, i) => ({ value: i, label }));

  const summonMod = result?.summonDifficulty ?? 0;
  const controlMod = result?.controlDifficulty ?? 0;

  function modClass(v: number) {
    if (v >= 15) return styles.high;
    if (v >= 8) return styles.medium;
    return styles.low;
  }

  return (
    <Layout
      title={`${character.characterName} – ${t('summonElemental')}`}
      showBack
      actions={
        <div style={{ display: 'flex', gap: 8 }}>
          <button type="button" className={styles.headerBtn} title={t('loadTemplate')} onClick={openLoadDialog}>
            📑
          </button>
          <button type="button" className={styles.headerBtn} title={t('saveAsTemplate')} onClick={openSaveDialog}>
            💾
          </button>
        </div>
      }
    >
      <div className={styles.page}>

        {/* Element & Type */}
        <CollapsibleSection title={t('elementAndType')} defaultOpen>
          <div style={{ marginBottom: 12 }}>
            <div style={{ fontSize: 12, color: 'var(--text-muted)', marginBottom: 8 }}>{t('element')}</div>
            <div className={styles.elementGrid}>
              {ALL_ELEMENTS.map(e => (
                <button
                  key={e}
                  type="button"
                  className={`${styles.elementBtn} ${styles[ELEMENT_CLASS[e]]} ${el === e ? styles.active : ''}`}
                  onClick={() => {
                    upd('element', e);
                    if (isPredefined) upd('predefined', null);
                    setActivePredefinedId(null);
                  }}
                >
                  {elementLabel(e, t)}
                </button>
              ))}
            </div>

            <div style={{ fontSize: 12, color: 'var(--text-muted)', margin: '12px 0 8px' }}>{t('selectSummoningType')}</div>
            <div className={styles.typeGrid}>
              {([SummoningType.Servant, SummoningType.Djinn, SummoningType.Master] as SummoningType[]).map(st => (
                <button
                  key={st}
                  type="button"
                  className={`${styles.typeBtn} ${config.summoningType === st ? styles.active : ''}`}
                  onClick={() => {
                    upd('summoningType', st);
                    if (isPredefined) upd('predefined', null);
                    setActivePredefinedId(null);
                  }}
                >
                  {st === SummoningType.Servant ? t('elementalServant') :
                   st === SummoningType.Djinn ? t('djinn') : t('masterOfElement')}
                </button>
              ))}
            </div>
          </div>
        </CollapsibleSection>

        {/* Circumstances */}
        <CollapsibleSection title={t('circumstances')}>
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('materialPurity')}</span>
            <select className={styles.select} value={config.materialPurityIndex}
              onChange={e => upd('materialPurityIndex', Number(e.target.value))}>
              {materialOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('trueName')}</span>
            <select className={styles.select} value={config.trueNameIndex}
              onChange={e => upd('trueNameIndex', Number(e.target.value))}>
              {trueNameOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('place')}</span>
            <select className={styles.select} value={config.placeIndex}
              onChange={e => upd('placeIndex', Number(e.target.value))}>
              {placeOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
          {character.powerlineMagicI && (
            <div className={styles.formRow}>
              <span className={styles.formLabel}>{t('powernode')}</span>
              <select className={styles.select} value={config.powernodeIndex}
                onChange={e => upd('powernodeIndex', Number(e.target.value))}>
                {powernodeOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
              </select>
            </div>
          )}
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('time')}</span>
            <select className={styles.select} value={config.timeIndex}
              onChange={e => upd('timeIndex', Number(e.target.value))}>
              {timeOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('gift')}</span>
            <select className={styles.select} value={config.giftIndex}
              onChange={e => upd('giftIndex', Number(e.target.value))}>
              {giftOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('deed')}</span>
            <select className={styles.select} value={config.deedIndex}
              onChange={e => upd('deedIndex', Number(e.target.value))}>
              {deedOptions.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
          <CheckRow label={t('properAttire')} checked={config.properAttire}
            onChange={v => upd('properAttire', v)} />
        </CollapsibleSection>

        {/* Abilities */}
        <CollapsibleSection title={t('abilities')}>
          <CheckRow label={t('astralSense')} cost={t('astralSenseCost')}
            checked={config.astralSense} onChange={v => upd('astralSense', v)} disabled={!!pred?.astralSense} />
          <CheckRow label={t('longArm')} cost={t('longArmCost')}
            checked={config.longArm} onChange={v => upd('longArm', v)} disabled={!!pred?.longArm} />
          <CheckRow label={t('lifeSense')} cost={t('lifeSenseCost')}
            checked={config.lifeSense} onChange={v => upd('lifeSense', v)} disabled={!!pred?.lifeSense} />

          {/* Regeneration */}
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('regeneration')}</span>
            <span className={styles.formCost}>{config.regenerationLevel === 1 ? t('regenerationCostI') : config.regenerationLevel === 2 ? t('regenerationCostII') : ''}</span>
            <select className={styles.select} value={config.regenerationLevel}
              onChange={e => upd('regenerationLevel', Number(e.target.value) as 0 | 1 | 2)}>
              {(pred?.regenerationLevel ?? 0) <= 0 && <option value={0}>{t('no')}</option>}
              {(pred?.regenerationLevel ?? 0) <= 1 && <option value={1}>{t('romanOne')}</option>}
              <option value={2}>{t('romanTwo')}</option>
            </select>
          </div>

          {/* Additional actions */}
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('additionalActions')}</span>
            <span className={styles.formCost}>{config.additionalActionsLevel === 1 ? t('additionalActionsCostI') : config.additionalActionsLevel === 2 ? t('additionalActionsCostII') : ''}</span>
            <select className={styles.select} value={config.additionalActionsLevel}
              onChange={e => upd('additionalActionsLevel', Number(e.target.value) as 0 | 1 | 2)}>
              {(pred?.additionalActionsLevel ?? 0) <= 0 && <option value={0}>{t('no')}</option>}
              {(pred?.additionalActionsLevel ?? 0) <= 1 && <option value={1}>{t('romanOne')}</option>}
              <option value={2}>{t('romanTwo')}</option>
            </select>
          </div>

          <CheckRow label={t('resistanceMagic')} cost="5 ZfP*"
            checked={config.resistanceMagic && !config.immunityMagic}
            onChange={v => { upd('resistanceMagic', v); if (v) upd('immunityMagic', false); }}
            disabled={!!pred?.resistanceMagic} />
          <CheckRow label={t('immunityMagic')} cost="10 ZfP*"
            checked={config.immunityMagic}
            onChange={v => { upd('immunityMagic', v); if (v) upd('resistanceMagic', false); }}
            disabled={!!pred?.immunityMagic} />
          <CheckRow label={t('resistanceTraitDamage')} cost="5 ZfP*"
            checked={config.resistanceTraitDamage && !config.immunityTraitDamage && !config.resistanceMagic}
            onChange={v => { upd('resistanceTraitDamage', v); if (v) upd('immunityTraitDamage', false); }}
            disabled={(config.resistanceMagic || config.immunityMagic) || !!pred?.resistanceTraitDamage} />
          <CheckRow label={t('immunityTraitDamage')} cost="10 ZfP*"
            checked={config.immunityTraitDamage && !config.immunityMagic}
            onChange={v => { upd('immunityTraitDamage', v); if (v) upd('resistanceTraitDamage', false); }}
            disabled={config.immunityMagic || !!pred?.immunityTraitDamage} />
        </CollapsibleSection>

        {/* Special Properties */}
        <CollapsibleSection title={t('specialProperties')}>
          <CheckRow label={t('causeFear')} cost={t('causeFearCost')} checked={config.causeFear} onChange={v => upd('causeFear', v)} disabled={!!pred?.causeFear} />

          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('artifactAnimation')}</span>
            <span className={styles.formCost}>{t('artifactAnimationCost')}</span>
            <Stepper value={config.artifactAnimationLevel} min={pred?.artifactAnimationLevel ?? 0} max={3} onChange={v => upd('artifactAnimationLevel', v)} />
          </div>

          <CheckRow label={t('aura')} cost={t('auraCost')} checked={config.aura} onChange={v => upd('aura', v)} disabled={!!pred?.aura} />
          <CheckRow label={t('blinkingInvisibility')} cost={t('blinkingInvisibilityCost')} checked={config.blinkingInvisibility} onChange={v => upd('blinkingInvisibility', v)} disabled={!!pred?.blinkingInvisibility} />
          <CheckRow label={t('elementalShackle')} cost={t('elementalShackleCost')} checked={config.elementalShackle} onChange={v => upd('elementalShackle', v)} disabled={!!pred?.elementalShackle} />

          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('elementalGrip')}</span>
            <span className={styles.formCost}>{t('elementalGripCost')}</span>
            <Stepper value={config.elementalGripLevel} min={pred?.elementalGripLevel ?? 0} max={3} onChange={v => upd('elementalGripLevel', v)} />
          </div>

          <CheckRow label={t('elementalInferno')} cost={t('elementalInfernoCost')} checked={config.elementalInferno} onChange={v => upd('elementalInferno', v)} disabled={!!pred?.elementalInferno} />
          <CheckRow label={t('elementalGrowth')} cost={t('elementalGrowthCost')} checked={config.elementalGrowth} onChange={v => upd('elementalGrowth', v)} disabled={!!pred?.elementalGrowth} />
          <CheckRow label={t('areaAttack')} cost={t('areaAttackCost')} checked={config.areaAttack} onChange={v => upd('areaAttack', v)} disabled={!!pred?.areaAttack} />
          <CheckRow label={t('flight')} cost={t('flightCost')} checked={config.flight} onChange={v => upd('flight', v)} disabled={!!pred?.flight} />
          <CheckRow label={t('criticalImmunity')} cost={t('criticalImmunityCost')} checked={config.criticalImmunity} onChange={v => upd('criticalImmunity', v)} disabled={!!pred?.criticalImmunity} />
          <CheckRow label={t('mergeWithElement')} cost={t('mergeWithElementCost')} checked={config.mergeWithElement} onChange={v => upd('mergeWithElement', v)} disabled={!!pred?.mergeWithElement} />
          <CheckRow label={t('burst')} cost={t('burstCost')} checked={config.burst} onChange={v => upd('burst', v)} disabled={!!pred?.burst} />
        </CollapsibleSection>

        {/* Element-specific properties */}
        <CollapsibleSection title={t('elementSpecificProperties')}>
          {/* Water only */}
          {(el === DsaElement.Water) && (
            <CheckRow label={t('drowning')} cost={t('drowningCost')} checked={config.drowning} onChange={v => upd('drowning', v)} disabled={!!pred?.drowning} />
          )}
          {/* Water, Air */}
          {(el === DsaElement.Water || el === DsaElement.Air) && (
            <CheckRow label={t('fog')} cost={t('fogCost')} checked={config.fog} onChange={v => upd('fog', v)} disabled={!!pred?.fog} />
          )}
          {/* Fire, Air */}
          {(el === DsaElement.Fire || el === DsaElement.Air) && (
            <CheckRow label={t('smoke')} cost={t('smokeCost')} checked={config.smoke} onChange={v => upd('smoke', v)} disabled={!!pred?.smoke} />
          )}
          {/* Ice only */}
          {(el === DsaElement.Ice) && (
            <CheckRow label={t('frost')} cost={t('frostCost')} checked={config.frost} onChange={v => upd('frost', v)} disabled={!!pred?.frost} />
          )}
          {/* Fire, Stone/Ore */}
          {(el === DsaElement.Fire || el === DsaElement.Stone) && (
            <CheckRow label={t('ember')} cost={t('emberCost')} checked={config.ember} onChange={v => upd('ember', v)} disabled={!!pred?.ember} />
          )}
          {/* Fire, Water */}
          {(el === DsaElement.Fire || el === DsaElement.Water) && (
            <CheckRow label={t('boilingBlood')} cost={t('boilingBloodCost')} checked={config.boilingBlood} onChange={v => upd('boilingBlood', v)} disabled={!!pred?.boilingBlood} />
          )}
          {/* Stone, Ice, Life */}
          {(el === DsaElement.Stone || el === DsaElement.Ice || el === DsaElement.Life) && (
            <CheckRow label={t('stasis')} cost={t('stasisCost')} checked={config.stasis} onChange={v => upd('stasis', v)} disabled={!!pred?.stasis} />
          )}
          {/* Stone, Ice */}
          {(el === DsaElement.Stone || el === DsaElement.Ice) && (
            <div className={styles.formRow}>
              <span className={styles.formLabel}>{t('stoneEating')}</span>
              <span className={styles.formCost}>{t('stoneEatingCost')}</span>
              <Stepper value={config.stoneEatingLevel} min={pred?.stoneEatingLevel ?? 0} max={6} onChange={v => upd('stoneEatingLevel', v)} />
            </div>
          )}
          {/* Stone, Life */}
          {(el === DsaElement.Stone || el === DsaElement.Life) && (
            <div className={styles.formRow}>
              <span className={styles.formLabel}>{t('stoneSkin')}</span>
              <span className={styles.formCost}>{t('stoneSkinCost')}</span>
              <Stepper value={config.stoneSkinLevel} min={pred?.stoneSkinLevel ?? 0} max={6} onChange={v => upd('stoneSkinLevel', v)} />
            </div>
          )}
          {/* Life, Water */}
          {(el === DsaElement.Life || el === DsaElement.Water) && (
            <CheckRow label={t('sinking')} cost={t('sinkingCost')} checked={config.sinking} onChange={v => upd('sinking', v)} disabled={!!pred?.sinking} />
          )}
          {/* Life only */}
          {(el === DsaElement.Life) && (
            <CheckRow label={t('wildGrowth')} cost={t('wildGrowthCost')} checked={config.wildGrowth} onChange={v => upd('wildGrowth', v)} disabled={!!pred?.wildGrowth} />
          )}
          {/* Stone, Life, Fire, Ice */}
          {(el === DsaElement.Stone || el === DsaElement.Life || el === DsaElement.Fire || el === DsaElement.Ice) && (
            <CheckRow label={t('shatteringArmor')} cost={t('shatteringArmorCost')} checked={config.shatteringArmor} onChange={v => upd('shatteringArmor', v)} disabled={!!pred?.shatteringArmor} />
          )}
          {el === DsaElement.Air && (
            <p className={styles.infoNote}>{t('none')}</p>
          )}
        </CollapsibleSection>

        {/* Value Modifications */}
        <CollapsibleSection title={t('valueModifications')}>
          {([
            ['modLeP', 'modLeP', 'modLePCost'],
            ['modINI', 'modINI', 'modINICost'],
            ['modRS', 'modRS', 'modRSCost'],
            ['modGS', 'modGS', 'modGSCost'],
            ['modMR', 'modMR', 'modMRCost'],
            ['modAT', 'modAT', 'modATCost'],
            ['modPA', 'modPA', 'modPACost'],
            ['modTP', 'modTP', 'modTPCost'],
            ['modAttribute', 'modAttribute', 'modAttributeCost'],
            ['modNewTalent', 'modNewTalent', 'modNewTalentCost'],
            ['modTaWZfW', 'modTaWZfW', 'modTaWZfWCost'],
          ] as [keyof SummoningConfig & keyof PredefinedSummoning, string, string][]).map(([key, labelKey, costKey]) => (
            <div key={key} className={styles.formRow}>
              <span className={styles.formLabel}>{t(labelKey)}</span>
              <span className={styles.formCost}>{t(costKey)}</span>
              <Stepper
                value={config[key] as number}
                min={(pred?.[key] as number) ?? 0}
                max={20}
                onChange={v => upd(key, v)}
              />
            </div>
          ))}
        </CollapsibleSection>

        {/* Resistances – Demonic */}
        <CollapsibleSection title={t('resistances')}>
          <p style={{ fontSize: 12, color: 'var(--text-muted)', marginBottom: 8 }}>{t('resistanceAgainstMagicAttacks')}</p>
          {demonNames.map(demon => {
            const hasRes = config.resistancesDemonic[demon] === true;
            const hasImm = config.immunitiesDemonic[demon] === true;
            const predRes = !!pred?.resistancesDemonic[demon];
            const predImm = !!pred?.immunitiesDemonic[demon];
            return (
              <div key={demon} className={styles.resistanceItem}>
                <span className={styles.resistanceLabel}>{demon}</span>
                <div className={styles.resistanceBtns}>
                  <button type="button" className={`${styles.resBtn} ${hasRes ? styles.activeRes : ''} ${predRes ? styles.disabled : ''}`}
                    disabled={predRes}
                    onClick={() => {
                      const next = !hasRes;
                      upd('resistancesDemonic', { ...config.resistancesDemonic, [demon]: next });
                      if (next) upd('immunitiesDemonic', { ...config.immunitiesDemonic, [demon]: false });
                    }}>
                    {t('resistance')}
                  </button>
                  <button type="button" className={`${styles.resBtn} ${hasImm ? styles.activeImm : ''} ${predImm ? styles.disabled : ''}`}
                    disabled={predImm}
                    onClick={() => {
                      const next = !hasImm;
                      upd('immunitiesDemonic', { ...config.immunitiesDemonic, [demon]: next });
                      if (next) upd('resistancesDemonic', { ...config.resistancesDemonic, [demon]: false });
                    }}>
                    {t('immunity')}
                  </button>
                </div>
              </div>
            );
          })}

          <p style={{ fontSize: 12, color: 'var(--text-muted)', margin: '12px 0 8px' }}>{t('resistanceAgainstElementalAttacks')}</p>
          {ALL_ELEMENTS.filter(e => e !== el).map(e => {
            const hasRes = config.resistancesElemental[e] === true;
            const hasImm = config.immunitiesElemental[e] === true;
            const predRes = !!pred?.resistancesElemental[e];
            const predImm = !!pred?.immunitiesElemental[e];
            return (
              <div key={e} className={styles.resistanceItem}>
                <span className={styles.resistanceLabel}>{elementLabel(e, t)}</span>
                <div className={styles.resistanceBtns}>
                  <button type="button" className={`${styles.resBtn} ${hasRes ? styles.activeRes : ''} ${predRes ? styles.disabled : ''}`}
                    disabled={predRes}
                    onClick={() => {
                      const next = !hasRes;
                      upd('resistancesElemental', { ...config.resistancesElemental, [e]: next });
                      if (next) upd('immunitiesElemental', { ...config.immunitiesElemental, [e]: false });
                    }}>
                    {t('resistance')} (3)
                  </button>
                  <button type="button" className={`${styles.resBtn} ${hasImm ? styles.activeImm : ''} ${predImm ? styles.disabled : ''}`}
                    disabled={predImm}
                    onClick={() => {
                      const next = !hasImm;
                      upd('immunitiesElemental', { ...config.immunitiesElemental, [e]: next });
                      if (next) upd('resistancesElemental', { ...config.resistancesElemental, [e]: false });
                    }}>
                    {t('immunity')} (7)
                  </button>
                </div>
              </div>
            );
          })}
          <p className={styles.infoNote}>{t('fire')}: {elementLabel(el, t)} → {t('none')} (automatic)</p>
        </CollapsibleSection>

        {/* GM Modifiers */}
        <CollapsibleSection title={t('gmModifiers')}>
          <CheckRow label={t('bloodMagicUsed')} checked={config.bloodMagicUsed}
            onChange={v => upd('bloodMagicUsed', v)} />
          <CheckRow label={t('summonedLesserDemon')} checked={config.summonedLesserDemon}
            onChange={v => { upd('summonedLesserDemon', v); if (v) upd('summonedHornedDemon', false); }}
            disabled={config.summonedHornedDemon} />
          <CheckRow label={t('summonedHornedDemon')} checked={config.summonedHornedDemon}
            onChange={v => { upd('summonedHornedDemon', v); if (v) upd('summonedLesserDemon', false); }} />

          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('additionalSummonMod')}</span>
            <div className={styles.stepperInline}>
              <button type="button" className={styles.stepBtn}
                onClick={() => upd('additionalSummonMod', config.additionalSummonMod - 1)}>−</button>
              <span className={styles.stepValue}>{config.additionalSummonMod}</span>
              <button type="button" className={styles.stepBtn}
                onClick={() => upd('additionalSummonMod', config.additionalSummonMod + 1)}>+</button>
            </div>
          </div>
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('additionalControlMod')}</span>
            <div className={styles.stepperInline}>
              <button type="button" className={styles.stepBtn}
                onClick={() => upd('additionalControlMod', config.additionalControlMod - 1)}>−</button>
              <span className={styles.stepValue}>{config.additionalControlMod}</span>
              <button type="button" className={styles.stepBtn}
                onClick={() => upd('additionalControlMod', config.additionalControlMod + 1)}>+</button>
            </div>
          </div>
        </CollapsibleSection>

      </div>

      {/* Sticky bottom bar */}
      <div className={styles.stickyBar}>
        <div className={styles.stickyInner}>
          <div className={styles.modDisplay}>
            <div className={styles.modCard}>
              <div className={styles.modCardLabel}>{t('summonLabel')}</div>
              <div className={`${styles.modCardValue} ${modClass(summonMod)}`}>{summonMod > 0 ? '+' : ''}{summonMod}</div>
            </div>
            <div className={styles.modCard}>
              <div className={styles.modCardLabel}>{t('controlLabel')}</div>
              <div className={`${styles.modCardValue} ${modClass(controlMod)}`}>{controlMod > 0 ? '+' : ''}{controlMod}</div>
            </div>
          </div>
          <button type="button" className={styles.calcBtn} onClick={handleCalculate}>
            {t('calculate')}
          </button>
        </div>
      </div>

      {/* Load template dialog */}
      {showLoadDialog && (
        <div className={styles.dialog}>
          <div className={styles.dialogBox} style={{ maxHeight: '80vh', overflow: 'auto' }}>
            <div className={styles.dialogTitle}>{t('loadTemplate')}</div>

            {/* Predefined summonings */}
            <div style={{ fontSize: 12, color: 'var(--text-muted)', margin: '8px 0 4px', fontWeight: 600 }}>{t('predefinedSummonings')}</div>
            {predefinedSummonings
              .filter(p => !loadHiddenIds.includes(p.id))
              .map(p => (
                <button key={p.id} type="button" className={styles.loadItem}
                  onClick={() => handleLoadPredefined(p)}>
                  <span>{ELEMENT_ICONS[p.element] ?? ''} {getPredefinedName(p.id, locale)}</span>
                  <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{p.baseSummonMod}/{p.baseControlMod}</span>
                </button>
              ))}

            {/* User templates */}
            {loadTemplates.length > 0 && (
              <>
                <div style={{ fontSize: 12, color: 'var(--text-muted)', margin: '12px 0 4px', fontWeight: 600 }}>{t('elementalTemplates')}</div>
                {loadTemplates.map(tmpl => (
                  <button key={tmpl.id} type="button" className={styles.loadItem}
                    onClick={() => handleLoadTemplate(tmpl)}>
                    <span>{ELEMENT_ICONS[tmpl.element as DsaElement] ?? ''} {tmpl.templateName}</span>
                  </button>
                ))}
              </>
            )}

            <div className={styles.dialogBtns}>
              <button type="button" className={styles.dialogBtn}
                onClick={() => setShowLoadDialog(false)}>{t('cancel')}</button>
            </div>
          </div>
        </div>
      )}

      {/* Save template dialog */}
      {showSaveDialog && (
        <div className={styles.dialog}>
          <div className={styles.dialogBox}>
            <div className={styles.dialogTitle}>{t('saveAsTemplate')}</div>
            <input
              type="text"
              className={styles.dialogInput}
              placeholder={t('templateName')}
              value={saveName}
              onChange={e => setSaveName(e.target.value)}
              autoFocus
              onKeyDown={e => { if (e.key === 'Enter') handleSaveTemplate(); }}
            />
            <div className={styles.dialogBtns}>
              <button type="button" className={styles.dialogBtn}
                onClick={() => setShowSaveDialog(false)}>{t('cancel')}</button>
              <button type="button" className={`${styles.dialogBtn} ${styles.dialogBtnPrimary}`}
                disabled={!saveName.trim()}
                onClick={handleSaveTemplate}>{t('save')}</button>
            </div>
          </div>
        </div>
      )}

      {/* Overwrite confirmation */}
      {showOverwriteConfirm && (
        <div className={styles.dialog}>
          <div className={styles.dialogBox}>
            <div className={styles.dialogTitle}>{t('overwriteTemplateTitle')}</div>
            <div className={styles.dialogMsg}>{t('overwriteTemplateMessage')}</div>
            <div className={styles.dialogBtns}>
              <button type="button" className={styles.dialogBtn}
                onClick={() => setShowOverwriteConfirm(null)}>{t('cancel')}</button>
              <button type="button" className={`${styles.dialogBtn} ${styles.dialogBtnDanger}`}
                onClick={handleConfirmOverwrite}>{t('overwrite')}</button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
