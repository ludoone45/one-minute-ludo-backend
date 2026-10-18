-- Migration 0024: match financial idempotency guards.
--
-- A match operation uses the same reference for all participants, so the
-- participant and operation type are part of the uniqueness key.

CREATE UNIQUE INDEX IF NOT EXISTS transactions_match_operation_user_idx
  ON transactions (user_id, type, reference)
  WHERE reference IS NOT NULL
    AND type IN ('entry_fee', 'reward');