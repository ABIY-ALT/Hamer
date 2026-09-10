'use client';

import React from 'react';
import Link from 'next/link';
import { Network, Building2, GitBranch } from 'lucide-react';
import { useLang } from '@/contexts/LangContext';

export default function OrganizationHub() {
  const { t } = useLang();

  const links = [
    {
      titleEn: 'Seven Coordinations',
      titleAm: 'ሰባቱ ቅንጅቶች',
      descEn: 'Strategic coordination bodies under the Executive Committee',
      descAm: 'በሥራ አስፈጻሚ ሥር ያሉ ስልታዊ ቅንጅቶች',
      href: '/dashboard/organization/coordinations',
      icon: Network,
    },
    {
      titleEn: 'Seven Departments',
      titleAm: 'ሰባቱ ክፍሎች',
      descEn: 'Operational departments executing daily parish ministries',
      descAm: 'የሰንበት ት/ቤቱን ሥራዎች የሚያከናውኑ ክፍሎች',
      href: '/dashboard/organization/departments',
      icon: Building2,
    },
    {
      titleEn: 'Organizational Structure Chart',
      titleAm: 'ድርጅታዊ መዋቅር ቻርት',
      descEn: 'Visual hierarchy tree of governance, coordinations, and departments',
      descAm: 'የአስተዳደርና የክፍሎች የተዋረድ ገላጭ ቻርት',
      href: '/dashboard/organization/structure',
      icon: GitBranch,
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-slate-900">
          {t('Organization Architecture Hub', 'ድርጅታዊ መዋቅር ማዕከል')}
        </h1>
        <p className="text-sm text-slate-500 mt-1">
          {t(
            'Structural layout of Category 2 Parish Coordinations and Departments',
            'የምድብ ሁለት አጥቢያ ቅንጅቶችና ክፍሎች መዋቅር'
          )}
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
        {links.map((item, idx) => {
          const Icon = item.icon;
          return (
            <Link
              key={idx}
              href={item.href}
              className="card p-6 hover:shadow-md hover:border-blue-300 transition-all flex flex-col justify-between group"
            >
              <div>
                <div className="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center mb-4 group-hover:bg-blue-600 group-hover:text-white transition-colors">
                  <Icon size={20} />
                </div>
                <h3 className="font-bold text-slate-900 text-base mb-1">
                  {t(item.titleEn, item.titleAm)}
                </h3>
                <p className="text-xs text-slate-500 leading-relaxed">
                  {t(item.descEn, item.descAm)}
                </p>
              </div>
              <div className="mt-5 pt-3 border-t border-slate-100 flex items-center text-xs font-semibold text-blue-600 group-hover:translate-x-1 transition-transform">
                <span>{t('Explore Units →', 'ዝርዝር እይ →')}</span>
              </div>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
