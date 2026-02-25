import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Layout } from '../../components/Layout';
import { useToast } from '../../components/Toast';
import { getAllCharacters, deleteCharacter, insertCharacter } from '../../core/db/database';
import { Character, CharacterClass } from '../../core/models/character';
import { setLanguage } from '../../core/i18n';
import styles from './HomePage.module.css';

const CLASS_KEYS: Record<CharacterClass, string> = {
  [CharacterClass.Mage]: 'classMage',
  [CharacterClass.Druid]: 'classDruid',
  [CharacterClass.Geode]: 'classGeode',
  [CharacterClass.Cristalomant]: 'classCristalomant',
  [CharacterClass.Shaman]: 'classShaman',
};

const CLASS_ICONS: Record<CharacterClass, string> = {
  [CharacterClass.Mage]: '🧙',
  [CharacterClass.Druid]: '🌿',
  [CharacterClass.Geode]: '💎',
  [CharacterClass.Cristalomant]: '🔮',
  [CharacterClass.Shaman]: '🪄',
};

export function HomePage() {
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();
  const { showToast } = useToast();

  const [characters, setCharacters] = useState<Character[]>([]);
  const [selectedChar, setSelectedChar] = useState<Character | null>(null);

  function loadCharacters() {
    getAllCharacters().then(setCharacters);
  }

  useEffect(() => { loadCharacters(); }, []);

  async function handleDelete(char: Character) {
    if (!char.id) return;
    const copy = { ...char };
    await deleteCharacter(char.id);
    loadCharacters();
    setSelectedChar(null);
    showToast(t('characterDeleted'), {
      action: {
        label: t('undo'),
        onClick: async () => {
          const { id: _id, ...rest } = copy;
          await insertCharacter(rest);
          loadCharacters();
        },
      },
    });
  }

  const lang = i18n.language.startsWith('de') ? 'de' : 'en';

  return (
    <Layout
      title={t('appTitle')}
      actions={
        <div className={styles.langSwitcher}>
          <button
            type="button"
            className={`${styles.langBtn} ${lang === 'de' ? styles.active : ''}`}
            onClick={() => setLanguage('de')}
          >DE</button>
          <button
            type="button"
            className={`${styles.langBtn} ${lang === 'en' ? styles.active : ''}`}
            onClick={() => setLanguage('en')}
          >EN</button>
        </div>
      }
    >
      <div className={styles.page}>
        {characters.length === 0 ? (
          <div className={styles.emptyState}>
            <span className={styles.emptyIcon}>⚗️</span>
            <p className={styles.emptyText}>{t('noCharacters')}</p>
          </div>
        ) : (
          <div className={styles.list}>
            {characters.map(char => (
              <div
                key={char.id}
                className={styles.characterCard}
                onClick={() => setSelectedChar(char)}
              >
                <div className={styles.characterAvatar}>
                  {CLASS_ICONS[char.characterClass as CharacterClass] ?? '🧙'}
                </div>
                <div className={styles.characterInfo}>
                  <div className={styles.characterName}>{char.characterName}</div>
                  <div className={styles.characterClass}>{t(CLASS_KEYS[char.characterClass as CharacterClass])}</div>
                </div>
                <span className={styles.chevron}>›</span>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* FAB */}
      <button
        type="button"
        className={styles.fab}
        onClick={() => navigate('/character/new')}
        aria-label={t('newCharacter')}
      >
        +
      </button>

      {/* Bottom Sheet */}
      {selectedChar && (
        <div className={styles.overlay} onClick={() => setSelectedChar(null)}>
          <div className={styles.sheet} onClick={e => e.stopPropagation()}>
            <div className={styles.sheetHandle} />
            <div className={styles.sheetTitle}>{selectedChar.characterName}</div>

            <button
              type="button"
              className={styles.sheetAction}
              onClick={() => {
                setSelectedChar(null);
                navigate(`/summon/${selectedChar.id}`);
              }}
            >
              <span className={styles.sheetActionIcon}>⚡</span>
              {t('summonElemental')}
            </button>

            <button
              type="button"
              className={styles.sheetAction}
              onClick={() => {
                setSelectedChar(null);
                navigate(`/character/${selectedChar.id}`);
              }}
            >
              <span className={styles.sheetActionIcon}>✏️</span>
              {t('edit')}
            </button>

            <button
              type="button"
              className={styles.sheetAction}
              onClick={() => {
                setSelectedChar(null);
                navigate(`/character/${selectedChar.id}/elementals`);
              }}
            >
              <span className={styles.sheetActionIcon}>📋</span>
              {t('elementalTemplates')}
            </button>

            <button
              type="button"
              className={`${styles.sheetAction} ${styles.sheetActionDanger}`}
              onClick={() => handleDelete(selectedChar)}
            >
              <span className={styles.sheetActionIcon}>🗑</span>
              {t('deleteCharacter')}
            </button>
          </div>
        </div>
      )}
    </Layout>
  );
}
