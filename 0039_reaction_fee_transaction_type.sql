-- Keep emoji reaction charges in the immutable wallet ledger.
ALTER TABLE transactions
  DROP CONSTRAINT IF EXISTS transactions_type_check;

ALTER TABLE transactions
  ADD CONSTRAINT transactions_type_check
  CHECK (type IN ('deposit', 'withdraw', 'reward', 'entry_fee', 'refund', 'adjustment', 'reaction_fee'));
