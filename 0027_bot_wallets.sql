-- Migration 0027: private server-controlled wallets for Classic Online bots.
--
-- Bot IDs intentionally do not reference users: bots are fictional
-- participants and must never become authenticated/public wallet accounts.

CREATE TABLE IF NOT EXISTS bot_wallets (
  bot_id       UUID PRIMARY KEY,
  player_id    VARCHAR(40) NOT NULL UNIQUE,
  display_name VARCHAR(120) NOT NULL,
  points       NUMERIC(18,2) NOT NULL DEFAULT 1000000 CHECK (points >= 0),
  total_spent  NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_spent >= 0),
  total_won    NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (total_won >= 0),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bot_wallet_transactions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bot_id         UUID NOT NULL REFERENCES bot_wallets(bot_id) ON DELETE RESTRICT,
  match_id       UUID REFERENCES matches(id) ON DELETE SET NULL,
  type           VARCHAR(20) NOT NULL CHECK (type IN ('entry_fee', 'reward')),
  amount         NUMERIC(18,2) NOT NULL CHECK (amount > 0),
  balance_before NUMERIC(18,2) NOT NULL CHECK (balance_before >= 0),
  balance_after  NUMERIC(18,2) NOT NULL CHECK (balance_after >= 0),
  reference      TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (bot_id, type, reference)
);

CREATE INDEX IF NOT EXISTS bot_wallet_transactions_bot_created_idx
  ON bot_wallet_transactions (bot_id, created_at DESC);

CREATE INDEX IF NOT EXISTS bot_wallet_transactions_match_idx
  ON bot_wallet_transactions (match_id);

DROP TRIGGER IF EXISTS bot_wallets_set_updated_at ON bot_wallets;
CREATE TRIGGER bot_wallets_set_updated_at
  BEFORE UPDATE ON bot_wallets
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

-- Seed every configured identity so admin history can show zero-activity bots.
INSERT INTO bot_wallets (bot_id, player_id, display_name)
VALUES
  ('b0000000-0000-4000-8000-000000000001', 'BOT-ARIN',   'Arin Sen'),
  ('b0000000-0000-4000-8000-000000000002', 'BOT-MIRA',   'Mira Bose'),
  ('b0000000-0000-4000-8000-000000000003', 'BOT-PRABIN', 'Prabin Rai'),
  ('b0000000-0000-4000-8000-000000000004', 'BOT-SUMI',   'Sumi Gurung'),
  ('b0000000-0000-4000-8000-000000000005', 'BOT-AMARA',  'Amara Nwosu'),
  ('b0000000-0000-4000-8000-000000000006', 'BOT-KOFI',   'Kofi Adu'),
  ('b0000000-0000-4000-8000-000000000007', 'BOT-ZURI',   'Zuri Dlamini'),
  ('b0000000-0000-4000-8000-000000000008', 'BOT-NIA',    'Nia Adeyemi')
ON CONFLICT (bot_id) DO NOTHING;