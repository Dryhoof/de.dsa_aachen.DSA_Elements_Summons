import { describe, it, expect } from 'vitest';
import {
  DsaElement,
  ELEMENT_COUNTER,
  getCounterElement,
  ALL_ELEMENTS,
  ELEMENT_CLASS,
} from '../element';

describe('DsaElement enum', () => {
  it('has exactly 6 members', () => {
    const values = Object.values(DsaElement).filter(v => typeof v === 'number');
    expect(values).toHaveLength(6);
  });

  it('has numeric values 0-5', () => {
    expect(DsaElement.Fire).toBe(0);
    expect(DsaElement.Water).toBe(1);
    expect(DsaElement.Life).toBe(2);
    expect(DsaElement.Ice).toBe(3);
    expect(DsaElement.Stone).toBe(4);
    expect(DsaElement.Air).toBe(5);
  });
});

describe('getCounterElement', () => {
  it('Fire counter is Water', () => {
    expect(getCounterElement(DsaElement.Fire)).toBe(DsaElement.Water);
  });

  it('Water counter is Fire', () => {
    expect(getCounterElement(DsaElement.Water)).toBe(DsaElement.Fire);
  });

  it('Life counter is Ice', () => {
    expect(getCounterElement(DsaElement.Life)).toBe(DsaElement.Ice);
  });

  it('Ice counter is Life', () => {
    expect(getCounterElement(DsaElement.Ice)).toBe(DsaElement.Life);
  });

  it('Stone counter is Air', () => {
    expect(getCounterElement(DsaElement.Stone)).toBe(DsaElement.Air);
  });

  it('Air counter is Stone', () => {
    expect(getCounterElement(DsaElement.Air)).toBe(DsaElement.Stone);
  });

  it('counter relationship is symmetric for all elements', () => {
    for (const el of ALL_ELEMENTS) {
      const counter = getCounterElement(el);
      expect(getCounterElement(counter)).toBe(el);
    }
  });

  it('no element is its own counter', () => {
    for (const el of ALL_ELEMENTS) {
      expect(getCounterElement(el)).not.toBe(el);
    }
  });
});

describe('ELEMENT_COUNTER record', () => {
  it('contains entries for all 6 elements', () => {
    expect(Object.keys(ELEMENT_COUNTER)).toHaveLength(6);
  });

  it('all counter values are valid DsaElement values', () => {
    for (const el of ALL_ELEMENTS) {
      const counter = ELEMENT_COUNTER[el];
      expect(ALL_ELEMENTS).toContain(counter);
    }
  });
});

describe('ALL_ELEMENTS', () => {
  it('contains all 6 elements', () => {
    expect(ALL_ELEMENTS).toHaveLength(6);
  });

  it('contains each element exactly once', () => {
    const unique = new Set(ALL_ELEMENTS);
    expect(unique.size).toBe(6);
  });

  it('includes Fire, Water, Life, Ice, Stone, Air', () => {
    expect(ALL_ELEMENTS).toContain(DsaElement.Fire);
    expect(ALL_ELEMENTS).toContain(DsaElement.Water);
    expect(ALL_ELEMENTS).toContain(DsaElement.Life);
    expect(ALL_ELEMENTS).toContain(DsaElement.Ice);
    expect(ALL_ELEMENTS).toContain(DsaElement.Stone);
    expect(ALL_ELEMENTS).toContain(DsaElement.Air);
  });
});

describe('ELEMENT_CLASS', () => {
  it('has a CSS class name for each element', () => {
    for (const el of ALL_ELEMENTS) {
      expect(typeof ELEMENT_CLASS[el]).toBe('string');
      expect(ELEMENT_CLASS[el].length).toBeGreaterThan(0);
    }
  });

  it('Fire class is "fire"', () => {
    expect(ELEMENT_CLASS[DsaElement.Fire]).toBe('fire');
  });

  it('Water class is "water"', () => {
    expect(ELEMENT_CLASS[DsaElement.Water]).toBe('water');
  });

  it('Life class is "life"', () => {
    expect(ELEMENT_CLASS[DsaElement.Life]).toBe('life');
  });

  it('Ice class is "ice"', () => {
    expect(ELEMENT_CLASS[DsaElement.Ice]).toBe('ice');
  });

  it('Stone class is "stone"', () => {
    expect(ELEMENT_CLASS[DsaElement.Stone]).toBe('stone');
  });

  it('Air class is "air"', () => {
    expect(ELEMENT_CLASS[DsaElement.Air]).toBe('air');
  });
});
