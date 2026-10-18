-- Migration 0025: bot participants for random online matches.
--
-- Bots are durable match participants but do not have user accounts or wallets.
-- They receive a generated UUID so existing match/winner identifiers remain
-- stable, while is_bot/display_name lets finance and display queries distinguish
-- them from authenticated players.

ALTER TABLE match_players
  DROP CONSTRAINT IF EXISTS match_players_user_id_fkey;

ALTER TABLE matches
  DROP CONSTRAINT IF EXISTS matches_winner_id_fkey;

ALTER TABLE match_players
  ADD COLUMN IF NOT EXISTS is_bot BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS display_name VARCHAR(120);

CREATE INDEX IF NOT EXISTS idx_match_players_bot
  ON match_players (match_id, is_bot);