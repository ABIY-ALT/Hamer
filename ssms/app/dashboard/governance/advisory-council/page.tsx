import { Metadata } from 'next';
import GovernancePage from '@/components/governance/GovernancePage';

export const metadata: Metadata = { title: 'Advisory Council | SSMS' };

export default function Page() {
  return <GovernancePage bodyCode="ADVISORY_COUNCIL" />;
}
