-- Admin finance operations: payment metadata, queue review, and adjustments.
--
-- Existing transaction rows remain immutable in meaning; these nullable fields
-- add the operator/provider metadata needed to review pending requests safely.

ALTER TABLE transactions
  ADD COLUMN IF NOT EXISTS payment_method VARCHAR(80),
  ADD COLUMN IF NOT EXISTS admin_transaction_id VARCHAR(160),
  ADD COLUMN IF NOT EXISTS admin_id UUID REFERENCES users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS admin_action_reason VARCHAR(500),
  ADD COLUMN IF NOT EXISTS admin_action_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS transactions_pending_type_created_idx
  ON transactions (type, status, created_at DESC)
  WHERE status = 'pending' AND type IN ('deposit', 'withdraw');

ALTER TABLE admin_audit_log
  DROP CONSTRAINT IF EXISTS admin_audit_log_action_check;

ALTER TABLE admin_audit_log
  ADD CONSTRAINT admin_audit_log_action_check CHECK (action IN (
    'ban', 'unban', 'promote', 'demote',
    'status_change', 'role_change', 'ticket_status_change',
    'match_cancel', 'manual_credit',
    'balance_adjustment',
    'recharge_approve', 'recharge_reject',
    'withdrawal_payment_ok', 'withdrawal_reject'
  ));