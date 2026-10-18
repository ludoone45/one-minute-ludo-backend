-- 0029_auto_create_user_wallets.sql
-- Every registered account must have a persistent zero-balance wallet.
-- Google-created accounts also use this trigger; balance changes remain
-- restricted to server-side reward/settlement services.

CREATE OR REPLACE FUNCTION create_wallet_for_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO wallets (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS users_create_wallet ON users;
CREATE TRIGGER users_create_wallet
  AFTER INSERT ON users
  FOR EACH ROW
  EXECUTE FUNCTION create_wallet_for_new_user();

-- Repair accounts created before the trigger existed.
INSERT INTO wallets (user_id)
SELECT u.id
  FROM users u
 WHERE NOT EXISTS (
   SELECT 1
     FROM wallets w
    WHERE w.user_id = u.id
 )
ON CONFLICT (user_id) DO NOTHING;