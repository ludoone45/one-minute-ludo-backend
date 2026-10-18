-- Super Admin Master Ledger
-- The uppercase role value is intentionally distinct from standard admin access.

ALTER TABLE users
  DROP CONSTRAINT IF EXISTS users_role_check;

ALTER TABLE users
  ADD CONSTRAINT users_role_check
  CHECK (role IN ('player', 'admin', 'SUPER_ADMIN'));

ALTER TABLE transactions
  DROP CONSTRAINT IF EXISTS transactions_type_check;

ALTER TABLE transactions
  ADD CONSTRAINT transactions_type_check
  CHECK (type IN ('deposit', 'withdraw', 'reward', 'entry_fee', 'refund', 'adjustment'));

ALTER TABLE admin_audit_log
  ADD COLUMN IF NOT EXISTS action_type VARCHAR(80);

UPDATE admin_audit_log
   SET action_type = action
 WHERE action_type IS NULL;

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
    'SUPER_ADMIN_DATA_OVERRIDE'
  ));

CREATE INDEX IF NOT EXISTS idx_transactions_master_ledger
  ON transactions (user_id, type, created_at DESC)
  WHERE type IN ('deposit', 'withdraw', 'adjustment');

CREATE INDEX IF NOT EXISTS idx_audit_log_action_type
  ON admin_audit_log (action_type, created_at DESC);