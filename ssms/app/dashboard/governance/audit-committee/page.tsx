import { Metadata } from 'next';
import GovernancePage from '@/components/governance/GovernancePage';
export const metadata: Metadata = { title: 'Audit Committee | SSMS' };
export default function Page() { return <GovernancePage bodyCode="AUDIT_COMMITTEE" />; }
