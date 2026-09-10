import { Metadata } from 'next';
import GovernancePage from '@/components/governance/GovernancePage';
export const metadata: Metadata = { title: 'General Assembly | SSMS' };
export default function Page() { return <GovernancePage bodyCode="GENERAL_ASSEMBLY" />; }
