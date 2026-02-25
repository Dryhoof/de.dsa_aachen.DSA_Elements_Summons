import { ReactNode, useState } from 'react';
import styles from './CollapsibleSection.module.css';

interface CollapsibleSectionProps {
  title: string;
  defaultOpen?: boolean;
  children: ReactNode;
}

export function CollapsibleSection({ title, defaultOpen = false, children }: CollapsibleSectionProps) {
  const [open, setOpen] = useState(defaultOpen);

  return (
    <div className={styles.section}>
      <button
        type="button"
        className={styles.header}
        onClick={() => setOpen(v => !v)}
        aria-expanded={open}
      >
        <span className={styles.headerTitle}>{title}</span>
        <span className={`${styles.chevron} ${open ? styles.chevronOpen : ''}`}>▼</span>
      </button>
      {open && (
        <div className={styles.body}>
          <div className={styles.bodyInner}>
            {children}
          </div>
        </div>
      )}
    </div>
  );
}
