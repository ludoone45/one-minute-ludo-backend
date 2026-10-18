ALTER TABLE matches
  DROP CONSTRAINT IF EXISTS matches_player_count_2_or_4_check;

CREATE OR REPLACE FUNCTION enforce_matches_player_count_2_or_4()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.player_count NOT IN (2, 4) THEN
    RAISE EXCEPTION 'player_count must be 2 or 4'
      USING ERRCODE = '23514',
            CONSTRAINT = 'matches_player_count_2_or_4_check';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER matches_player_count_2_or_4_guard
  BEFORE INSERT OR UPDATE OF player_count ON matches
  FOR EACH ROW
  EXECUTE FUNCTION enforce_matches_player_count_2_or_4();
