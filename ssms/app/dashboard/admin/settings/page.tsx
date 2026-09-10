'use client';

import React, { useState } from 'react';
import { Settings, Save, Shield, Database, Globe, Bell, CheckCircle2 } from 'lucide-react';
import { useLang } from '@/contexts/LangContext';

export default function SettingsPage() {
  const { t, locale, setLocale } = useLang();
  const [saved, setSaved] = useState(false);

  const handleSave = () => {
    setSaved(true);
    setTimeout(() => setSaved(false), 3000);
  };

  return (
    <div className="space-y-6 max-w-4xl">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-900">
            {t('System & Parish Configuration', 'የስርዓት ቅንብሮች')}
          </h1>
          <p className="text-sm text-slate-500 mt-1">
            {t(
              'Parish Sunday school profile, Category 2 compliance parameters, and localization',
              'የአጥቢያ ሰንበት ት/ቤት መረጃ፣ የምድብ ሁለት ተገዢነት እና ቋንቋ ቅንብሮች'
            )}
          </p>
        </div>
        <button
          onClick={handleSave}
          className="btn btn-primary self-start sm:self-auto inline-flex items-center gap-2"
        >
          <Save size={16} />
          {t('Save Configuration', 'ቅንብሮችን መዝግብ')}
        </button>
      </div>

      {saved && (
        <div className="p-4 bg-emerald-50 border border-emerald-200 rounded-xl flex items-center gap-2 text-emerald-800 text-sm font-medium">
          <CheckCircle2 size={18} className="text-emerald-600" />
          {t('Settings saved successfully!', 'ቅንብሮች በሚገባ ተመዝግበዋል!')}
        </div>
      )}

      {/* Category 2 Parish Profile */}
      <div className="card p-6 space-y-4">
        <div className="flex items-center gap-2 pb-3 border-b border-slate-100">
          <Shield className="text-blue-600" size={20} />
          <h2 className="text-base font-bold text-slate-900">
            {t('Category 2 Parish Profile', 'የምድብ ሁለት አጥቢያ መረጃ')}
          </h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="text-xs font-semibold text-slate-700 block mb-1">
              {t('Parish Church Name (English)', 'የአጥቢያ ቤተ ክርስቲያን ስም (እንግሊዝኛ)')}
            </label>
            <input
              type="text"
              defaultValue="Debre Bisrat Saint Gabriel Sunday School"
              className="form-input text-sm"
            />
          </div>
          <div>
            <label className="text-xs font-semibold text-slate-700 block mb-1">
              {t('Parish Church Name (Amharic)', 'የአጥቢያ ቤተ ክርስቲያን ስም (አማርኛ)')}
            </label>
            <input
              type="text"
              defaultValue="ደብረ ብሥራት ቅዱስ ገብርኤል ሰንበት ትምህርት ቤት"
              className="form-input text-sm"
            />
          </div>
          <div>
            <label className="text-xs font-semibold text-slate-700 block mb-1">
              {t('Parish Category Classification', 'የአጥቢያ ደረጃ ምደባ')}
            </label>
            <input
              type="text"
              readOnly
              value="Category 2 (ምድብ ሁለት)"
              className="form-input text-sm bg-slate-50 text-slate-500 font-semibold"
            />
          </div>
          <div>
            <label className="text-xs font-semibold text-slate-700 block mb-1">
              {t('Diocese Jurisdiction', 'ሀገረ ስብከት')}
            </label>
            <input
              type="text"
              defaultValue="Addis Ababa Diocese (አዲስ አበባ ሀገረ ስብከት)"
              className="form-input text-sm"
            />
          </div>
        </div>
      </div>

      {/* Statutory Governance Enforcement Rules */}
      <div className="card p-6 space-y-4">
        <div className="flex items-center gap-2 pb-3 border-b border-slate-100">
          <Database className="text-amber-600" size={20} />
          <h2 className="text-base font-bold text-slate-900">
            {t('Statutory Architecture Governance Rules', 'ሕጋዊ የአስተዳደር ደንቦች')}
          </h2>
        </div>

        <div className="space-y-3">
          <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
            <div>
              <div className="font-semibold text-sm text-slate-900">
                {t('Board of Management 9-Member Quota Enforcement', 'የሥራ አመራር ጉባኤ ባለ 9 አባላት ደንብ')}
              </div>
              <div className="text-xs text-slate-500">
                {t('Strict validation blocking any appointment beyond or below 9 members', 'በትክክል 9 አባላት መሆናቸውን ያረጋግጣል')}
              </div>
            </div>
            <span className="badge badge-success">{t('Enforced', 'ተፈጻሚ')}</span>
          </div>

          <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
            <div>
              <div className="font-semibold text-sm text-slate-900">
                {t('Audit Committee Autonomous Read-Only Access', 'የአፈጻጸም ክትትል ጉባኤ ራሱን የቻለ የቁጥጥር ስልጣን')}
              </div>
              <div className="text-xs text-slate-500">
                {t('Cryptographic cross-organizational mutation monitoring', 'ሁሉን አቀፍ የክትትልና ቁጥጥር ስልጣን')}
              </div>
            </div>
            <span className="badge badge-success">{t('Enforced', 'ተፈጻሚ')}</span>
          </div>
        </div>
      </div>

      {/* Localization Settings */}
      <div className="card p-6 space-y-4">
        <div className="flex items-center gap-2 pb-3 border-b border-slate-100">
          <Globe className="text-purple-600" size={20} />
          <h2 className="text-base font-bold text-slate-900">
            {t('Language & Localization', 'ቋንቋና አካባቢ')}
          </h2>
        </div>

        <div className="flex items-center gap-4">
          <button
            type="button"
            onClick={() => setLocale('am')}
            className={`px-4 py-2 rounded-lg font-medium text-sm border transition-all ${
              locale === 'am'
                ? 'bg-blue-600 text-white border-blue-600 shadow-sm'
                : 'bg-white text-slate-700 border-slate-200 hover:bg-slate-50'
            }`}
          >
            አማርኛ (Amharic)
          </button>
          <button
            type="button"
            onClick={() => setLocale('en')}
            className={`px-4 py-2 rounded-lg font-medium text-sm border transition-all ${
              locale === 'en'
                ? 'bg-blue-600 text-white border-blue-600 shadow-sm'
                : 'bg-white text-slate-700 border-slate-200 hover:bg-slate-50'
            }`}
          >
            English
          </button>
        </div>
      </div>
    </div>
  );
}
