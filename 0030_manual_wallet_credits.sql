-- 0030_manual_wallet_credits.sql
-- Admin-only manual deposits backed by a unique payment reference.

ALTER TABLE admin_audit_log
  DROP CONSTRAINT IF EXISTS admin_audit_log_action_check;

ALTER TABLE admin_audit_log
  ADD CONSTRAINT admin_audit_log_action_check CHECK (action IN (
    'ban', 'unban', 'promote', 'demote',
    'status_change', 'role_change', 'ticket_status_change',
    'manual_credit'
  ));

CREATE TABLE IF NOT EXISTS manual_wallet_credits (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  target_user_id    UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  admin_id          UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  transaction_id    UUID NOT NULL UNIQUE REFERENCES transactions(id) ON DELETE RESTRICT,
  amount            NUMERIC(18,2) NOT NULL CHECK (amount > 0),
  payment_reference VARCHAR(160) NOT NULL UNIQUE,
  note              VARCHAR(500),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS manual_wallet_credits_target_idx
  ON manual_wallet_credits (target_user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS manual_wallet_credits_admin_idx
  ON manual_wallet_credits (admin_id, created_at DESC);