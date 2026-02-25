import Dexie, { Table } from 'dexie';
import { Character } from '../models/character';
import { ElementalTemplate } from '../models/elemental-template';

export interface HiddenPredefinedSummoning {
  characterId: number;
  predefinedId: string;
}

class AppDatabase extends Dexie {
  characters!: Table<Character, number>;
  elementalTemplates!: Table<ElementalTemplate, number>;
  hiddenPredefinedSummonings!: Table<HiddenPredefinedSummoning, [number, string]>;

  constructor() {
    super('DsaElementsSummons');

    this.version(1).stores({
      characters: '++id, characterName',
      elementalTemplates: '++id, characterId, templateName',
      hiddenPredefinedSummonings: '[characterId+predefinedId], characterId',
    });
  }
}

export const db = new AppDatabase();

// ─── Characters ──────────────────────────────────────────────────────────────

export async function getAllCharacters(): Promise<Character[]> {
  return db.characters.toArray();
}

export async function getCharacterById(id: number): Promise<Character | undefined> {
  return db.characters.get(id);
}

export async function insertCharacter(char: Omit<Character, 'id'>): Promise<number> {
  return db.characters.add(char as Character);
}

export async function updateCharacter(char: Character): Promise<void> {
  await db.characters.put(char);
}

export async function deleteCharacter(id: number): Promise<void> {
  await db.transaction('rw', [db.characters, db.elementalTemplates, db.hiddenPredefinedSummonings], async () => {
    await db.characters.delete(id);
    await db.elementalTemplates.where('characterId').equals(id).delete();
    await db.hiddenPredefinedSummonings.where('characterId').equals(id).delete();
  });
}

// ─── Elemental Templates ──────────────────────────────────────────────────────

export async function getTemplatesForCharacter(charId: number): Promise<ElementalTemplate[]> {
  return db.elementalTemplates.where('characterId').equals(charId).toArray();
}

export async function getTemplateById(id: number): Promise<ElementalTemplate | undefined> {
  return db.elementalTemplates.get(id);
}

export async function insertTemplate(template: Omit<ElementalTemplate, 'id'>): Promise<number> {
  return db.elementalTemplates.add(template as ElementalTemplate);
}

export async function updateTemplate(template: ElementalTemplate): Promise<void> {
  await db.elementalTemplates.put(template);
}

export async function deleteTemplate(id: number): Promise<void> {
  await db.elementalTemplates.delete(id);
}

// ─── Hidden Predefined Summonings ─────────────────────────────────────────────

export async function hidePredefined(characterId: number, predefinedId: string): Promise<void> {
  await db.hiddenPredefinedSummonings.put({ characterId, predefinedId });
}

export async function unhidePredefined(characterId: number, predefinedId: string): Promise<void> {
  await db.hiddenPredefinedSummonings.delete([characterId, predefinedId]);
}

export async function getHiddenPredefinedIds(characterId: number): Promise<string[]> {
  const rows = await db.hiddenPredefinedSummonings.where('characterId').equals(characterId).toArray();
  return rows.map(r => r.predefinedId);
}
