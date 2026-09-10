-- =============================================================================
-- SSMS Phase 1 — Migration 002: Core Tables
-- Depends on: 001_extensions_and_enums.sql
-- =============================================================================

-- =============================================================================
-- ORGANIZATION UNITS
-- Uses ltree for hierarchical paths (e.g. 'general_assembly.management_board')
-- =============================================================================

CREATE TABLE organization_units (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code            TEXT NOT NULL UNIQUE,
  name_en         TEXT NOT NULL,
  name_am         TEXT NOT NULL,
  unit_type       org_unit_type NOT NULL,
  ltree_path      LTREE NOT NULL UNIQUE,
  parent_id       UUID REFERENCES organization_units(id) ON DELETE RESTRICT,
  description_en  TEXT,
  description_am  TEXT,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  sort_order      INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_org_units_ltree ON organization_units USING GIST (ltree_path);
CREATE INDEX idx_org_units_parent ON organization_units(parent_id);
CREATE INDEX idx_org_units_type ON organization_units(unit_type);

-- =============================================================================
-- ORGANIZATION RELATIONSHIPS (non-hierarchical governance relationships)
-- =============================================================================

CREATE TABLE organization_relationships (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  from_unit_id      UUID NOT NULL REFERENCES organization_units(id) ON DELETE CASCADE,
  to_unit_id        UUID NOT NULL REFERENCES organization_units(id) ON DELETE CASCADE,
  relationship_type gov_relationship_type NOT NULL,
  description_en    TEXT,
  description_am    TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_org_relationship UNIQUE (from_unit_id, to_unit_id, relationship_type)
);

CREATE INDEX idx_org_rel_from ON organization_relationships(from_unit_id);
CREATE INDEX idx_org_rel_to   ON organization_relationships(to_unit_id);

-- =============================================================================
-- PERSONS / MEMBERS
-- Central person registry — every module references this table.
-- =============================================================================

CREATE TABLE persons (
  id                        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  membership_code           TEXT NOT NULL UNIQUE,  -- MBR-YYYY-XXXX
  full_name_en              TEXT NOT NULL,
  full_name_am              TEXT,
  baptismal_name            TEXT,
  gender                    gender_type NOT NULL,
  date_of_birth             DATE,
  phone_primary             TEXT,
  phone_secondary           TEXT,
  email                     TEXT,
  address                   TEXT,
  emergency_contact_name    TEXT,
  emergency_contact_phone   TEXT,
  father_of_confession      TEXT,
  profile_photo_url         TEXT,
  status                    member_status NOT NULL DEFAULT 'ACTIVE',
  notes                     TEXT,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_persons_status   ON persons(status);
CREATE INDEX idx_persons_gender   ON persons(gender);
CREATE INDEX idx_persons_name_en  ON persons USING gin(to_tsvector('simple', full_name_en));

-- Sequence for membership code generation
CREATE SEQUENCE IF NOT EXISTS membership_code_seq;

-- Function to generate membership codes: MBR-YYYY-XXXX
CREATE OR REPLACE FUNCTION generate_membership_code()
RETURNS TEXT AS $$
DECLARE
  year_part TEXT := TO_CHAR(NOW(), 'YYYY');
  seq_part  TEXT := LPAD(nextval('membership_code_seq')::TEXT, 4, '0');
BEGIN
  RETURN 'MBR-' || year_part || '-' || seq_part;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- SYSTEM USERS
-- Links Supabase auth.users to persons. A person may have no system user.
-- =============================================================================

CREATE TABLE system_users (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_user_id  UUID NOT NULL UNIQUE,  -- references auth.users.id
  person_id     UUID NOT NULL UNIQUE REFERENCES persons(id) ON DELETE RESTRICT,
  username      TEXT NOT NULL UNIQUE,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  last_login_at TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sysusers_auth ON system_users(auth_user_id);
CREATE INDEX idx_sysusers_person ON system_users(person_id);

-- =============================================================================
-- GOVERNANCE BODIES
-- =============================================================================

CREATE TABLE governance_bodies (
  id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_unit_id UUID NOT NULL UNIQUE REFERENCES organization_units(id),
  name_en              TEXT NOT NULL,
  name_am              TEXT NOT NULL,
  description_en       TEXT,
  description_am       TEXT,
  is_active            BOOLEAN NOT NULL DEFAULT TRUE,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- GOVERNANCE BODY RULES (configurable constraints)
-- =============================================================================

CREATE TABLE governance_body_rules (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  body_id         UUID NOT NULL REFERENCES governance_bodies(id) ON DELETE CASCADE,
  rule_code       TEXT NOT NULL,       -- e.g. 'EXACT_MEMBER_COUNT'
  rule_value      TEXT NOT NULL,       -- e.g. '9'
  description_en  TEXT NOT NULL,
  description_am  TEXT NOT NULL,
  is_enforced     BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_body_rule UNIQUE (body_id, rule_code)
);

-- =============================================================================
-- GOVERNANCE POSITIONS
-- =============================================================================

CREATE TABLE governance_positions (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code            TEXT NOT NULL UNIQUE,
  name_en         TEXT NOT NULL,
  name_am         TEXT NOT NULL,
  authority_level INTEGER NOT NULL DEFAULT 9,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- GOVERNANCE MEMBERSHIPS
-- =============================================================================

CREATE TABLE governance_memberships (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  body_id          UUID NOT NULL REFERENCES governance_bodies(id),
  person_id        UUID NOT NULL REFERENCES persons(id),
  position_id      UUID NOT NULL REFERENCES governance_positions(id),
  appointment_date DATE NOT NULL,
  term_start       DATE NOT NULL,
  term_end         DATE,
  status           gov_membership_status NOT NULL DEFAULT 'ACTIVE',
  appointed_by     UUID REFERENCES persons(id),
  remarks          TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_gov_mem_body   ON governance_memberships(body_id);
CREATE INDEX idx_gov_mem_person ON governance_memberships(person_id);
CREATE INDEX idx_gov_mem_status ON governance_memberships(status);

-- Prevent duplicate active membership in the same body+position
CREATE UNIQUE INDEX uq_active_gov_membership
  ON governance_memberships (body_id, person_id)
  WHERE status = 'ACTIVE';

-- =============================================================================
-- ROLES
-- =============================================================================

CREATE TABLE roles (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code            TEXT NOT NULL UNIQUE,
  name_en         TEXT NOT NULL,
  name_am         TEXT NOT NULL,
  description_en  TEXT,
  description_am  TEXT,
  is_system_role  BOOLEAN NOT NULL DEFAULT FALSE,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- PERMISSIONS
-- =============================================================================

CREATE TABLE permissions (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code            TEXT NOT NULL UNIQUE,
  name_en         TEXT NOT NULL,
  name_am         TEXT NOT NULL,
  description_en  TEXT,
  category        TEXT NOT NULL,  -- ACADEMIC, FINANCE, PROPERTY, AUDIT, etc.
  is_active       BOOLEAN NOT NULL DEFAULT TRUE
);

-- =============================================================================
-- ROLE PERMISSIONS (M:M)
-- =============================================================================

CREATE TABLE role_permissions (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  role_id        UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  permission_id  UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  granted_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_role_permission UNIQUE (role_id, permission_id)
);

CREATE INDEX idx_role_perms_role ON role_permissions(role_id);
CREATE INDEX idx_role_perms_perm ON role_permissions(permission_id);

-- =============================================================================
-- USER UNIT ASSIGNMENTS
-- Connects a system user to an org unit with a role.
-- A user can have multiple assignments across different org units.
-- =============================================================================

CREATE TABLE user_unit_assignments (
  id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  system_user_id       UUID NOT NULL REFERENCES system_users(id) ON DELETE CASCADE,
  organization_unit_id UUID NOT NULL REFERENCES organization_units(id),
  role_id              UUID NOT NULL REFERENCES roles(id),
  assigned_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at           TIMESTAMPTZ,
  is_active            BOOLEAN NOT NULL DEFAULT TRUE,
  assigned_by          UUID REFERENCES system_users(id),
  CONSTRAINT uq_user_unit_role UNIQUE (system_user_id, organization_unit_id, role_id)
);

CREATE INDEX idx_uua_user ON user_unit_assignments(system_user_id);
CREATE INDEX idx_uua_unit ON user_unit_assignments(organization_unit_id);
CREATE INDEX idx_uua_role ON user_unit_assignments(role_id);

-- =============================================================================
-- SYSTEM AUDIT LOGS (append-only — no UPDATE, no DELETE via RLS)
-- =============================================================================

CREATE TABLE system_audit_logs (
  id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id              UUID REFERENCES system_users(id) ON DELETE SET NULL,
  action               audit_action NOT NULL,
  table_name           TEXT NOT NULL,
  record_id            TEXT NOT NULL,
  old_values           JSONB,
  new_values           JSONB,
  organization_unit_id UUID REFERENCES organization_units(id) ON DELETE SET NULL,
  ip_address           INET,
  user_agent           TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_user      ON system_audit_logs(user_id);
CREATE INDEX idx_audit_table     ON system_audit_logs(table_name);
CREATE INDEX idx_audit_record    ON system_audit_logs(record_id);
CREATE INDEX idx_audit_action    ON system_audit_logs(action);
CREATE INDEX idx_audit_created   ON system_audit_logs(created_at DESC);
CREATE INDEX idx_audit_org       ON system_audit_logs(organization_unit_id);

-- =============================================================================
-- UPDATED_AT TRIGGER FUNCTION
-- =============================================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at triggers
CREATE TRIGGER trg_org_units_updated_at
  BEFORE UPDATE ON organization_units
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_persons_updated_at
  BEFORE UPDATE ON persons
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_system_users_updated_at
  BEFORE UPDATE ON system_users
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_gov_bodies_updated_at
  BEFORE UPDATE ON governance_bodies
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_gov_memberships_updated_at
  BEFORE UPDATE ON governance_memberships
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_roles_updated_at
  BEFORE UPDATE ON roles
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
