-- Migration 0032: distinguish Classic and 1 Minute rules without changing
-- the existing random/friend transport mode.
ALTER TABLE matches
  ADD COLUMN IF NOT EXISTS game_type VARCHAR(20) NOT NULL DEFAULT 'classic'
  CHECK (game_type IN ('classic', 'one_minute'));

CREATE INDEX IF NOT EXISTS idx_matches_game_type
  ON matches (game_type, status);