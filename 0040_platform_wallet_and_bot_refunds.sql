-- Dedicated system wallet for match platform income. It is intentionally
-- separate from both user wallets and bot_wallets.
CREATE TABLE IF NOT EXISTS platform_wallets (
  id SMALLINT PRIMARY KEY CHECK (id = 1),
  points NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (points >= 0),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO platform_wallets (id, points) VALUES (1, 0)
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS platform_wallet_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE RESTRICT,
  type VARCHAR(24) NOT NULL CHECK (type = 'match_income'),
  amount NUMERIC(18,2) NOT NULL CHECK (amount > 0),
  balance_before NUMERIC(18,2) NOT NULL CHECK (balance_before >= 0),
  balance_after NUMERIC(18,2) NOT NULL CHECK (balance_after >= balance_before),
  reference TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (match_id, type)
);

CREATE INDEX IF NOT EXISTS platform_wallet_transactions_created_idx
  ON platform_wallet_transactions (created_at DESC);

ALTER TABLE bot_wallet_transactions
  DROP CONSTRAINT IF EXISTS bot_wallet_transactions_type_check;
ALTER TABLE bot_wallet_transactions
  ADD CONSTRAINT bot_wallet_transactions_type_check
  CHECK (type IN ('entry_fee', 'reward', 'refund'));
