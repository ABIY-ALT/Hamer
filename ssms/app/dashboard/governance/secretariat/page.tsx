import { Metadata } from 'next';
import GovernancePage from '@/components/governance/GovernancePage';
export const metadata: Metadata = { title: 'Secretariat | SSMS' };
export default function Page() { return <GovernancePage bodyCode="MANAGEMENT_SECRETARIAT" />; }
