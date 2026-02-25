import styles from './ModifierRow.module.css';

interface ModifierRowProps {
  label: string;
  cost?: string;
  value: number;
  min?: number;
  max?: number;
  onChange: (v: number) => void;
  disabled?: boolean;
}

export function ModifierRow({ label, cost, value, min = 0, max = 99, onChange, disabled }: ModifierRowProps) {
  return (
    <div className={styles.row}>
      <span className={styles.label}>{label}</span>
      {cost && <span className={styles.cost}>{cost}</span>}
      <div className={styles.controls}>
        <button
          type="button"
          className={styles.btn}
          onClick={() => onChange(Math.max(min, value - 1))}
          disabled={disabled || value <= min}
        >
          −
        </button>
        <span className={styles.value}>{value}</span>
        <button
          type="button"
          className={styles.btn}
          onClick={() => onChange(Math.min(max, value + 1))}
          disabled={disabled || value >= max}
        >
          +
        </button>
      </div>
    </div>
  );
}
