-- =============================================================================
-- SSMS Phase 1 — Migration 004: Seed Data
-- Depends on: 003_rls_policies.sql
-- Run with service_role to bypass RLS during seeding.
-- =============================================================================

-- =============================================================================
-- ORGANIZATION UNITS
-- =============================================================================

INSERT INTO organization_units (id, code, name_en, name_am, unit_type, ltree_path, parent_id, sort_order) VALUES
-- Governance Layer
('10000000-0000-0000-0000-000000000001', 'GENERAL_ASSEMBLY', 'General Assembly', 'ጠቅላላ ጉባኤ', 'GENERAL_ASSEMBLY', 'general_assembly', NULL, 1),
('10000000-0000-0000-0000-000000000002', 'AUDIT_COMMITTEE', 'Performance Audit Committee', 'የአፈጻጸም ክትትል ጉባኤ', 'AUDIT_COMMITTEE', 'general_assembly.audit_committee', '10000000-0000-0000-0000-000000000001', 2),
('10000000-0000-0000-0000-000000000003', 'MANAGEMENT_BOARD', 'Board of Management', 'የሥራ አመራር ጉባኤ', 'MANAGEMENT_BOARD', 'general_assembly.management_board', '10000000-0000-0000-0000-000000000001', 3),
('10000000-0000-0000-0000-000000000004', 'MANAGEMENT_SECRETARIAT', 'Management Secretariat', 'የሥራ አመራር ጽሕፈት ቤት', 'MANAGEMENT_SECRETARIAT', 'general_assembly.management_board.management_secretariat', '10000000-0000-0000-0000-000000000003', 4),
('10000000-0000-0000-0000-000000000005', 'ADVISORY_COUNCIL', 'Advisory Council', 'አፈጻጸም አማካሪዎች', 'ADVISORY_COUNCIL', 'general_assembly.advisory_council', '10000000-0000-0000-0000-000000000001', 5),
('10000000-0000-0000-0000-000000000006', 'EXECUTIVE_COMMITTEE', 'Executive Committee', 'የሥራ አስፈጻሚ ጉባኤ', 'EXECUTIVE_COMMITTEE', 'general_assembly.management_board.executive_committee', '10000000-0000-0000-0000-000000000003', 6),
('10000000-0000-0000-0000-000000000007', 'EXECUTIVE_SECRETARIAT', 'Executive Secretariat', 'የሥራ አስፈጻሚ ጽሕፈት ቤት', 'EXECUTIVE_SECRETARIAT', 'general_assembly.management_board.executive_committee.executive_secretariat', '10000000-0000-0000-0000-000000000006', 7),
-- Seven Coordinations
('10000000-0000-0000-0000-000000000011', 'COORD_PLANNING', 'Planning, Monitoring & Evaluation', 'እቅድ፣ ክትትልና ግምገማ ቅንጅት', 'COORDINATION', 'general_assembly.management_board.executive_committee.coord_planning', '10000000-0000-0000-0000-000000000006', 10),
('10000000-0000-0000-0000-000000000012', 'COORD_MEDIA', 'Media & Public Relations', 'ሚዲያ እና ሕዝብ ግንኙነት ቅንጅት', 'COORDINATION', 'general_assembly.management_board.executive_committee.coord_media', '10000000-0000-0000-0000-000000000006', 11),
('10000000-0000-0000-0000-000000000013', 'COORD_EDUCATION', 'Education & Patristics', 'ትምህርት እና ፓትሪስቲክስ ቅንጅት', 'COORDINATION', 'general_assembly.management_board.executive_committee.coord_education', '10000000-0000-0000-0000-000000000006', 12),
('10000000-0000-0000-0000-000000000014', 'COORD_MEMBERS', 'Members & Organizational Structure', 'አባላትና ድርጅታዊ መዋቅር ቅንጅት', 'COORDINATION', 'general_assembly.management_board.executive_committee.coord_members', '10000000-0000-0000-0000-000000000006', 13),
('10000000-0000-0000-0000-000000000015', 'COORD_INFO', 'Information & Current Affairs', 'መረጃ እና ወቅታዊ ጉዳዮች ቅንጅት', 'COORDINATION', 'general_assembly.management_board.executive_committee.coord_info', '10000000-0000-0000-0000-000000000006', 14),
('10000000-0000-0000-0000-000000000016', 'COORD_RESOURCE', 'Resource Mobilization & Social Services', 'ሀብት ማሰባሰብ እና ማህበራዊ አገልግሎት ቅንጅት', 'COORDINATION', 'general_assembly.management_board.executive_committee.coord_resource', '10000000-0000-0000-0000-000000000006', 15),
('10000000-0000-0000-0000-000000000017', 'COORD_FINANCE', 'Finance & Property Administration', 'ፋይናንስ እና ንብረት አስተዳደር ቅንጅት', 'COORDINATION', 'general_assembly.management_board.executive_committee.coord_finance', '10000000-0000-0000-0000-000000000006', 16),
-- Seven Departments
('10000000-0000-0000-0000-000000000021', 'DEPT_EDUCATION', 'Education & Training Department', 'ትምህርትና ስልጠና ክፍል', 'DEPARTMENT', 'general_assembly.management_board.executive_committee.dept_education', '10000000-0000-0000-0000-000000000006', 20),
('10000000-0000-0000-0000-000000000022', 'DEPT_PROGRAMS', 'Programs & Assemblies Department', 'ፕሮግራምና ስብሰባ ክፍል', 'DEPARTMENT', 'general_assembly.management_board.executive_committee.dept_programs', '10000000-0000-0000-0000-000000000006', 21),
('10000000-0000-0000-0000-000000000023', 'DEPT_INTERNAL_RELATIONS', 'Information & Internal Relations Department', 'መረጃ እና ውስጣዊ ግንኙነት ክፍል', 'DEPARTMENT', 'general_assembly.management_board.executive_committee.dept_internal_relations', '10000000-0000-0000-0000-000000000006', 22),
('10000000-0000-0000-0000-000000000024', 'DEPT_SACRED_ARTS', 'Hymnody, Choir & Sacred Arts Department', 'ዜማ፣ ዘማሪ እና ቅዱስ ጥበብ ክፍል', 'DEPARTMENT', 'general_assembly.management_board.executive_committee.dept_sacred_arts', '10000000-0000-0000-0000-000000000006', 23),
('10000000-0000-0000-0000-000000000025', 'DEPT_HR', 'Human Resources Administration Department', 'የሰው ሀብት አስተዳደር ክፍል', 'DEPARTMENT', 'general_assembly.management_board.executive_committee.dept_hr', '10000000-0000-0000-0000-000000000006', 24),
('10000000-0000-0000-0000-000000000026', 'DEPT_DEVELOPMENT', 'Development & Investment Department', 'ልማትና ኢንቨስትመንት ክፍል', 'DEPARTMENT', 'general_assembly.management_board.executive_committee.dept_development', '10000000-0000-0000-0000-000000000006', 25),
('10000000-0000-0000-0000-000000000027', 'DEPT_FINANCE_PROPERTY', 'Budget & Property Management Department', 'በጀትና ንብረት አስተዳደር ክፍል', 'DEPARTMENT', 'general_assembly.management_board.executive_committee.dept_finance_property', '10000000-0000-0000-0000-000000000006', 26);

-- =============================================================================
-- GOVERNANCE BODIES
-- =============================================================================

INSERT INTO governance_bodies (id, organization_unit_id, name_en, name_am) VALUES
('20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'General Assembly', 'ጠቅላላ ጉባኤ'),
('20000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000002', 'Performance Audit Committee', 'የአፈጻጸም ክትትል ጉባኤ'),
('20000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000003', 'Board of Management', 'የሥራ አመራር ጉባኤ'),
('20000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000006', 'Executive Committee', 'የሥራ አስፈጻሚ ጉባኤ');

-- =============================================================================
-- GOVERNANCE BODY RULES (9-member constraint)
-- =============================================================================

INSERT INTO governance_body_rules (body_id, rule_code, rule_value, description_en, description_am) VALUES
('20000000-0000-0000-0000-000000000003', 'EXACT_MEMBER_COUNT', '9',
 'Board of Management must have exactly 9 active members',
 'የሥራ አመራር ጉባኤ በትክክል 9 ንቁ አባላት ሊኖሩት ይገባል'),
('20000000-0000-0000-0000-000000000004', 'EXACT_MEMBER_COUNT', '9',
 'Executive Committee must have exactly 9 active members',
 'የሥራ አስፈጻሚ ጉባኤ በትክክል 9 ንቁ አባላት ሊኖሩት ይገባል');

-- =============================================================================
-- GOVERNANCE POSITIONS
-- =============================================================================

INSERT INTO governance_positions (id, code, name_en, name_am, authority_level) VALUES
('30000000-0000-0000-0000-000000000001', 'CHAIRPERSON', 'Chairperson', 'ሰብሳቢ', 1),
('30000000-0000-0000-0000-000000000002', 'VICE_CHAIR', 'Vice Chairperson', 'ምክትል ሰብሳቢ', 2),
('30000000-0000-0000-0000-000000000003', 'SECRETARY', 'Secretary', 'ጸሐፊ', 3),
('30000000-0000-0000-0000-000000000004', 'TREASURER', 'Treasurer', 'ያዥ', 4),
('30000000-0000-0000-0000-000000000005', 'COORDINATOR', 'Coordinator', 'አስተባባሪ', 5),
('30000000-0000-0000-0000-000000000006', 'DEPT_HEAD', 'Department Head', 'የክፍል ኃላፊ', 5),
('30000000-0000-0000-0000-000000000007', 'ADVISOR', 'Advisor', 'አማካሪ', 4),
('30000000-0000-0000-0000-000000000008', 'MEMBER', 'Member', 'አባል', 9);

-- =============================================================================
-- PERMISSIONS
-- =============================================================================

INSERT INTO permissions (id, code, name_en, name_am, category) VALUES
-- Academic
('40000000-0000-0000-0000-000000000001', 'STUDENT_VIEW',      'View Students',            'ተማሪዎችን ይመልከቱ',              'ACADEMIC'),
('40000000-0000-0000-0000-000000000002', 'STUDENT_CREATE',    'Register Students',        'ተማሪዎችን ይመዝግቡ',              'ACADEMIC'),
('40000000-0000-0000-0000-000000000003', 'STUDENT_UPDATE',    'Update Student Records',   'የተማሪ መዝገቦችን ያዘምኑ',          'ACADEMIC'),
('40000000-0000-0000-0000-000000000004', 'STUDENT_DELETE',    'Delete Student Records',   'የተማሪ መዝገቦችን ሰርዙ',           'ACADEMIC'),
('40000000-0000-0000-0000-000000000005', 'ATTENDANCE_VIEW',   'View Attendance',          'ክትትልን ይመልከቱ',               'ACADEMIC'),
('40000000-0000-0000-0000-000000000006', 'ATTENDANCE_RECORD', 'Record Attendance',        'ክትትልን ይመዝግቡ',               'ACADEMIC'),
('40000000-0000-0000-0000-000000000007', 'ATTENDANCE_UPDATE', 'Update Attendance',        'ክትትልን ያዘምኑ',                'ACADEMIC'),
('40000000-0000-0000-0000-000000000008', 'GRADE_VIEW',        'View Grades',              'ውጤቶችን ይመልከቱ',               'ACADEMIC'),
('40000000-0000-0000-0000-000000000009', 'GRADE_CREATE',      'Enter Grades',             'ውጤቶችን ያስገቡ',                'ACADEMIC'),
('40000000-0000-0000-0000-000000000010', 'GRADE_UPDATE',      'Update Grades',            'ውጤቶችን ያዘምኑ',                'ACADEMIC'),
('40000000-0000-0000-0000-000000000011', 'GRADE_APPROVE',     'Approve Grades',           'ውጤቶችን ያጸድቁ',                'ACADEMIC'),
-- Finance
('40000000-0000-0000-0000-000000000012', 'FINANCE_VIEW',      'View Finance',             'ፋይናንስን ይመልከቱ',               'FINANCE'),
('40000000-0000-0000-0000-000000000013', 'FINANCE_CREATE',    'Create Financial Records', 'የፋይናንስ መዝገቦች ይፍጠሩ',          'FINANCE'),
('40000000-0000-0000-0000-000000000014', 'FINANCE_APPROVE',   'Approve Transactions',     'ግብይቶችን ያጸድቁ',               'FINANCE'),
-- Property
('40000000-0000-0000-0000-000000000015', 'ASSET_VIEW',        'View Assets',              'ንብረቶችን ይመልከቱ',               'PROPERTY'),
('40000000-0000-0000-0000-000000000016', 'ASSET_CREATE',      'Register Assets',          'ንብረቶችን ይመዝግቡ',               'PROPERTY'),
('40000000-0000-0000-0000-000000000017', 'ASSET_ASSIGN',      'Assign Assets',            'ንብረቶችን ያስረክቡ',               'PROPERTY'),
('40000000-0000-0000-0000-000000000018', 'ASSET_TRANSFER',    'Transfer Assets',          'ንብረቶችን ያዛውሩ',                'PROPERTY'),
-- Audit
('40000000-0000-0000-0000-000000000019', 'AUDIT_VIEW_ALL',    'View All Audit Logs',      'ሁሉንም ኦዲት መዝገቦች ይመልከቱ',      'AUDIT'),
-- Governance
('40000000-0000-0000-0000-000000000020', 'GOVERNANCE_VIEW',   'View Governance',          'አስተዳደርን ይመልከቱ',               'GOVERNANCE'),
('40000000-0000-0000-0000-000000000021', 'GOVERNANCE_MANAGE', 'Manage Governance',        'አስተዳደርን ያስተዳድሩ',              'GOVERNANCE'),
-- Reports
('40000000-0000-0000-0000-000000000022', 'REPORT_VIEW',       'View Reports',             'ሪፖርቶችን ይመልከቱ',               'REPORTS'),
('40000000-0000-0000-0000-000000000023', 'REPORT_EXPORT',     'Export Reports',           'ሪፖርቶችን ይላኩ',                 'REPORTS'),
-- Members
('40000000-0000-0000-0000-000000000024', 'MEMBER_VIEW',       'View Members',             'አባላትን ይመልከቱ',                'PEOPLE'),
('40000000-0000-0000-0000-000000000025', 'MEMBER_CREATE',     'Register Members',         'አባላትን ይመዝግቡ',                'PEOPLE'),
('40000000-0000-0000-0000-000000000026', 'MEMBER_UPDATE',     'Update Member Records',    'የአባል መዝገቦችን ያዘምኑ',            'PEOPLE'),
-- Admin
('40000000-0000-0000-0000-000000000027', 'USER_MANAGE',       'Manage System Users',      'ተጠቃሚዎችን ያስተዳድሩ',              'ADMIN'),
('40000000-0000-0000-0000-000000000028', 'ROLE_MANAGE',       'Manage Roles',             'ሚናዎችን ያስተዳድሩ',                'ADMIN'),
('40000000-0000-0000-0000-000000000029', 'SYSTEM_CONFIGURE',  'Configure System',         'ስርዓቱን ያዋቅሩ',                 'ADMIN'),
-- Programs
('40000000-0000-0000-0000-000000000030', 'PROGRAM_VIEW',      'View Programs',            'ፕሮግራሞችን ይመልከቱ',               'PROGRAMS'),
('40000000-0000-0000-0000-000000000031', 'PROGRAM_CREATE',    'Create Programs',          'ፕሮግራሞች ይፍጠሩ',                'PROGRAMS'),
('40000000-0000-0000-0000-000000000032', 'PROGRAM_MANAGE',    'Manage Programs',          'ፕሮግራሞችን ያስተዳድሩ',              'PROGRAMS'),
-- HR
('40000000-0000-0000-0000-000000000033', 'HR_VIEW',           'View HR Records',          'የሰው ሀብት መዝገቦችን ይመልከቱ',       'HR'),
('40000000-0000-0000-0000-000000000034', 'HR_MANAGE',         'Manage HR Records',        'የሰው ሀብት መዝገቦችን ያስተዳድሩ',      'HR');

-- =============================================================================
-- ROLES
-- =============================================================================

INSERT INTO roles (id, code, name_en, name_am, description_en, is_system_role) VALUES
('50000000-0000-0000-0000-000000000001', 'SUPER_ADMIN',       'Super Administrator', 'ዋና አስተዳዳሪ',          'Full system access',                    TRUE),
('50000000-0000-0000-0000-000000000002', 'BOARD_OFFICER',     'Board Officer',       'የሥራ አመራር ኃላፊ',      'Board-level governance and oversight',  FALSE),
('50000000-0000-0000-0000-000000000003', 'AUDIT_INSPECTOR',   'Audit Inspector',     'ኦዲት ተቆጣጣሪ',         'Read-only cross-org audit access',      FALSE),
('50000000-0000-0000-0000-000000000004', 'SECRETARIAT',       'Secretariat',         'ጽሕፈት ቤት',            'Administrative coordination',           FALSE),
('50000000-0000-0000-0000-000000000005', 'COORDINATOR',       'Coordinator',         'አስተባባሪ',              'Coordination unit leadership',          FALSE),
('50000000-0000-0000-0000-000000000006', 'DEPT_HEAD',         'Department Head',     'የክፍል ኃላፊ',           'Department management',                 FALSE),
('50000000-0000-0000-0000-000000000007', 'TEACHER',           'Teacher',             'አስተማሪ',               'Classroom and attendance',              FALSE);

-- =============================================================================
-- ROLE PERMISSIONS
-- =============================================================================

-- Super Admin: all permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT '50000000-0000-0000-0000-000000000001', id FROM permissions;

-- Board Officer: governance + finance view + member view + reports + student view + asset view
INSERT INTO role_permissions (role_id, permission_id)
SELECT '50000000-0000-0000-0000-000000000002', id FROM permissions
WHERE code IN ('GOVERNANCE_VIEW','GOVERNANCE_MANAGE','FINANCE_VIEW','MEMBER_VIEW',
               'REPORT_VIEW','REPORT_EXPORT','STUDENT_VIEW','ASSET_VIEW','GRADE_VIEW','PROGRAM_VIEW');

-- Audit Inspector: all VIEW permissions + AUDIT_VIEW_ALL (no mutations)
INSERT INTO role_permissions (role_id, permission_id)
SELECT '50000000-0000-0000-0000-000000000003', id FROM permissions
WHERE code IN ('AUDIT_VIEW_ALL','STUDENT_VIEW','ATTENDANCE_VIEW','GRADE_VIEW',
               'FINANCE_VIEW','ASSET_VIEW','MEMBER_VIEW','REPORT_VIEW','REPORT_EXPORT',
               'GOVERNANCE_VIEW','PROGRAM_VIEW','HR_VIEW');

-- Secretariat: member + governance view + program view + report view
INSERT INTO role_permissions (role_id, permission_id)
SELECT '50000000-0000-0000-0000-000000000004', id FROM permissions
WHERE code IN ('MEMBER_VIEW','MEMBER_CREATE','MEMBER_UPDATE','GOVERNANCE_VIEW',
               'PROGRAM_VIEW','PROGRAM_CREATE','REPORT_VIEW');

-- Coordinator: program manage + member view + report view
INSERT INTO role_permissions (role_id, permission_id)
SELECT '50000000-0000-0000-0000-000000000005', id FROM permissions
WHERE code IN ('PROGRAM_VIEW','PROGRAM_CREATE','PROGRAM_MANAGE','MEMBER_VIEW','REPORT_VIEW');

-- Dept Head: student + attendance + grade approve + hr view + report
INSERT INTO role_permissions (role_id, permission_id)
SELECT '50000000-0000-0000-0000-000000000006', id FROM permissions
WHERE code IN ('STUDENT_VIEW','STUDENT_CREATE','STUDENT_UPDATE',
               'ATTENDANCE_VIEW','ATTENDANCE_RECORD','ATTENDANCE_UPDATE',
               'GRADE_VIEW','GRADE_CREATE','GRADE_UPDATE','GRADE_APPROVE',
               'MEMBER_VIEW','REPORT_VIEW','HR_VIEW','PROGRAM_VIEW');

-- Teacher: student view + attendance record + grade create
INSERT INTO role_permissions (role_id, permission_id)
SELECT '50000000-0000-0000-0000-000000000007', id FROM permissions
WHERE code IN ('STUDENT_VIEW','ATTENDANCE_VIEW','ATTENDANCE_RECORD','GRADE_VIEW','GRADE_CREATE');
