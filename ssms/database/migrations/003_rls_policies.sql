-- =============================================================================
-- SSMS Phase 1 — Migration 003: Row Level Security (RLS)
-- Depends on: 002_core_tables.sql
-- =============================================================================
-- DESIGN PRINCIPLES:
-- 1. Every policy evaluates: WHO + WHAT PERMISSION + WHICH ORG + WHAT ACTION
-- 2. No broad FOR ALL policies
-- 3. Audit logs are INSERT-only for everyone
-- 4. Audit committee sees all via AUDIT_VIEW_ALL permission
-- 5. System roles use DB function for permission checks
-- =============================================================================

-- =============================================================================
-- HELPER FUNCTION: Check if authenticated user has a permission
-- =============================================================================

CREATE OR REPLACE FUNCTION auth_user_has_permission(permission_code TEXT)
RETURNS BOOLEAN AS $$
DECLARE
  v_system_user_id UUID;
  v_has_perm       BOOLEAN := FALSE;
BEGIN
  -- Get system_user_id for the current Supabase auth user
  SELECT id INTO v_system_user_id
  FROM system_users
  WHERE auth_user_id = auth.uid()
    AND is_active = TRUE;

  IF v_system_user_id IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Check if any active assignment has a role with this permission
  SELECT EXISTS (
    SELECT 1
    FROM user_unit_assignments uua
    JOIN role_permissions rp ON rp.role_id = uua.role_id
    JOIN permissions p ON p.id = rp.permission_id
    WHERE uua.system_user_id = v_system_user_id
      AND uua.is_active = TRUE
      AND (uua.expires_at IS NULL OR uua.expires_at > NOW())
      AND p.code = permission_code
      AND p.is_active = TRUE
  ) INTO v_has_perm;

  RETURN v_has_perm;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- =============================================================================
-- ENABLE RLS ON ALL TABLES
-- =============================================================================

ALTER TABLE organization_units         ENABLE ROW LEVEL SECURITY;
ALTER TABLE organization_relationships ENABLE ROW LEVEL SECURITY;
ALTER TABLE persons                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_users               ENABLE ROW LEVEL SECURITY;
ALTER TABLE governance_bodies          ENABLE ROW LEVEL SECURITY;
ALTER TABLE governance_body_rules      ENABLE ROW LEVEL SECURITY;
ALTER TABLE governance_positions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE governance_memberships     ENABLE ROW LEVEL SECURITY;
ALTER TABLE roles                      ENABLE ROW LEVEL SECURITY;
ALTER TABLE permissions                ENABLE ROW LEVEL SECURITY;
ALTER TABLE role_permissions           ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_unit_assignments      ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_audit_logs          ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- ORGANIZATION UNITS — Read accessible to authenticated users
-- Write requires GOVERNANCE_MANAGE
-- =============================================================================

CREATE POLICY "org_units_select_authenticated"
  ON organization_units FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "org_units_insert_governance_manage"
  ON organization_units FOR INSERT
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

CREATE POLICY "org_units_update_governance_manage"
  ON organization_units FOR UPDATE
  USING (auth_user_has_permission('GOVERNANCE_MANAGE'))
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

CREATE POLICY "org_units_delete_governance_manage"
  ON organization_units FOR DELETE
  USING (auth_user_has_permission('GOVERNANCE_MANAGE'));

-- =============================================================================
-- ORGANIZATION RELATIONSHIPS
-- =============================================================================

CREATE POLICY "org_rel_select_authenticated"
  ON organization_relationships FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "org_rel_insert_governance_manage"
  ON organization_relationships FOR INSERT
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

CREATE POLICY "org_rel_update_governance_manage"
  ON organization_relationships FOR UPDATE
  USING (auth_user_has_permission('GOVERNANCE_MANAGE'))
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

-- =============================================================================
-- PERSONS
-- MEMBER_VIEW required to read. MEMBER_CREATE/UPDATE for write.
-- Audit committee can read all via AUDIT_VIEW_ALL.
-- =============================================================================

CREATE POLICY "persons_select_member_view"
  ON persons FOR SELECT
  USING (
    auth_user_has_permission('MEMBER_VIEW')
    OR auth_user_has_permission('AUDIT_VIEW_ALL')
  );

CREATE POLICY "persons_insert_member_create"
  ON persons FOR INSERT
  WITH CHECK (auth_user_has_permission('MEMBER_CREATE'));

CREATE POLICY "persons_update_member_update"
  ON persons FOR UPDATE
  USING (auth_user_has_permission('MEMBER_UPDATE'))
  WITH CHECK (auth_user_has_permission('MEMBER_UPDATE'));

-- Soft-delete only (status = 'INACTIVE'). Hard delete disabled.
CREATE POLICY "persons_delete_never"
  ON persons FOR DELETE
  USING (FALSE);

-- =============================================================================
-- SYSTEM USERS
-- Only USER_MANAGE can read/write system users (sensitive).
-- Exception: user can read their own record.
-- =============================================================================

CREATE POLICY "sysusers_select_self_or_manage"
  ON system_users FOR SELECT
  USING (
    auth_user_id = auth.uid()
    OR auth_user_has_permission('USER_MANAGE')
    OR auth_user_has_permission('AUDIT_VIEW_ALL')
  );

CREATE POLICY "sysusers_insert_user_manage"
  ON system_users FOR INSERT
  WITH CHECK (auth_user_has_permission('USER_MANAGE'));

CREATE POLICY "sysusers_update_user_manage"
  ON system_users FOR UPDATE
  USING (
    auth_user_id = auth.uid()
    OR auth_user_has_permission('USER_MANAGE')
  )
  WITH CHECK (
    auth_user_id = auth.uid()
    OR auth_user_has_permission('USER_MANAGE')
  );

-- =============================================================================
-- GOVERNANCE — Read requires GOVERNANCE_VIEW, Write requires GOVERNANCE_MANAGE
-- =============================================================================

CREATE POLICY "gov_bodies_select"
  ON governance_bodies FOR SELECT
  USING (
    auth_user_has_permission('GOVERNANCE_VIEW')
    OR auth_user_has_permission('AUDIT_VIEW_ALL')
  );

CREATE POLICY "gov_bodies_insert"
  ON governance_bodies FOR INSERT
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

CREATE POLICY "gov_bodies_update"
  ON governance_bodies FOR UPDATE
  USING (auth_user_has_permission('GOVERNANCE_MANAGE'))
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

CREATE POLICY "gov_body_rules_select"
  ON governance_body_rules FOR SELECT
  USING (auth_user_has_permission('GOVERNANCE_VIEW') OR auth_user_has_permission('AUDIT_VIEW_ALL'));

CREATE POLICY "gov_body_rules_write"
  ON governance_body_rules FOR INSERT
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

CREATE POLICY "gov_positions_select"
  ON governance_positions FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "gov_memberships_select"
  ON governance_memberships FOR SELECT
  USING (
    auth_user_has_permission('GOVERNANCE_VIEW')
    OR auth_user_has_permission('AUDIT_VIEW_ALL')
  );

CREATE POLICY "gov_memberships_insert"
  ON governance_memberships FOR INSERT
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

CREATE POLICY "gov_memberships_update"
  ON governance_memberships FOR UPDATE
  USING (auth_user_has_permission('GOVERNANCE_MANAGE'))
  WITH CHECK (auth_user_has_permission('GOVERNANCE_MANAGE'));

-- =============================================================================
-- RBAC TABLES — Only ROLE_MANAGE
-- =============================================================================

CREATE POLICY "roles_select_authenticated"
  ON roles FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "roles_write_role_manage"
  ON roles FOR INSERT
  WITH CHECK (auth_user_has_permission('ROLE_MANAGE'));

CREATE POLICY "roles_update_role_manage"
  ON roles FOR UPDATE
  USING (auth_user_has_permission('ROLE_MANAGE'))
  WITH CHECK (auth_user_has_permission('ROLE_MANAGE'));

CREATE POLICY "permissions_select_authenticated"
  ON permissions FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "role_perms_select_authenticated"
  ON role_permissions FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "role_perms_write_role_manage"
  ON role_permissions FOR INSERT
  WITH CHECK (auth_user_has_permission('ROLE_MANAGE'));

CREATE POLICY "role_perms_delete_role_manage"
  ON role_permissions FOR DELETE
  USING (auth_user_has_permission('ROLE_MANAGE'));

CREATE POLICY "uua_select_user_manage_or_own"
  ON user_unit_assignments FOR SELECT
  USING (
    system_user_id IN (
      SELECT id FROM system_users WHERE auth_user_id = auth.uid()
    )
    OR auth_user_has_permission('USER_MANAGE')
    OR auth_user_has_permission('AUDIT_VIEW_ALL')
  );

CREATE POLICY "uua_insert_user_manage"
  ON user_unit_assignments FOR INSERT
  WITH CHECK (auth_user_has_permission('USER_MANAGE'));

CREATE POLICY "uua_update_user_manage"
  ON user_unit_assignments FOR UPDATE
  USING (auth_user_has_permission('USER_MANAGE'))
  WITH CHECK (auth_user_has_permission('USER_MANAGE'));

-- =============================================================================
-- SYSTEM AUDIT LOGS
-- INSERT: any authenticated user (system inserts on mutations)
-- SELECT: AUDIT_VIEW_ALL only
-- UPDATE/DELETE: NOBODY — append-only
-- =============================================================================

CREATE POLICY "audit_logs_insert_authenticated"
  ON system_audit_logs FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "audit_logs_select_audit_view_all"
  ON system_audit_logs FOR SELECT
  USING (auth_user_has_permission('AUDIT_VIEW_ALL'));

-- No UPDATE policy — audit logs are immutable
-- No DELETE policy — audit logs are permanent
