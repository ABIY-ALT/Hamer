import { Metadata } from 'next';
import GovernancePage from '@/components/governance/GovernancePage';
export const metadata: Metadata = { title: 'Executive Committee | SSMS' };
export default function Page() { return <GovernancePage bodyCode="EXECUTIVE_COMMITTEE" />; }
