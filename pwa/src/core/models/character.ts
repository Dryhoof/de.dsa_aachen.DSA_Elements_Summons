export interface Character {
  id?: number;
  characterName: string;
  characterClass: number; // CharacterClass enum index 0-4
  statCourage: number;
  statWisdom: number;
  statCharisma: number;
  statIntuition: number;
  talentCallElementalServant: number;
  talentCallDjinn: number;
  talentCallMasterOfElement: number;
  talentedFire: boolean;
  talentedWater: boolean;
  talentedLife: boolean;
  talentedIce: boolean;
  talentedStone: boolean;
  talentedAir: boolean;
  talentedDemonic: number;
  knowledgeFire: boolean;
  knowledgeWater: boolean;
  knowledgeLife: boolean;
  knowledgeIce: boolean;
  knowledgeStone: boolean;
  knowledgeAir: boolean;
  knowledgeDemonic: number;
  affinityToElementals: boolean;
  demonicCovenant: boolean;
  cloakedAura: boolean;
  weakPresence: number; // 0-5
  strengthOfStigma: number; // 0-3
  powerlineMagicI: boolean;
}

export const DEFAULT_CHARACTER: Omit<Character, 'id'> = {
  characterName: '',
  characterClass: 0,
  statCourage: 0,
  statWisdom: 0,
  statCharisma: 0,
  statIntuition: 0,
  talentCallElementalServant: 0,
  talentCallDjinn: 0,
  talentCallMasterOfElement: 0,
  talentedFire: false,
  talentedWater: false,
  talentedLife: false,
  talentedIce: false,
  talentedStone: false,
  talentedAir: false,
  talentedDemonic: 0,
  knowledgeFire: false,
  knowledgeWater: false,
  knowledgeLife: false,
  knowledgeIce: false,
  knowledgeStone: false,
  knowledgeAir: false,
  knowledgeDemonic: 0,
  affinityToElementals: false,
  demonicCovenant: false,
  cloakedAura: false,
  weakPresence: 0,
  strengthOfStigma: 0,
  powerlineMagicI: false,
};

export enum CharacterClass {
  Mage = 0,
  Druid = 1,
  Geode = 2,
  Cristalomant = 3,
  Shaman = 4,
}
