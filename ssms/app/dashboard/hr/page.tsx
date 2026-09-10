'use client';

import React from 'react';
import Link from 'next/link';
import { UserCheck, Briefcase, Clock, ShieldAlert } from 'lucide-react';
import { useLang } from '@/contexts/LangContext';

export default function HRHub() {
  const { t } = useLang();

  const links = [
    {
      titleEn: 'Personnel Directory',
      titleAm: 'የሠራተኞች ማውጫ',
      descEn: 'Master register of staff, deacons, teachers, and officers',
      descAm: 'የሠራተኞችና አገልጋዮች አጠቃላይ መዝገብ',
      href: '/dashboard/hr/personnel',
      icon: UserCheck,
    },
    {
      titleEn: 'Staff Assignments',
      titleAm: 'የክፍል ምደባዎች',
      descEn: 'Role allocations across 7 departments and 7 coordinations',
      descAm: 'በክፍሎች የተከናወኑ የምደባ ስራዎች',
      href: '/dashboard/hr/assignments',
      icon: Briefcase,
    },
    {
      titleEn: 'Staff Attendance',
      titleAm: 'የአገልጋዮች ክትትል',
      descEn: 'Punctuality, service shifts, and attendance verification',
      descAm: 'የተገኝነትና የሰዓት ማክበር ክትትል',
      href: '/dashboard/hr/attendance',
      icon: Clock,
    },
    {
      titleEn: 'Discipline & Ethics',
      titleAm: 'ዲሲፕሊንና ሥነ-ምግባር',
      descEn: 'Ethical reviews, warnings, resolutions, and pastoral counseling',
      descAm: 'የሥነ-ምግባር ምክክርና ውሳኔዎች',
      href: '/dashboard/hr/discipline',
      icon: ShieldAlert,
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-slate-900">
          {t('Human Resources Administration Hub', 'የሰው ሀብት አስተዳደር ማዕከል')}
        </h1>
        <p className="text-sm text-slate-500 mt-1">
          {t(
            'Parish Sunday school personnel management, assignments, attendance, and ethics',
            'የሰንበት ት/ቤት ሠራተኞች፣ ምደባዎችና የሥራ ክትትል'
          )}
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
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
                <span>{t('Manage Personnel →', 'አስተዳድር →')}</span>
              </div>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
