import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Layout } from '../../components/Layout';
import { CollapsibleSection } from '../../components/CollapsibleSection';
import { useToast } from '../../components/Toast';
import {
  getTemplateById, insertTemplate, updateTemplate, getTemplatesForCharacter,
} from '../../core/db/database';
import { ElementalTemplate } from '../../core/models/elemental-template';
import { DsaElement, ALL_ELEMENTS, ELEMENT_CLASS } from '../../core/models/element';
import { SummoningType } from '../../core/models/summoning-type';
import { demonNames } from '../../core/constants/element-data';
import styles from '../summoning/SummoningPage.module.css';
import editStyles from '../character-edit/CharacterEditPage.module.css';

type TmplForm = Omit<ElementalTemplate, 'id' | 'characterId'>;

const DEFAULT_FORM: TmplForm = {
  templateName: '',
  element: DsaElement.Fire,
  summoningType: SummoningType.Servant,
  astralSense: false, longArm: false, lifeSense: false,
  regenerationLevel: 0, additionalActionsLevel: 0,
  resistanceMagic: false, resistanceTraitDamage: false,
  immunityMagic: false, immunityTraitDamage: false,
  resistancesDemonicJson: '{}', resistancesElementalJson: '{}',
  immunitiesDemonicJson: '{}', immunitiesElementalJson: '{}',
  causeFear: false, artifactAnimationLevel: 0, aura: false,
  blinkingInvisibility: false, elementalShackle: false, elementalGripLevel: 0,
  elementalInferno: false, elementalGrowth: false, drowning: false,
  areaAttack: false, flight: false, frost: false, ember: false,
  criticalImmunity: false, boilingBlood: false, fog: false, smoke: false,
  stasis: false, stoneEatingLevel: 0, stoneSkinLevel: 0,
  mergeWithElement: false, sinking: false, wildGrowth: false,
  burst: false, shatteringArmor: false,
  modLeP: 0, modINI: 0, modRS: 0, modGS: 0, modMR: 0,
  modAT: 0, modPA: 0, modTP: 0, modAttribute: 0, modNewTalent: 0, modTaWZfW: 0,
};

function parseJsonMap(json: string): Record<string, boolean> {
  try { return JSON.parse(json); } catch { return {}; }
}

function parseElementalMap(json: string): Partial<Record<DsaElement, boolean>> {
  try {
    const obj = JSON.parse(json);
    const res: Partial<Record<DsaElement, boolean>> = {};
    for (const [k, v] of Object.entries(obj)) res[Number(k) as DsaElement] = v as boolean;
    return res;
  } catch { return {}; }
}

function CheckRow({ label, cost, checked, onChange }: { label: string; cost?: string; checked: boolean; onChange: (v: boolean) => void }) {
  return (
    <div
      className={`${styles.checkRow} ${checked ? styles.checked : ''}`}
      onClick={() => onChange(!checked)}
    >
      <div className={styles.checkbox}>
        {checked && <span className={styles.checkmark}>✓</span>}
      </div>
      <span className={styles.checkRowLabel}>{label}</span>
      {cost && <span className={styles.checkRowCost}>{cost}</span>}
    </div>
  );
}

function Stepper({ value, min = 0, max = 99, onChange }: { value: number; min?: number; max?: number; onChange: (v: number) => void }) {
  return (
    <div className={styles.stepperInline}>
      <button type="button" className={styles.stepBtn} disabled={value <= min} onClick={() => onChange(Math.max(min, value - 1))}>−</button>
      <span className={styles.stepValue}>{value}</span>
      <button type="button" className={styles.stepBtn} disabled={value >= max} onClick={() => onChange(Math.min(max, value + 1))}>+</button>
    </div>
  );
}

export function ElementalTemplateEditPage() {
  const { id, templateId } = useParams<{ id: string; templateId?: string }>();
  const characterId = Number(id);
  const isNew = !templateId;
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { showToast } = useToast();

  const [form, setForm] = useState<TmplForm>({ ...DEFAULT_FORM });
  const [nameError, setNameError] = useState('');
  const [overwriteTarget, setOverwriteTarget] = useState<ElementalTemplate | null>(null);

  useEffect(() => {
    if (!isNew && templateId) {
      getTemplateById(Number(templateId)).then(tmpl => {
        if (tmpl) {
          const { id: _id, characterId: _cid, ...rest } = tmpl;
          setForm(rest);
        }
      });
    }
  }, [templateId, isNew]);

  function set<K extends keyof TmplForm>(key: K, value: TmplForm[K]) {
    setForm(f => ({ ...f, [key]: value }));
  }

  async function doSave(overwriteId?: number) {
    if (!form.templateName.trim()) {
      setNameError(t('errorTemplateName'));
      return;
    }
    setNameError('');

    if (overwriteId) {
      await updateTemplate({ ...form, id: overwriteId, characterId });
      showToast(t('templateSaved'));
      navigate(-1);
      return;
    }

    const all = await getTemplatesForCharacter(characterId);
    const existing = all.find(t => t.templateName === form.templateName.trim() && t.id !== Number(templateId));
    if (existing) {
      setOverwriteTarget(existing);
      return;
    }

    if (isNew) {
      await insertTemplate({ ...form, characterId });
    } else {
      await updateTemplate({ ...form, id: Number(templateId), characterId });
    }
    showToast(t('templateSaved'));
    navigate(-1);
  }

  const el = form.element as DsaElement;
  const demonicRes = parseJsonMap(form.resistancesDemonicJson);
  const demonicImm = parseJsonMap(form.immunitiesDemonicJson);
  const eleRes = parseElementalMap(form.resistancesElementalJson);
  const eleImm = parseElementalMap(form.immunitiesElementalJson);

  function updateDemonicRes(demon: string, val: boolean) {
    const next = { ...demonicRes, [demon]: val };
    set('resistancesDemonicJson', JSON.stringify(next));
    if (val) {
      const imm = { ...demonicImm, [demon]: false };
      set('immunitiesDemonicJson', JSON.stringify(imm));
    }
  }

  function updateDemonicImm(demon: string, val: boolean) {
    const next = { ...demonicImm, [demon]: val };
    set('immunitiesDemonicJson', JSON.stringify(next));
    if (val) {
      const res = { ...demonicRes, [demon]: false };
      set('resistancesDemonicJson', JSON.stringify(res));
    }
  }

  function updateEleRes(e: DsaElement, val: boolean) {
    const next = { ...eleRes, [e]: val };
    set('resistancesElementalJson', JSON.stringify(Object.fromEntries(Object.entries(next).map(([k, v]) => [k, v]))));
    if (val) {
      const imm = { ...eleImm, [e]: false };
      set('immunitiesElementalJson', JSON.stringify(Object.fromEntries(Object.entries(imm).map(([k, v]) => [k, v]))));
    }
  }

  function updateEleImm(e: DsaElement, val: boolean) {
    const next = { ...eleImm, [e]: val };
    set('immunitiesElementalJson', JSON.stringify(Object.fromEntries(Object.entries(next).map(([k, v]) => [k, v]))));
    if (val) {
      const res = { ...eleRes, [e]: false };
      set('resistancesElementalJson', JSON.stringify(Object.fromEntries(Object.entries(res).map(([k, v]) => [k, v]))));
    }
  }

  function elementLabel(e: DsaElement): string {
    const map: Record<DsaElement, string> = {
      [DsaElement.Fire]: t('fire'), [DsaElement.Water]: t('water'),
      [DsaElement.Life]: t('life'), [DsaElement.Ice]: t('ice'),
      [DsaElement.Stone]: t('stone'), [DsaElement.Air]: t('air'),
    };
    return map[e];
  }

  return (
    <Layout title={isNew ? t('newTemplate') : t('editTemplate')} showBack>
      <div className={styles.page}>

        {/* Template name */}
        <div>
          <input
            className={editStyles.input}
            style={{ width: '100%', boxSizing: 'border-box' }}
            type="text"
            placeholder={t('templateName')}
            value={form.templateName}
            onChange={e => set('templateName', e.target.value)}
          />
          {nameError && <span className={editStyles.errorText}>{nameError}</span>}
        </div>

        {/* Element & Type */}
        <CollapsibleSection title={t('elementAndType')} defaultOpen>
          <div style={{ marginBottom: 8, fontSize: 12, color: 'var(--text-muted)' }}>{t('element')}</div>
          <div className={styles.elementGrid}>
            {ALL_ELEMENTS.map(e => (
              <button key={e} type="button"
                className={`${styles.elementBtn} ${styles[ELEMENT_CLASS[e]]} ${el === e ? styles.active : ''}`}
                onClick={() => set('element', e)}>
                {elementLabel(e)}
              </button>
            ))}
          </div>
          <div style={{ marginTop: 12, marginBottom: 8, fontSize: 12, color: 'var(--text-muted)' }}>{t('selectSummoningType')}</div>
          <div className={styles.typeGrid}>
            {([SummoningType.Servant, SummoningType.Djinn, SummoningType.Master] as SummoningType[]).map(st => (
              <button key={st} type="button"
                className={`${styles.typeBtn} ${form.summoningType === st ? styles.active : ''}`}
                onClick={() => set('summoningType', st)}>
                {st === SummoningType.Servant ? t('elementalServant') : st === SummoningType.Djinn ? t('djinn') : t('masterOfElement')}
              </button>
            ))}
          </div>
        </CollapsibleSection>

        {/* Abilities */}
        <CollapsibleSection title={t('abilities')}>
          <CheckRow label={t('astralSense')} cost={t('astralSenseCost')} checked={form.astralSense} onChange={v => set('astralSense', v)} />
          <CheckRow label={t('longArm')} cost={t('longArmCost')} checked={form.longArm} onChange={v => set('longArm', v)} />
          <CheckRow label={t('lifeSense')} cost={t('lifeSenseCost')} checked={form.lifeSense} onChange={v => set('lifeSense', v)} />

          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('regeneration')}</span>
            <select className={styles.select} value={form.regenerationLevel}
              onChange={e => set('regenerationLevel', Number(e.target.value) as 0|1|2)}>
              <option value={0}>{t('no')}</option>
              <option value={1}>{t('romanOne')}</option>
              <option value={2}>{t('romanTwo')}</option>
            </select>
          </div>

          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('additionalActions')}</span>
            <select className={styles.select} value={form.additionalActionsLevel}
              onChange={e => set('additionalActionsLevel', Number(e.target.value) as 0|1|2)}>
              <option value={0}>{t('no')}</option>
              <option value={1}>{t('romanOne')}</option>
              <option value={2}>{t('romanTwo')}</option>
            </select>
          </div>

          <CheckRow label={t('resistanceMagic')} cost="5 ZfP*" checked={form.resistanceMagic && !form.immunityMagic}
            onChange={v => { set('resistanceMagic', v); if (v) set('immunityMagic', false); }} />
          <CheckRow label={t('immunityMagic')} cost="10 ZfP*" checked={form.immunityMagic}
            onChange={v => { set('immunityMagic', v); if (v) set('resistanceMagic', false); }} />
          <CheckRow label={t('resistanceTraitDamage')} cost="5 ZfP*" checked={form.resistanceTraitDamage && !form.immunityTraitDamage}
            onChange={v => { set('resistanceTraitDamage', v); if (v) set('immunityTraitDamage', false); }} />
          <CheckRow label={t('immunityTraitDamage')} cost="10 ZfP*" checked={form.immunityTraitDamage}
            onChange={v => { set('immunityTraitDamage', v); if (v) set('resistanceTraitDamage', false); }} />
        </CollapsibleSection>

        {/* Special Properties */}
        <CollapsibleSection title={t('specialProperties')}>
          <CheckRow label={t('causeFear')} cost={t('causeFearCost')} checked={form.causeFear} onChange={v => set('causeFear', v)} />
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('artifactAnimation')}</span>
            <span className={styles.formCost}>{t('artifactAnimationCost')}</span>
            <Stepper value={form.artifactAnimationLevel} max={3} onChange={v => set('artifactAnimationLevel', v)} />
          </div>
          <CheckRow label={t('aura')} cost={t('auraCost')} checked={form.aura} onChange={v => set('aura', v)} />
          <CheckRow label={t('blinkingInvisibility')} cost={t('blinkingInvisibilityCost')} checked={form.blinkingInvisibility} onChange={v => set('blinkingInvisibility', v)} />
          <CheckRow label={t('elementalShackle')} cost={t('elementalShackleCost')} checked={form.elementalShackle} onChange={v => set('elementalShackle', v)} />
          <div className={styles.formRow}>
            <span className={styles.formLabel}>{t('elementalGrip')}</span>
            <span className={styles.formCost}>{t('elementalGripCost')}</span>
            <Stepper value={form.elementalGripLevel} max={3} onChange={v => set('elementalGripLevel', v)} />
          </div>
          <CheckRow label={t('elementalInferno')} cost={t('elementalInfernoCost')} checked={form.elementalInferno} onChange={v => set('elementalInferno', v)} />
          <CheckRow label={t('elementalGrowth')} cost={t('elementalGrowthCost')} checked={form.elementalGrowth} onChange={v => set('elementalGrowth', v)} />
          <CheckRow label={t('areaAttack')} cost={t('areaAttackCost')} checked={form.areaAttack} onChange={v => set('areaAttack', v)} />
          <CheckRow label={t('flight')} cost={t('flightCost')} checked={form.flight} onChange={v => set('flight', v)} />
          <CheckRow label={t('criticalImmunity')} cost={t('criticalImmunityCost')} checked={form.criticalImmunity} onChange={v => set('criticalImmunity', v)} />
          <CheckRow label={t('mergeWithElement')} cost={t('mergeWithElementCost')} checked={form.mergeWithElement} onChange={v => set('mergeWithElement', v)} />
          <CheckRow label={t('burst')} cost={t('burstCost')} checked={form.burst} onChange={v => set('burst', v)} />
        </CollapsibleSection>

        {/* Element-specific */}
        <CollapsibleSection title={t('elementSpecificProperties')}>
          {el === DsaElement.Water && <CheckRow label={t('drowning')} cost={t('drowningCost')} checked={form.drowning} onChange={v => set('drowning', v)} />}
          {(el === DsaElement.Water || el === DsaElement.Air) && <CheckRow label={t('fog')} cost={t('fogCost')} checked={form.fog} onChange={v => set('fog', v)} />}
          {(el === DsaElement.Fire || el === DsaElement.Air) && <CheckRow label={t('smoke')} cost={t('smokeCost')} checked={form.smoke} onChange={v => set('smoke', v)} />}
          {el === DsaElement.Ice && <CheckRow label={t('frost')} cost={t('frostCost')} checked={form.frost} onChange={v => set('frost', v)} />}
          {(el === DsaElement.Fire || el === DsaElement.Stone) && <CheckRow label={t('ember')} cost={t('emberCost')} checked={form.ember} onChange={v => set('ember', v)} />}
          {(el === DsaElement.Fire || el === DsaElement.Water) && <CheckRow label={t('boilingBlood')} cost={t('boilingBloodCost')} checked={form.boilingBlood} onChange={v => set('boilingBlood', v)} />}
          {(el === DsaElement.Stone || el === DsaElement.Ice || el === DsaElement.Life) && <CheckRow label={t('stasis')} cost={t('stasisCost')} checked={form.stasis} onChange={v => set('stasis', v)} />}
          {(el === DsaElement.Stone || el === DsaElement.Ice) && (
            <div className={styles.formRow}>
              <span className={styles.formLabel}>{t('stoneEating')}</span>
              <span className={styles.formCost}>{t('stoneEatingCost')}</span>
              <Stepper value={form.stoneEatingLevel} max={6} onChange={v => set('stoneEatingLevel', v)} />
            </div>
          )}
          {(el === DsaElement.Stone || el === DsaElement.Life) && (
            <div className={styles.formRow}>
              <span className={styles.formLabel}>{t('stoneSkin')}</span>
              <span className={styles.formCost}>{t('stoneSkinCost')}</span>
              <Stepper value={form.stoneSkinLevel} max={6} onChange={v => set('stoneSkinLevel', v)} />
            </div>
          )}
          {(el === DsaElement.Life || el === DsaElement.Water) && <CheckRow label={t('sinking')} cost={t('sinkingCost')} checked={form.sinking} onChange={v => set('sinking', v)} />}
          {el === DsaElement.Life && <CheckRow label={t('wildGrowth')} cost={t('wildGrowthCost')} checked={form.wildGrowth} onChange={v => set('wildGrowth', v)} />}
          {(el === DsaElement.Stone || el === DsaElement.Life || el === DsaElement.Fire || el === DsaElement.Ice) && <CheckRow label={t('shatteringArmor')} cost={t('shatteringArmorCost')} checked={form.shatteringArmor} onChange={v => set('shatteringArmor', v)} />}
        </CollapsibleSection>

        {/* Value Modifications */}
        <CollapsibleSection title={t('valueModifications')}>
          {([
            ['modLeP', 'modLeP', 'modLePCost'], ['modINI', 'modINI', 'modINICost'],
            ['modRS', 'modRS', 'modRSCost'], ['modGS', 'modGS', 'modGSCost'],
            ['modMR', 'modMR', 'modMRCost'], ['modAT', 'modAT', 'modATCost'],
            ['modPA', 'modPA', 'modPACost'], ['modTP', 'modTP', 'modTPCost'],
            ['modAttribute', 'modAttribute', 'modAttributeCost'],
            ['modNewTalent', 'modNewTalent', 'modNewTalentCost'],
            ['modTaWZfW', 'modTaWZfW', 'modTaWZfWCost'],
          ] as [keyof TmplForm, string, string][]).map(([key, labelKey, costKey]) => (
            <div key={key} className={styles.formRow}>
              <span className={styles.formLabel}>{t(labelKey)}</span>
              <span className={styles.formCost}>{t(costKey)}</span>
              <Stepper value={form[key] as number} max={20} onChange={v => set(key, v as never)} />
            </div>
          ))}
        </CollapsibleSection>

        {/* Resistances */}
        <CollapsibleSection title={t('resistances')}>
          {demonNames.map(demon => (
            <div key={demon} className={styles.resistanceItem}>
              <span className={styles.resistanceLabel}>{demon}</span>
              <div className={styles.resistanceBtns}>
                <button type="button" className={`${styles.resBtn} ${demonicRes[demon] ? styles.activeRes : ''}`}
                  onClick={() => updateDemonicRes(demon, !demonicRes[demon])}>{t('resistance')}</button>
                <button type="button" className={`${styles.resBtn} ${demonicImm[demon] ? styles.activeImm : ''}`}
                  onClick={() => updateDemonicImm(demon, !demonicImm[demon])}>{t('immunity')}</button>
              </div>
            </div>
          ))}
          {ALL_ELEMENTS.filter(e => e !== el).map(e => (
            <div key={e} className={styles.resistanceItem}>
              <span className={styles.resistanceLabel}>{elementLabel(e)}</span>
              <div className={styles.resistanceBtns}>
                <button type="button" className={`${styles.resBtn} ${eleRes[e] ? styles.activeRes : ''}`}
                  onClick={() => updateEleRes(e, !eleRes[e])}>{t('resistance')} (3)</button>
                <button type="button" className={`${styles.resBtn} ${eleImm[e] ? styles.activeImm : ''}`}
                  onClick={() => updateEleImm(e, !eleImm[e])}>{t('immunity')} (7)</button>
              </div>
            </div>
          ))}
        </CollapsibleSection>

      </div>

      {/* Save bar */}
      <div className={editStyles.saveBar}>
        <button type="button" className={editStyles.saveBtn} onClick={() => doSave()}>
          {t('save')}
        </button>
      </div>

      {/* Overwrite dialog */}
      {overwriteTarget && (
        <div className={editStyles.dialog}>
          <div className={editStyles.dialogBox}>
            <div className={editStyles.dialogTitle}>{t('overwriteTemplateTitle')}</div>
            <div className={editStyles.dialogMsg}>{t('overwriteTemplateMessage')}</div>
            <div className={editStyles.dialogBtns}>
              <button type="button" className={editStyles.dialogBtn}
                onClick={() => setOverwriteTarget(null)}>{t('cancel')}</button>
              <button type="button" className={`${editStyles.dialogBtn} ${editStyles.dialogBtnPrimary}`}
                onClick={() => { setOverwriteTarget(null); doSave(overwriteTarget.id); }}>{t('overwrite')}</button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
