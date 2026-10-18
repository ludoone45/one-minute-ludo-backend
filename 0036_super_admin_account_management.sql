-- Super Admin account management

ALTER TABLE users
  DROP CONSTRAINT IF EXISTS users_role_check;

ALTER TABLE users
  ADD CONSTRAINT users_role_check
  CHECK (role IN ('player', 'admin', 'manager', 'operator', 'SUPER_ADMIN'));

ALTER TABLE admin_audit_log
  ALTER COLUMN admin_id DROP NOT NULL;

ALTER TABLE admin_audit_log
  DROP CONSTRAINT IF EXISTS admin_audit_log_admin_id_fkey;

ALTER TABLE admin_audit_log
  ADD CONSTRAINT admin_audit_log_admin_id_fkey
  FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE manual_wallet_credits
  ALTER COLUMN admin_id DROP NOT NULL;

ALTER TABLE manual_wallet_credits
  DROP CONSTRAINT IF EXISTS manual_wallet_credits_admin_id_fkey;

ALTER TABLE manual_wallet_credits
  ADD CONSTRAINT manual_wallet_credits_admin_id_fkey
  FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE admin_audit_log
  DROP CONSTRAINT IF EXISTS admin_audit_log_action_check;

ALTER TABLE admin_audit_log
  ADD CONSTRAINT admin_audit_log_action_check CHECK (action IN (
    'ban', 'unban', 'promote', 'demote',
    'status_change', 'role_change', 'ticket_status_change',
    'match_cancel', 'manual_credit',
    'balance_adjustment',
    'recharge_approve', 'recharge_reject',
    'withdrawal_payment_ok', 'withdrawal_reject',
    'SUPER_ADMIN_DATA_OVERRIDE',
    'SUPER_ADMIN_ADMIN_CREATE',
    'SUPER_ADMIN_ADMIN_UPDATE',
    'SUPER_ADMIN_ADMIN_STATUS',
    'SUPER_ADMIN_ADMIN_DELETE'
  ));