'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Church, Eye, EyeOff, LogIn, AlertCircle } from 'lucide-react';
import { cn } from '@/lib/utils';

// Demo credentials (mock mode)
const DEMO_CREDENTIALS = [
  { username: 'admin', password: 'admin123', label: 'Super Admin', labelAm: 'ዋና አስተዳዳሪ' },
  { username: 'board_chair', password: 'board123', label: 'Board Officer', labelAm: 'የሥራ አመራር ኃላፊ' },
  { username: 'audit_inspector', password: 'audit123', label: 'Audit Inspector', labelAm: 'ኦዲት ተቆጣጣሪ' },
];

export default function LoginForm() {
  const router = useRouter();
  const [locale, setLocale] = useState<'en' | 'am'>('en');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPw, setShowPw] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const t = (en: string, am: string) => (locale === 'am' ? am : en);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    // Simulate auth delay
    await new Promise((r) => setTimeout(r, 800));

    // Mock auth check
    const isMock = process.env.NEXT_PUBLIC_USE_MOCK_DATA === 'true';
    if (isMock) {
      const valid = DEMO_CREDENTIALS.find(
        (c) => c.username === username && c.password === password
      );
      if (valid) {
        router.push('/dashboard');
        return;
      }
    }

    setError(t('Invalid username or password', 'ተጠቃሚ ስም ወይም የይለፍ ቃል ትክክል አይደለም'));
    setLoading(false);
  };

  const fillDemo = (cred: (typeof DEMO_CREDENTIALS)[0]) => {
    setUsername(cred.username);
    setPassword(cred.password);
    setError('');
  };

  return (
    <div className="min-h-screen flex" style={{ background: 'linear-gradient(135deg, #161a4b 0%, #1e2770 50%, #2f43c8 100%)' }}>
      {/* Left branding panel */}
      <div className="hidden lg:flex flex-col justify-center items-center flex-1 p-12 text-white">
        <div className="max-w-md text-center">
          <div
            className="w-20 h-20 rounded-2xl flex items-center justify-center mx-auto mb-6"
            style={{ background: 'linear-gradient(135deg, #fbbf24, #d97706)', boxShadow: '0 8px 32px rgba(251,191,36,0.35)' }}
          >
            <Church size={40} color="#1e2770" />
          </div>
          <h1 className="text-3xl font-bold mb-2">SSMS</h1>
          <p className="text-blue-200 text-lg font-medium mb-1">
            Sunday School Management Information System
          </p>
          <p className="text-blue-300 text-base" lang="am">
            ሰንበት ት/ቤት አስተዳደር መረጃ ስርዓት
          </p>
          <div className="mt-8 p-4 rounded-xl border border-white/10 bg-white/5 text-left text-sm text-blue-200 space-y-2">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-yellow-400" />
              <span>{t('ምድብ ሁለት አጥቢያ ሰንበት ት/ቤት', 'Category 2 Parish Sunday School')}</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-yellow-400" />
              <span>7 {t('Coordinations', 'ቅንጅቶች')} · 7 {t('Departments', 'ክፍሎች')}</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-yellow-400" />
              <span>{t('Bilingual: English & Amharic', 'ሁለት ቋንቋ: ቋንቋ እንግሊዝኛ እና አማርኛ')}</span>
            </div>
          </div>
        </div>
      </div>

      {/* Right login card */}
      <div className="flex flex-col justify-center items-center w-full lg:w-auto lg:min-w-[440px] p-6">
        <div className="w-full max-w-sm bg-white rounded-2xl shadow-2xl p-8">
          {/* Mobile logo */}
          <div className="flex items-center gap-3 mb-6 lg:hidden">
            <div
              className="w-10 h-10 rounded-xl flex items-center justify-center"
              style={{ background: 'linear-gradient(135deg, #fbbf24, #d97706)' }}
            >
              <Church size={22} color="#1e2770" />
            </div>
            <div>
              <div className="text-base font-bold text-slate-800">SSMS</div>
              <div className="text-xs text-slate-400">Sunday School MIS</div>
            </div>
          </div>

          {/* Language toggle */}
          <div className="flex justify-end mb-4">
            <button
              onClick={() => setLocale((l) => (l === 'en' ? 'am' : 'en'))}
              className="text-xs font-semibold px-3 py-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-50"
            >
              {locale === 'en' ? '🇪🇹 አማርኛ' : '🌐 English'}
            </button>
          </div>

          <h2 className="text-xl font-bold text-slate-800 mb-1">
            {t('Welcome Back', 'እንኳን ደህና መጡ')}
          </h2>
          <p className="text-sm text-slate-500 mb-6">
            {t('Sign in to your account to continue', 'ለመቀጠል ወደ መለያዎ ይግቡ')}
          </p>

          {/* Error */}
          {error && (
            <div className="mb-4 p-3 rounded-lg bg-red-50 border border-red-200 flex items-center gap-2 text-red-700 text-sm">
              <AlertCircle size={16} />
              {error}
            </div>
          )}

          {/* Form */}
          <form onSubmit={handleLogin} className="space-y-4">
            <div className="form-group">
              <label className="form-label" htmlFor="username">
                {t('Username', 'የተጠቃሚ ስም')}
              </label>
              <input
                id="username"
                type="text"
                className="form-input"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder={t('Enter your username', 'የተጠቃሚ ስምዎን ያስገቡ')}
                autoComplete="username"
                required
              />
            </div>
            <div className="form-group">
              <label className="form-label" htmlFor="password">
                {t('Password', 'የይለፍ ቃል')}
              </label>
              <div className="relative">
                <input
                  id="password"
                  type={showPw ? 'text' : 'password'}
                  className="form-input pr-10"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  autoComplete="current-password"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPw((s) => !s)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                >
                  {showPw ? <EyeOff size={16} /> : <Eye size={16} />}
                </button>
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className={cn(
                'btn btn-primary w-full mt-2',
                loading && 'opacity-70 cursor-not-allowed'
              )}
            >
              {loading ? (
                <span className="loading-spinner" style={{ width: 18, height: 18 }} />
              ) : (
                <LogIn size={16} />
              )}
              {loading
                ? t('Signing in…', 'በመግባት ላይ…')
                : t('Sign In', 'ግባ')}
            </button>
          </form>

          {/* Demo accounts */}
          <div className="mt-6 pt-5 border-t border-slate-100">
            <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-3">
              {t('Demo Accounts', 'ሙከራ መለያዎች')}
            </p>
            <div className="space-y-2">
              {DEMO_CREDENTIALS.map((cred) => (
                <button
                  key={cred.username}
                  onClick={() => fillDemo(cred)}
                  className="w-full text-left px-3 py-2.5 rounded-lg border border-slate-200 hover:bg-slate-50 transition-colors flex justify-between items-center group"
                >
                  <div>
                    <div className="text-xs font-semibold text-slate-700">
                      {t(cred.label, cred.labelAm)}
                    </div>
                    <div className="text-xs text-slate-400 font-mono">{cred.username}</div>
                  </div>
                  <span className="text-xs text-primary-600 opacity-0 group-hover:opacity-100 font-medium">
                    {t('Use →', 'ጠቀም →')}
                  </span>
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
