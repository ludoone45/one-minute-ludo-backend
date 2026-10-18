-- Persist participant order so server turns and each player's visual seating
-- use the same clockwise sequence, independent of chosen pawn colors.
ALTER TABLE match_players
  ADD COLUMN seat SMALLINT;

WITH ranked_players AS (
  SELECT id,
         ROW_NUMBER() OVER (
           PARTITION BY match_id
           ORDER BY joined_at, id
         ) AS seat_number
    FROM match_players
)
UPDATE match_players AS mp
   SET seat = ranked_players.seat_number
  FROM ranked_players
 WHERE mp.id = ranked_players.id;

ALTER TABLE match_players
  ALTER COLUMN seat SET NOT NULL,
  ADD CONSTRAINT match_players_seat_range CHECK (seat BETWEEN 1 AND 6),
  ADD CONSTRAINT match_players_match_seat_unique UNIQUE (match_id, seat);
