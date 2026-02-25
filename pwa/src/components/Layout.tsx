import { ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';
import styles from './Layout.module.css';

interface LayoutProps {
  title: string;
  showBack?: boolean;
  onBack?: () => void;
  actions?: ReactNode;
  children: ReactNode;
}

export function Layout({ title, showBack, onBack, actions, children }: LayoutProps) {
  const navigate = useNavigate();

  function handleBack() {
    if (onBack) {
      onBack();
    } else {
      navigate(-1);
    }
  }

  return (
    <div className={styles.layout}>
      <header className={styles.header}>
        {showBack && (
          <button className={styles.backBtn} onClick={handleBack} aria-label="Back">
            ←
          </button>
        )}
        <h1 className={styles.title}>{title}</h1>
        {actions && <div className={styles.actions}>{actions}</div>}
      </header>
      <main className={styles.content}>{children}</main>
    </div>
  );
}
