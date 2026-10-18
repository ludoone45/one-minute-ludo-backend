-- Migration 0023: persist the number of pawns configured for a match.
ALTER TABLE matches
  ADD COLUMN IF NOT EXISTS pawn_count INTEGER NOT NULL DEFAULT 4
  CHECK (pawn_count IN (1, 2, 3, 4));