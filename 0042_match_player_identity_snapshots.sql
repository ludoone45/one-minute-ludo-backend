ALTER TABLE match_players
  ADD COLUMN IF NOT EXISTS avatar_snapshot TEXT,
  ADD COLUMN IF NOT EXISTS country_snapshot VARCHAR(100),
  ADD COLUMN IF NOT EXISTS identity_snapshot_at TIMESTAMPTZ;
