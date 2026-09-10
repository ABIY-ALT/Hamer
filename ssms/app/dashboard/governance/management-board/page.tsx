import type { Metadata } from 'next';
import GovernancePage from '@/components/governance/GovernancePage';

export const metadata: Metadata = {
  title: 'Management Board | Governance',
};

export default function Page() {
  return <GovernancePage bodyCode="MANAGEMENT_BOARD" />;
}
