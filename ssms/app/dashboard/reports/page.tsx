'use client';

import React, { useState } from 'react';
import { BarChart3, Download, FileText, Calendar, Filter, Printer, ArrowUpRight, CheckCircle2 } from 'lucide-react';
import { useLang } from '@/contexts/LangContext';
import { Modal } from '@/components/ui/Modal';

export default function ReportsPage() {
  const { t } = useLang();
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const [isCustomReportModalOpen, setIsCustomReportModalOpen] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState('Academic & Enrollment');
  const [startDate, setStartDate] = useState('2026-01-01');
  const [endDate, setEndDate] = useState('2026-12-31');
  const [format, setFormat] = useState('PDF');

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  const handleDownloadReport = (name: string) => {
    showToast(t(`Generating and downloading "${name}"...`, `"${name}" እየተዘጋጀ ይወርዳል...`));
  };

  const handleExportConsolidated = () => {
    showToast(t('Consolidated Category 2 Parish Annual Dossier exported (PDF)!', 'አጠቃላይ የምድብ ሁለት አጥቢያ ዓመታዊ ሪፖርት ወርዷል!'));
  };

  const handleGenerateCustom = (e: React.FormEvent) => {
    e.preventDefault();
    setIsCustomReportModalOpen(false);
    showToast(t(`Custom ${selectedCategory} report generated (${format})!`, `የተበጀ ${selectedCategory} ሪፖርት ተዘጋጅቷል (${format})!`));
  };

  const reportCategories = [
    {
      titleEn: 'Academic & Enrollment Reports',
      titleAm: 'የትምህርትና የተማሪዎች ሪፖርት',
      reports: [
        { nameEn: 'Student Attendance Summary', nameAm: 'የተማሪዎች ክትትል ማጠቃለያ', format: 'PDF / Excel' },
        { nameEn: 'Term Grade Distribution & Ranks', nameAm: 'የሩብ ዓመት ውጤቶችና ደረጃዎች', format: 'PDF / Excel' },
        { nameEn: 'Teacher Class Load & Log', nameAm: 'የመምህራን የክፍል ጫና', format: 'PDF' },
      ],
    },
    {
      titleEn: 'Financial & Budgetary Statements',
      titleAm: 'የፋይናንስና የበጀት ሪፖርቶች',
      reports: [
        { nameEn: 'Monthly Income & Expense Ledger', nameAm: 'ወርሃዊ የገቢና ወጪ መዝገብ', format: 'Excel' },
        { nameEn: 'Annual Budget Utilization Audit', nameAm: 'ዓመታዊ የበጀት አጠቃቀም ኦዲት', format: 'PDF / Excel' },
        { nameEn: 'Donor Contribution Reconciliation', nameAm: 'የደጋፊዎች ስጦታ ማስታረቂያ', format: 'PDF' },
      ],
    },
    {
      titleEn: 'Governance & Compliance Statements',
      titleAm: 'የአስተዳደርና ተገዢነት ሪፖርቶች',
      reports: [
        { nameEn: 'General Assembly Attendance & Quorum', nameAm: 'የጠቅላላ ጉባኤ ተገኝነትና ምልዓተ ጉባኤ', format: 'PDF' },
        { nameEn: 'Performance Audit Committee Findings', nameAm: 'የአፈጻጸም ክትትል ጉባኤ ግኝቶች', format: 'PDF' },
        { nameEn: 'Asset Custody & Depreciation Schedule', nameAm: 'የንብረት ኃላፊነትና የእርጅና ቅነሳ', format: 'Excel' },
      ],
    },
  ];

  return (
    <div className="space-y-6">
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 bg-slate-900 text-white px-5 py-3 rounded-xl shadow-2xl flex items-center gap-3 border border-slate-700 animate-in fade-in slide-in-from-bottom-4">
          <CheckCircle2 size={18} className="text-emerald-400" />
          <span className="text-sm font-medium">{toastMessage}</span>
        </div>
      )}

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-900">
            {t('Executive Analytics & Statutory Reports', 'ሪፖርቶችና ትንተና')}
          </h1>
          <p className="text-sm text-slate-500 mt-1">
            {t(
              'Parish Sunday school governance statements, academic ledgers, and financial filings',
              'የሰንበት ት/ቤቱ የአስተዳደር፣ የትምህርትና የፋይናንስ ይፋዊ ሪፖርቶች'
            )}
          </p>
        </div>
        <button
          onClick={handleExportConsolidated}
          className="btn btn-primary self-start sm:self-auto inline-flex items-center gap-2"
        >
          <Download size={16} />
          {t('Export Consolidated Dossier', 'አጠቃላይ ሪፖርት አውርድ')}
        </button>
      </div>

      {/* Grid of Report Categories */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {reportCategories.map((cat, idx) => (
          <div key={idx} className="card p-5 flex flex-col justify-between space-y-4">
            <div>
              <div className="flex items-center gap-2.5 pb-3 border-b border-slate-100">
                <FileText className="text-blue-600" size={18} />
                <h2 className="font-bold text-slate-900 text-sm">{t(cat.titleEn, cat.titleAm)}</h2>
              </div>
              <div className="divide-y divide-slate-100 mt-2">
                {cat.reports.map((rep, rIdx) => (
                  <div key={rIdx} className="py-3 flex items-center justify-between">
                    <div>
                      <div className="font-medium text-xs text-slate-800">{t(rep.nameEn, rep.nameAm)}</div>
                      <div className="text-[10px] text-slate-400 font-mono mt-0.5">{rep.format}</div>
                    </div>
                    <button
                      onClick={() => handleDownloadReport(rep.nameEn)}
                      className="btn btn-ghost btn-sm text-blue-600 hover:text-blue-800 p-1.5 hover:bg-blue-50 transition-colors"
                      title={t('Download Report', 'ሪፖርት አውርድ')}
                    >
                      <Download size={14} />
                    </button>
                  </div>
                ))}
              </div>
            </div>
            <button
              onClick={() => {
                setSelectedCategory(cat.titleEn);
                setIsCustomReportModalOpen(true);
              }}
              className="btn btn-secondary w-full text-xs py-2 inline-flex items-center justify-center gap-1.5 hover:bg-slate-100 transition-colors"
            >
              <span>{t('Generate Custom Filtered Report', 'ብጁ ሪፖርት አዘጋጅ')}</span>
              <ArrowUpRight size={13} />
            </button>
          </div>
        ))}
      </div>

      {/* Custom Report Modal */}
      <Modal
        isOpen={isCustomReportModalOpen}
        onClose={() => setIsCustomReportModalOpen(false)}
        title={t('Generate Custom Analytical Report', 'ብጁ ሪፖርት አዘጋጅ')}
        subtitle={`${selectedCategory} • Category 2 Sunday School`}
      >
        <form onSubmit={handleGenerateCustom} className="space-y-4">
          <div>
            <label className="text-xs font-semibold text-slate-700 block mb-1">
              {t('Domain Module', 'ዘርፍ')} *
            </label>
            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="form-input text-sm"
            >
              <option value="Academic & Enrollment">Academic & Enrollment (ትምህርትና ተማሪዎች)</option>
              <option value="Financial & Budgetary">Financial & Budgetary (ፋይናንስና በጀት)</option>
              <option value="Governance & Compliance">Governance & Compliance (አስተዳደርና ክትትል)</option>
              <option value="Property & Assets">Property & Inventory (ንብረትና ቆጠራ)</option>
            </select>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="text-xs font-semibold text-slate-700 block mb-1">
                {t('Start Date', 'መነሻ ቀን')} *
              </label>
              <input
                type="date"
                required
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="form-input text-sm"
              />
            </div>
            <div>
              <label className="text-xs font-semibold text-slate-700 block mb-1">
                {t('End Date', 'ማብቂያ ቀን')} *
              </label>
              <input
                type="date"
                required
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                className="form-input text-sm"
              />
            </div>
          </div>

          <div>
            <label className="text-xs font-semibold text-slate-700 block mb-1">
              {t('Output Export Format', 'የፋይል ዓይነት')}
            </label>
            <select
              value={format}
              onChange={(e) => setFormat(e.target.value)}
              className="form-input text-sm"
            >
              <option value="PDF Document (.pdf)">PDF Document (.pdf)</option>
              <option value="Microsoft Excel (.xlsx)">Microsoft Excel (.xlsx)</option>
              <option value="CSV Data File (.csv)">CSV Data File (.csv)</option>
            </select>
          </div>

          <div className="flex items-center justify-end gap-2 pt-4 border-t border-slate-100">
            <button
              type="button"
              onClick={() => setIsCustomReportModalOpen(false)}
              className="btn btn-secondary text-xs py-2"
            >
              {t('Cancel', 'ሰርዝ')}
            </button>
            <button type="submit" className="btn btn-primary text-xs py-2 px-4">
              {t('Generate Report', 'ሪፖርት አውጣ')}
            </button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
