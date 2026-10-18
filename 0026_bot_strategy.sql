ALTER TABLE match_players
  ADD COLUMN IF NOT EXISTS bot_strategy VARCHAR(20);

ALTER TABLE match_players
  DROP CONSTRAINT IF EXISTS match_players_bot_strategy_check;

ALTER TABLE match_players
  ADD CONSTRAINT match_players_bot_strategy_check
  CHECK (bot_strategy IS NULL OR bot_strategy IN ('aggressive', 'balanced'));