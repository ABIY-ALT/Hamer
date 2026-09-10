import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: {
    template: '%s | SSMS — Sunday School Management',
    default: 'SSMS — Sunday School Management Information System',
  },
  description:
    'Sunday School Management Information System (SSMS) — ምድብ ሁለት አጥቢያ ሰንበት ት/ቤት',
  keywords: ['Sunday School', 'Church', 'Management', 'Ethiopia', 'ሰንበት ት/ቤት'],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
      </head>
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
