ALTER TABLE bot_wallet_transactions
  DROP CONSTRAINT IF EXISTS bot_wallet_transactions_type_check;
ALTER TABLE bot_wallet_transactions
  ADD CONSTRAINT bot_wallet_transactions_type_check
  CHECK (type IN ('entry_fee', 'reward', 'refund'));
