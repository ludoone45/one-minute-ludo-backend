-- Restore the complete role allowlist for deployments whose production schema
-- has not yet applied the Super Admin role migrations.

ALTER TABLE users
  DROP CONSTRAINT IF EXISTS users_role_check;

ALTER TABLE users
  ADD CONSTRAINT users_role_check
  CHECK (role IN ('player', 'admin', 'manager', 'operator', 'SUPER_ADMIN'));