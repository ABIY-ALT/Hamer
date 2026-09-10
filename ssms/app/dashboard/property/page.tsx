'use client';

import React from 'react';
import Link from 'next/link';
import { Package, ShieldCheck, ArrowRightLeft, Wrench, ClipboardList } from 'lucide-react';
import { useLang } from '@/contexts/LangContext';

export default function PropertyHub() {
  const { t } = useLang();

  const links = [
    {
      titleEn: 'Assets Registry',
      titleAm: 'የንብረት መዝገብ',
      descEn: 'Fixed assets, IT gear, AV electronics, and instruments',
      descAm: 'ቋሚ ንብረቶችና የቢሮ ዕቃዎች',
      href: '/dashboard/property/assets',
      icon: Package,
    },
    {
      titleEn: 'Custody & Accountability',
      titleAm: 'የንብረት ኃላፊነት',
      descEn: 'Individual staff custody vouchers and signed handovers',
      descAm: 'የግል ኃላፊነትና ርክክብ',
      href: '/dashboard/property/custody',
      icon: ShieldCheck,
    },
    {
      titleEn: 'Asset Transfers',
      titleAm: 'የንብረት ዝውውር',
      descEn: 'Inter-departmental handovers and relocation logs',
      descAm: 'በክፍሎች መካከል የተደረጉ ዝውውሮች',
      href: '/dashboard/property/transfers',
      icon: ArrowRightLeft,
    },
    {
      titleEn: 'Maintenance & Repairs',
      titleAm: 'ጥገና',
      descEn: 'Service work orders, equipment repairs, and upkeep logs',
      descAm: 'የጥገና ትዕዛዞችና ወጪዎች',
      href: '/dashboard/property/maintenance',
      icon: Wrench,
    },
    {
      titleEn: 'Physical Inventory',
      titleAm: 'የንብረት ቆጠራ',
      descEn: 'Annual stocktaking audits and physical verification',
      descAm: 'ዓመታዊ የንብረት ቆጠራ',
      href: '/dashboard/property/inventory',
      icon: ClipboardList,
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-slate-900">
          {t('Property & Assets Administration Hub', 'የንብረት አስተዳደር ማዕከል')}
        </h1>
        <p className="text-sm text-slate-500 mt-1">
          {t(
            'Parish Sunday school capital equipment, custody, maintenance, and stocktaking',
            'የሰንበት ት/ቤት ቋሚ ንብረቶች፣ ኃላፊነት፣ ጥገናና ቆጠራ'
          )}
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
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
                <span>{t('Manage Inventory →', 'ንብረት አስተዳድር →')}</span>
              </div>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
