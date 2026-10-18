-- Migration 0028: Friends room ownership and requested color metadata.
--
-- Friends rooms are created outside random matchmaking. The host is persisted
-- on the match row, while requested_color lets the client explain a
-- server-assigned color when a preference is unavailable.

ALTER TABLE matches
  ADD COLUMN IF NOT EXISTS host_user_id UUID REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE match_players
  ADD COLUMN IF NOT EXISTS requested_color VARCHAR(10)
  CHECK (requested_color IS NULL OR requested_color IN ('red', 'blue', 'green', 'yellow'));

CREATE INDEX IF NOT EXISTS idx_matches_friend_host
  ON matches (host_user_id)
  WHERE mode = 'friend';