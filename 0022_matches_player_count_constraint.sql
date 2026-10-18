-- Classic Online supports exactly 2, 3, or 4 real participants.

ALTER TABLE matches
  DROP CONSTRAINT IF EXISTS matches_player_count_check;

ALTER TABLE matches
  ADD CONSTRAINT matches_player_count_check
  CHECK (player_count IN (2, 3, 4));