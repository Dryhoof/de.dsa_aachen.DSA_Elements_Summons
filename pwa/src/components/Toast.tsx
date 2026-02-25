import { createContext, useContext, useState, useCallback, ReactNode } from 'react';
import styles from './Toast.module.css';

interface ToastItem {
  id: number;
  message: string;
  type?: 'success' | 'error' | 'default';
  action?: { label: string; onClick: () => void };
}

interface ToastContextType {
  showToast: (message: string, opts?: { type?: ToastItem['type']; action?: ToastItem['action']; duration?: number }) => void;
}

const ToastContext = createContext<ToastContextType | null>(null);

let nextId = 0;

export function ToastProvider({ children }: { children: ReactNode }) {
  const [toasts, setToasts] = useState<ToastItem[]>([]);

  const showToast = useCallback((
    message: string,
    opts?: { type?: ToastItem['type']; action?: ToastItem['action']; duration?: number }
  ) => {
    const id = ++nextId;
    const item: ToastItem = { id, message, type: opts?.type, action: opts?.action };
    setToasts(t => [...t, item]);
    setTimeout(() => {
      setToasts(t => t.filter(x => x.id !== id));
    }, opts?.duration ?? 3500);
  }, []);

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
      <div className={styles.container}>
        {toasts.map(t => (
          <div key={t.id} className={`${styles.toast} ${t.type ? styles[t.type] : ''}`}>
            <span>{t.message}</span>
            {t.action && (
              <button type="button" className={styles.action} onClick={t.action.onClick}>
                {t.action.label}
              </button>
            )}
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast(): ToastContextType {
  const ctx = useContext(ToastContext);
  if (!ctx) throw new Error('useToast must be used inside ToastProvider');
  return ctx;
}
