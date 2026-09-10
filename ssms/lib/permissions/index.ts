// ─────────────────────────────────────────────────────────────────────────────
// Permission Helpers — Server + Client side authorization utilities
// ─────────────────────────────────────────────────────────────────────────────

import type { PermissionCode, AuthUser } from '@/types';

/**
 * Check if a user has a specific permission.
 */
export function hasPermission(user: AuthUser | null, permission: PermissionCode): boolean {
  if (!user) return false;
  return user.permissions.has(permission);
}

/**
 * Check if a user has ANY of the listed permissions.
 */
export function hasAnyPermission(user: AuthUser | null, permissions: PermissionCode[]): boolean {
  if (!user) return false;
  return permissions.some((p) => user.permissions.has(p));
}

/**
 * Check if a user has ALL of the listed permissions.
 */
export function hasAllPermissions(user: AuthUser | null, permissions: PermissionCode[]): boolean {
  if (!user) return false;
  return permissions.every((p) => user.permissions.has(p));
}

/**
 * Check if a user is assigned to (or has access to) an organization unit.
 * Super admins with org-001 (General Assembly) can access all units.
 */
export function canAccessOrganization(user: AuthUser | null, organizationUnitId: string): boolean {
  if (!user) return false;
  // Audit committee members and super admins with AUDIT_VIEW_ALL can see all orgs
  if (user.permissions.has('AUDIT_VIEW_ALL')) return true;
  return user.organizationIds.includes(organizationUnitId);
}

/**
 * Check if a user can perform a specific action (permission + org scope).
 */
export function canPerformAction(
  user: AuthUser | null,
  permission: PermissionCode,
  organizationUnitId?: string
): boolean {
  if (!user) return false;
  if (!hasPermission(user, permission)) return false;
  if (organizationUnitId && !canAccessOrganization(user, organizationUnitId)) return false;
  return true;
}

/**
 * Navigation guard — returns true if user should see a nav item.
 * At least one of the listed permissions must be present.
 */
export function canSeeNavItem(user: AuthUser | null, requiredPermissions: PermissionCode[]): boolean {
  if (!user) return false;
  if (requiredPermissions.length === 0) return true;
  return hasAnyPermission(user, requiredPermissions);
}

/**
 * Throws an error string if user lacks the permission.
 * Use in Server Actions.
 */
export function requirePermission(user: AuthUser | null, permission: PermissionCode): void {
  if (!hasPermission(user, permission)) {
    throw new Error(`UNAUTHORIZED: Missing permission ${permission}`);
  }
}
