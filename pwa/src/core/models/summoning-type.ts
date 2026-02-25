export enum SummoningType {
  Servant = 0,
  Djinn = 1,
  Master = 2,
}

export const SUMMONING_TYPE_COSTS: Record<SummoningType, { summon: number; control: number }> = {
  [SummoningType.Servant]: { summon: 4, control: 2 },
  [SummoningType.Djinn]: { summon: 8, control: 4 },
  [SummoningType.Master]: { summon: 12, control: 8 },
};
