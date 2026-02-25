import { DsaElement } from './element';
import { SummoningType } from './summoning-type';

export interface SummoningResult {
  summonDifficulty: number;
  controlDifficulty: number;
  personality: string;
  element: DsaElement;
  summoningType: SummoningType;
}
