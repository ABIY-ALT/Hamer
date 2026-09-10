// ─────────────────────────────────────────────────────────────────────────────
// Utility helpers
// ─────────────────────────────────────────────────────────────────────────────

import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

/** Merge Tailwind classes safely */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/** Format ISO date string to readable date */
export function formatDate(iso: string | null | undefined, locale: 'en' | 'am' = 'en'): string {
  if (!iso) return '—';
  const d = new Date(iso);
  return d.toLocaleDateString(locale === 'am' ? 'am-ET' : 'en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

/** Format ISO date to short form */
export function formatDateShort(iso: string | null | undefined): string {
  if (!iso) return '—';
  const d = new Date(iso);
  return d.toLocaleDateString('en-GB'); // DD/MM/YYYY
}

/** Generate initials from a name */
export function getInitials(name: string): string {
  return name
    .split(' ')
    .slice(0, 2)
    .map((n) => n[0])
    .join('')
    .toUpperCase();
}

/** Truncate text */
export function truncate(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text;
  return `${text.slice(0, maxLength)}…`;
}

/** Gender label */
export function genderLabel(gender: 'MALE' | 'FEMALE', locale: 'en' | 'am' = 'en'): string {
  if (locale === 'am') return gender === 'MALE' ? 'ወንድ' : 'ሴት';
  return gender === 'MALE' ? 'Male' : 'Female';
}

/** Status badge color mapping */
export function statusColor(status: string): string {
  const map: Record<string, string> = {
    ACTIVE: 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-400',
    INACTIVE: 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-400',
    SUSPENDED: 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400',
    TRANSFERRED: 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
    DECEASED: 'bg-slate-200 text-slate-600',
    PENDING: 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
    APPROVED: 'bg-emerald-100 text-emerald-800',
    REJECTED: 'bg-red-100 text-red-700',
    DRAFT: 'bg-slate-100 text-slate-600',
    COMPLETED: 'bg-blue-100 text-blue-700',
    EXPIRED: 'bg-orange-100 text-orange-700',
  };
  return map[status] ?? 'bg-slate-100 text-slate-600';
}

/** Format membership code */
export function formatMemberCode(code: string): string {
  return code; // already formatted as MBR-YYYY-XXXX
}

/** Safe JSON parse */
export function safeJsonParse<T>(json: string | null | undefined, fallback: T): T {
  if (!json) return fallback;
  try {
    return JSON.parse(json) as T;
  } catch {
    return fallback;
  }
}
