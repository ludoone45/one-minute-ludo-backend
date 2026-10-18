-- Payment request metadata, withdrawal reservations, and configurable payout destinations.

ALTER TABLE wallets
  ADD COLUMN IF NOT EXISTS held_points NUMERIC(18,2) NOT NULL DEFAULT 0
    CHECK (held_points >= 0);

CREATE TABLE IF NOT EXISTS payment_method_settings (
  method       VARCHAR(32) PRIMARY KEY
    CHECK (method IN (
      'binance_pay', 'redotpay', 'payoneer', 'wise', 'ypt',
      'usdt_bep20', 'rizon', 'fasset'
    )),
  label        VARCHAR(120) NOT NULL,
  category     VARCHAR(16) NOT NULL CHECK (category IN ('internal', 'onchain')),
  destination TEXT NOT NULL DEFAULT '',
  currency     VARCHAR(16),
  network      VARCHAR(32),
  fee_points   NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (fee_points >= 0),
  active       BOOLEAN NOT NULL DEFAULT FALSE,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO payment_method_settings
  (method, label, category, currency, network, fee_points, active)
VALUES
  ('binance_pay', 'Binance Pay', 'internal', NULL, NULL, 0, FALSE),
  ('redotpay', 'RedotPay', 'internal', NULL, NULL, 0, FALSE),
  ('payoneer', 'Payoneer', 'internal', NULL, NULL, 0, FALSE),
  ('wise', 'Wise', 'internal', NULL, NULL, 0, FALSE),
  ('ypt', 'YPT', 'internal', NULL, NULL, 0, FALSE),
  ('usdt_bep20', 'USDT via BEP20', 'onchain', 'USDT', 'BEP20', 10, FALSE),
  ('rizon', 'Rizon', 'onchain', 'USDT', 'BEP20', 10, FALSE),
  ('fasset', 'Fasset', 'onchain', 'USDT', 'BEP20', 10, FALSE)
ON CONFLICT (method) DO NOTHING;

CREATE TABLE IF NOT EXISTS payment_requests (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_id        UUID NOT NULL UNIQUE REFERENCES transactions(id) ON DELETE CASCADE,
  payment_method        VARCHAR(32) NOT NULL REFERENCES payment_method_settings(method),
  category              VARCHAR(16) NOT NULL CHECK (category IN ('internal', 'onchain')),
  currency              VARCHAR(16),
  network               VARCHAR(32),
  sender_identifier     VARCHAR(160),
  recipient_identifier  VARCHAR(160),
  proof_path            VARCHAR(500),
  note                  VARCHAR(500),
  requested_usd         NUMERIC(18,2) NOT NULL CHECK (requested_usd >= 0),
  fee_points            NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (fee_points >= 0),
  fee_usd               NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (fee_usd >= 0),
  final_points          NUMERIC(18,2) NOT NULL CHECK (final_points >= 0),
  final_usd             NUMERIC(18,2) NOT NULL CHECK (final_usd >= 0),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT payment_requests_proof_path_check CHECK (
    proof_path IS NULL OR proof_path LIKE '/objects/uploads/%'
  )
);

CREATE INDEX IF NOT EXISTS payment_requests_method_created_idx
  ON payment_requests (payment_method, created_at DESC);

CREATE INDEX IF NOT EXISTS payment_requests_transaction_idx
  ON payment_requests (transaction_id);

ALTER TABLE admin_audit_log
  DROP CONSTRAINT IF EXISTS admin_audit_log_action_check;

ALTER TABLE admin_audit_log
  ADD CONSTRAINT admin_audit_log_action_check CHECK (action IN (
    'ban', 'unban', 'promote', 'demote',
    'status_change', 'role_change', 'ticket_status_change',
    'match_cancel', 'manual_credit', 'balance_adjustment',
    'recharge_approve', 'recharge_reject',
    'withdrawal_payment_ok', 'withdrawal_reject',
    'SUPER_ADMIN_DATA_OVERRIDE', 'SUPER_ADMIN_ADMIN_CREATE',
    'SUPER_ADMIN_ADMIN_UPDATE', 'SUPER_ADMIN_ADMIN_STATUS',
    'SUPER_ADMIN_ADMIN_DELETE', 'payment_method_update'
  ));