import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Layout } from '../../components/Layout';
import { useToast } from '../../components/Toast';
import {
  getCharacterById,
  insertCharacter,
  updateCharacter,
  getAllCharacters,
} from '../../core/db/database';
import { Character, CharacterClass, DEFAULT_CHARACTER } from '../../core/models/character';
import styles from './CharacterEditPage.module.css';

type CharForm = Omit<Character, 'id'>;

function Stepper({
  value, min = 0, max = 99, onChange, disabled
}: { value: number; min?: number; max?: number; onChange: (v: number) => void; disabled?: boolean }) {
  return (
    <div className={styles.stepper}>
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

interface CheckRowProps {
  label: string;
  checked: boolean;
  onChange: (v: boolean) => void;
}

function CheckRow({ label, checked, onChange }: CheckRowProps) {
  return (
    <label className={styles.checkLabel}>
      <input type="checkbox" checked={checked} onChange={e => onChange(e.target.checked)} />
      <span className={styles.checkbox}>
        <span className={styles.checkmark}>✓</span>
      </span>
      {label}
    </label>
  );
}

export function CharacterEditPage() {
  const { id } = useParams<{ id?: string }>();
  const isNew = !id;
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { showToast } = useToast();

  const [form, setForm] = useState<CharForm>({ ...DEFAULT_CHARACTER });
  const [isDirty, setIsDirty] = useState(false);
  const [nameError, setNameError] = useState('');
  const [showUnsavedDialog, setShowUnsavedDialog] = useState(false);
  const [showOverwriteDialog, setShowOverwriteDialog] = useState(false);
  const [overwriteTarget, setOverwriteTarget] = useState<Character | null>(null);

  useEffect(() => {
    if (!isNew && id) {
      getCharacterById(Number(id)).then(char => {
        if (char) {
          const { id: _id, ...rest } = char;
          setForm(rest);
        }
      });
    }
  }, [id, isNew]);

  function set<K extends keyof CharForm>(key: K, value: CharForm[K]) {
    setForm(f => ({ ...f, [key]: value }));
    setIsDirty(true);
  }

  async function doSave(overwriteId?: number) {
    if (!form.characterName.trim()) {
      setNameError(t('errorCharName'));
      return;
    }
    setNameError('');

    if (overwriteId) {
      await updateCharacter({ ...form, id: overwriteId });
      showToast(t('templateSaved'));
      navigate(-1);
      return;
    }

    // Check for name conflict
    const all = await getAllCharacters();
    const existing = all.find(
      c => c.characterName === form.characterName.trim() && c.id !== Number(id)
    );
    if (existing) {
      setOverwriteTarget(existing);
      setShowOverwriteDialog(true);
      return;
    }

    if (isNew) {
      await insertCharacter(form);
    } else {
      await updateCharacter({ ...form, id: Number(id) });
    }
    setIsDirty(false);
    navigate(-1);
  }

  function handleBack() {
    if (isDirty) {
      setShowUnsavedDialog(true);
    } else {
      navigate(-1);
    }
  }

  const classOptions = [
    { value: CharacterClass.Mage, label: t('classMage') },
    { value: CharacterClass.Druid, label: t('classDruid') },
    { value: CharacterClass.Geode, label: t('classGeode') },
    { value: CharacterClass.Cristalomant, label: t('classCristalomant') },
    { value: CharacterClass.Shaman, label: t('classShaman') },
  ];

  return (
    <Layout
      title={isNew ? t('createCharacter') : t('editCharacter')}
      showBack
      onBack={handleBack}
    >
      <div className={styles.form}>
        {/* Name */}
        <div className={styles.field}>
          <label className={styles.label}>{t('characterName')}</label>
          <input
            className={styles.input}
            type="text"
            value={form.characterName}
            onChange={e => set('characterName', e.target.value)}
            placeholder={t('characterName')}
          />
          {nameError && <span className={styles.errorText}>{nameError}</span>}
        </div>

        {/* Class */}
        <div className={styles.field}>
          <label className={styles.label}>{t('characterClass')}</label>
          <select
            className={styles.select}
            value={form.characterClass}
            onChange={e => set('characterClass', Number(e.target.value))}
          >
            {classOptions.map(o => (
              <option key={o.value} value={o.value}>{o.label}</option>
            ))}
          </select>
        </div>

        {/* Attributes */}
        <div className={styles.section}>
          <div className={styles.sectionTitle}>{t('attributes')}</div>
          <div className={styles.sectionBody}>
            {([
              ['statCourage', 'statCourage'],
              ['statWisdom', 'statWisdom'],
              ['statCharisma', 'statCharisma'],
              ['statIntuition', 'statIntuition'],
            ] as [keyof CharForm, string][]).map(([key, labelKey]) => (
              <div key={key} className={styles.row}>
                <span className={styles.rowLabel}>{t(labelKey)}</span>
                <Stepper
                  value={form[key] as number}
                  min={1}
                  max={25}
                  onChange={v => set(key, v)}
                />
              </div>
            ))}
          </div>
        </div>

        {/* Talents */}
        <div className={styles.section}>
          <div className={styles.sectionTitle}>{t('talents')}</div>
          <div className={styles.sectionBody}>
            {([
              ['talentCallElementalServant', 'talentCallElementalServant'],
              ['talentCallDjinn', 'talentCallDjinn'],
              ['talentCallMasterOfElement', 'talentCallMasterOfElement'],
            ] as [keyof CharForm, string][]).map(([key, labelKey]) => (
              <div key={key} className={styles.row}>
                <span className={styles.rowLabel}>{t(labelKey)}</span>
                <Stepper
                  value={form[key] as number}
                  min={-20}
                  max={25}
                  onChange={v => set(key, v)}
                />
              </div>
            ))}
          </div>
        </div>

        {/* Talented for elements */}
        <div className={styles.section}>
          <div className={styles.sectionTitle}>{t('talentedFor')}</div>
          <div className={styles.sectionBody}>
            {([
              ['talentedFire', 'elementFire'],
              ['talentedWater', 'elementWater'],
              ['talentedLife', 'elementLife'],
              ['talentedIce', 'elementIce'],
              ['talentedStone', 'elementStone'],
              ['talentedAir', 'elementAir'],
            ] as [keyof CharForm, string][]).map(([key, labelKey]) => (
              <CheckRow
                key={key}
                label={t(labelKey)}
                checked={form[key] as boolean}
                onChange={v => set(key, v)}
              />
            ))}
            <div className={styles.row}>
              <span className={styles.rowLabel}>{t('talentedDemonic')}</span>
              <Stepper
                value={form.talentedDemonic}
                min={0}
                max={10}
                onChange={v => set('talentedDemonic', v)}
              />
            </div>
          </div>
        </div>

        {/* Knowledge of attribute */}
        <div className={styles.section}>
          <div className={styles.sectionTitle}>{t('knowledgeOfAttribute')}</div>
          <div className={styles.sectionBody}>
            {([
              ['knowledgeFire', 'elementFire'],
              ['knowledgeWater', 'elementWater'],
              ['knowledgeLife', 'elementLife'],
              ['knowledgeIce', 'elementIce'],
              ['knowledgeStone', 'elementStone'],
              ['knowledgeAir', 'elementAir'],
            ] as [keyof CharForm, string][]).map(([key, labelKey]) => (
              <CheckRow
                key={key}
                label={t(labelKey)}
                checked={form[key] as boolean}
                onChange={v => set(key, v)}
              />
            ))}
            <div className={styles.row}>
              <span className={styles.rowLabel}>{t('knowledgeDemonic')}</span>
              <Stepper
                value={form.knowledgeDemonic}
                min={0}
                max={10}
                onChange={v => set('knowledgeDemonic', v)}
              />
            </div>
          </div>
        </div>

        {/* Special characteristics */}
        <div className={styles.section}>
          <div className={styles.sectionTitle}>{t('specialCharacteristics')}</div>
          <div className={styles.sectionBody}>
            {([
              ['affinityToElementals', 'affinityToElementals'],
              ['demonicCovenant', 'demonicCovenant'],
              ['cloakedAura', 'cloakedAura'],
              ['powerlineMagicI', 'powerlineMagicI'],
            ] as [keyof CharForm, string][]).map(([key, labelKey]) => (
              <CheckRow
                key={key}
                label={t(labelKey)}
                checked={form[key] as boolean}
                onChange={v => set(key, v)}
              />
            ))}
            <div className={styles.row}>
              <span className={styles.rowLabel}>{t('weakPresence')}</span>
              <Stepper
                value={form.weakPresence}
                min={0}
                max={5}
                onChange={v => set('weakPresence', v)}
              />
            </div>
            <div className={styles.row}>
              <span className={styles.rowLabel}>{t('strengthOfStigma')}</span>
              <Stepper
                value={form.strengthOfStigma}
                min={0}
                max={3}
                onChange={v => set('strengthOfStigma', v)}
              />
            </div>
          </div>
        </div>
      </div>

      {/* Save bar */}
      <div className={styles.saveBar}>
        <button type="button" className={styles.saveBtn} onClick={() => doSave()}>
          {t('saveCharacter')}
        </button>
      </div>

      {/* Unsaved changes dialog */}
      {showUnsavedDialog && (
        <div className={styles.dialog}>
          <div className={styles.dialogBox}>
            <div className={styles.dialogTitle}>{t('unsavedChangesTitle')}</div>
            <div className={styles.dialogMsg}>{t('unsavedChangesMessage')}</div>
            <div className={styles.dialogBtns}>
              <button type="button" className={styles.dialogBtn}
                onClick={() => setShowUnsavedDialog(false)}>{t('cancel')}</button>
              <button type="button" className={`${styles.dialogBtn} ${styles.dialogBtnDanger}`}
                onClick={() => navigate(-1)}>{t('discard')}</button>
              <button type="button" className={`${styles.dialogBtn} ${styles.dialogBtnPrimary}`}
                onClick={() => { setShowUnsavedDialog(false); doSave(); }}>{t('save')}</button>
            </div>
          </div>
        </div>
      )}

      {/* Overwrite dialog */}
      {showOverwriteDialog && overwriteTarget && (
        <div className={styles.dialog}>
          <div className={styles.dialogBox}>
            <div className={styles.dialogTitle}>{t('overwriteCharacterTitle')}</div>
            <div className={styles.dialogMsg}>{t('overwriteCharacterMessage')}</div>
            <div className={styles.dialogBtns}>
              <button type="button" className={styles.dialogBtn}
                onClick={() => { setShowOverwriteDialog(false); setOverwriteTarget(null); }}>{t('cancel')}</button>
              <button type="button" className={`${styles.dialogBtn} ${styles.dialogBtnPrimary}`}
                onClick={() => { setShowOverwriteDialog(false); doSave(overwriteTarget.id); }}>{t('overwrite')}</button>
            </div>
          </div>
        </div>
      )}
    </Layout>
  );
}
