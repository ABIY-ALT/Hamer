// ─────────────────────────────────────────────────────────────────────────────
// Governance Mock Data — extends the base mock data
// ─────────────────────────────────────────────────────────────────────────────

import type { GovernanceBody, GovernanceMembership } from '@/types';
import {
  MOCK_GOVERNANCE_BODIES as BASE_BODIES,
  MOCK_GOVERNANCE_POSITIONS,
  MOCK_GOVERNANCE_RULES,
  MOCK_ORG_UNITS,
} from './data';

export { MOCK_GOVERNANCE_POSITIONS, MOCK_GOVERNANCE_RULES };

// Attach org unit to governance body
export const MOCK_GOVERNANCE_BODIES: GovernanceBody[] = BASE_BODIES.map((b) => ({
  ...b,
  organization_unit: MOCK_ORG_UNITS.find((u) => u.id === b.organization_unit_id),
}));

// Sample memberships per body
export const MOCK_GOVERNANCE_MEMBERSHIPS_BY_BODY: Record<string, GovernanceMembership[]> = {
  // Management Board — seed with some members to demonstrate the 9-member rule
  'gb-003': [
    {
      id: 'gm-001',
      body_id: 'gb-003',
      person_id: 'person-003',
      position_id: 'pos-001',
      appointment_date: '2024-01-05',
      term_start: '2024-01-05',
      term_end: '2026-01-05',
      status: 'ACTIVE',
      appointed_by: null,
      remarks: null,
      created_at: '2024-01-05T00:00:00Z',
      updated_at: '2024-01-05T00:00:00Z',
    },
    {
      id: 'gm-002',
      body_id: 'gb-003',
      person_id: 'person-001',
      position_id: 'pos-003',
      appointment_date: '2024-01-05',
      term_start: '2024-01-05',
      term_end: '2026-01-05',
      status: 'ACTIVE',
      appointed_by: null,
      remarks: null,
      created_at: '2024-01-05T00:00:00Z',
      updated_at: '2024-01-05T00:00:00Z',
    },
  ],
  // Audit Committee
  'gb-002': [
    {
      id: 'gm-003',
      body_id: 'gb-002',
      person_id: 'person-004',
      position_id: 'pos-001',
      appointment_date: '2024-01-08',
      term_start: '2024-01-08',
      term_end: null,
      status: 'ACTIVE',
      appointed_by: null,
      remarks: null,
      created_at: '2024-01-08T00:00:00Z',
      updated_at: '2024-01-08T00:00:00Z',
    },
  ],
};

export { MOCK_PERSONS } from './data';
