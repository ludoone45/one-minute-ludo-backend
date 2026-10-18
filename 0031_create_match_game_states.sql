-- Migration 0031: durable snapshots for active authoritative game state.
--
-- The Socket.IO process keeps a hot copy in memory for fast gameplay. This
-- table is the restart boundary: an in-progress match can be reconstructed
-- from the latest snapshot after a process restart.
CREATE TABLE IF NOT EXISTS match_game_states (
  match_id         UUID        PRIMARY KEY REFERENCES matches(id) ON DELETE CASCADE,
  state            JSONB       NOT NULL,
  turn_started_at  TIMESTAMPTZ NOT NULL,
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_match_game_states_updated_at
  ON match_game_states (updated_at);