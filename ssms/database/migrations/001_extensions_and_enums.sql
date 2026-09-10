-- =============================================================================
-- SSMS Phase 1 — Migration 001: Extensions & Enumerations
-- Apply via: Supabase Dashboard → SQL Editor
-- =============================================================================

-- Enable required PostgreSQL extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "ltree";

-- =============================================================================
-- ENUMERATIONS
-- =============================================================================

CREATE TYPE gender_type AS ENUM ('MALE', 'FEMALE');

CREATE TYPE member_status AS ENUM (
  'ACTIVE', 'INACTIVE', 'SUSPENDED', 'TRANSFERRED', 'DECEASED'
);

CREATE TYPE org_unit_type AS ENUM (
  'GENERAL_ASSEMBLY',
  'AUDIT_COMMITTEE',
  'MANAGEMENT_BOARD',
  'MANAGEMENT_SECRETARIAT',
  'ADVISORY_COUNCIL',
  'EXECUTIVE_COMMITTEE',
  'EXECUTIVE_SECRETARIAT',
  'COORDINATION',
  'DEPARTMENT',
  'SUB_COMMITTEE'
);

CREATE TYPE gov_relationship_type AS ENUM (
  'PARENT_OF',
  'REPORTS_TO',
  'SUPERVISES',
  'COORDINATES',
  'OVERSEES',
  'ADVISES'
);

CREATE TYPE gov_membership_status AS ENUM (
  'ACTIVE', 'INACTIVE', 'EXPIRED', 'RESIGNED', 'REMOVED'
);

CREATE TYPE workflow_status AS ENUM (
  'DRAFT', 'PENDING', 'APPROVED', 'REJECTED',
  'RETURNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'
);

CREATE TYPE audit_action AS ENUM (
  'INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'APPROVE', 'REJECT', 'EXPORT'
);
