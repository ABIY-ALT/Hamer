// ─────────────────────────────────────────────────────────────────────────────
// Language Context — English / Amharic localization
// ─────────────────────────────────────────────────────────────────────────────

'use client';

import React, { createContext, useContext, useState, useCallback } from 'react';
import type { Locale } from '@/types';

interface LangContextValue {
  locale: Locale;
  setLocale: (locale: Locale) => void;
  t: (en: string, am: string) => string;
  /** Resolve a localized name from an object with name_en and name_am */
  ln: (obj: { name_en: string; name_am: string | null } | null | undefined) => string;
}

const LangContext = createContext<LangContextValue | null>(null);

export function LangProvider({
  children,
  defaultLocale = 'en',
}: {
  children: React.ReactNode;
  defaultLocale?: Locale;
}) {
  const [locale, setLocaleState] = useState<Locale>(() => {
    if (typeof window !== 'undefined') {
      return (localStorage.getItem('ssms_locale') as Locale) || defaultLocale;
    }
    return defaultLocale;
  });

  const setLocale = useCallback((l: Locale) => {
    setLocaleState(l);
    if (typeof window !== 'undefined') {
      localStorage.setItem('ssms_locale', l);
    }
  }, []);

  const t = useCallback(
    (en: string, am: string) => (locale === 'am' ? am : en),
    [locale]
  );

  const ln = useCallback(
    (obj: { name_en: string; name_am: string | null } | null | undefined) => {
      if (!obj) return '';
      if (locale === 'am' && obj.name_am) return obj.name_am;
      return obj.name_en;
    },
    [locale]
  );

  return (
    <LangContext.Provider value={{ locale, setLocale, t, ln }}>
      {children}
    </LangContext.Provider>
  );
}

export function useLang(): LangContextValue {
  const ctx = useContext(LangContext);
  if (!ctx) throw new Error('useLang must be used within LangProvider');
  return ctx;
}
