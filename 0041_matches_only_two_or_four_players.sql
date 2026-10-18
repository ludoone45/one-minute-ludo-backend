-- Preserve historical 3-player rows, but reject new 3-player matches.
ALTER TABLE matches
  ADD CONSTRAINT matches_player_count_2_or_4_check
  CHECK (player_count IN (2, 4)) NOT VALID;
