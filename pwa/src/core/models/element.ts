export enum DsaElement {
  Fire = 0,
  Water = 1,
  Life = 2,
  Ice = 3,
  Stone = 4,
  Air = 5,
}

export const ELEMENT_COUNTER: Record<DsaElement, DsaElement> = {
  [DsaElement.Fire]: DsaElement.Water,
  [DsaElement.Water]: DsaElement.Fire,
  [DsaElement.Life]: DsaElement.Ice,
  [DsaElement.Ice]: DsaElement.Life,
  [DsaElement.Stone]: DsaElement.Air,
  [DsaElement.Air]: DsaElement.Stone,
};

export function getCounterElement(el: DsaElement): DsaElement {
  return ELEMENT_COUNTER[el];
}

export const ALL_ELEMENTS: DsaElement[] = [
  DsaElement.Fire,
  DsaElement.Water,
  DsaElement.Life,
  DsaElement.Ice,
  DsaElement.Stone,
  DsaElement.Air,
];

/** CSS class name suffix per element for theming */
export const ELEMENT_CLASS: Record<DsaElement, string> = {
  [DsaElement.Fire]: 'fire',
  [DsaElement.Water]: 'water',
  [DsaElement.Life]: 'life',
  [DsaElement.Ice]: 'ice',
  [DsaElement.Stone]: 'stone',
  [DsaElement.Air]: 'air',
};
