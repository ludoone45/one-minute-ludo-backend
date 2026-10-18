-- Migration 0033: expand the private bot roster without creating public users.
--
-- Bot identities are server-owned participants. They intentionally have no
-- users or public authentication records, but every identity has a private
-- wallet so entry fees and rewards remain fully auditable.

INSERT INTO bot_wallets (bot_id, player_id, display_name)
VALUES
  ('b0000000-0000-4000-8000-000000000009',  'BOT-HAMZA',   'Hamza Qureshi'),
  ('b0000000-0000-4000-8000-000000000010',  'BOT-SANA',    'Sana Malik'),
  ('b0000000-0000-4000-8000-000000000011',  'BOT-TASHI',   'Tashi Wangchuk'),
  ('b0000000-0000-4000-8000-000000000012',  'BOT-PEMA',    'Pema Dorji'),
  ('b0000000-0000-4000-8000-000000000013',  'BOT-ROHAN',   'Rohan Mehta'),
  ('b0000000-0000-4000-8000-000000000014',  'BOT-ANIKA',   'Anika Joshi'),
  ('b0000000-0000-4000-8000-000000000015',  'BOT-AARAV',   'Aarav Thapa'),
  ('b0000000-0000-4000-8000-000000000016',  'BOT-KABIR',   'Kabir Shrestha'),
  ('b0000000-0000-4000-8000-000000000017',  'BOT-LAILA',   'Laila Okafor'),
  ('b0000000-0000-4000-8000-000000000018',  'BOT-YOUSSEF', 'Youssef Mensah'),
  ('b0000000-0000-4000-8000-000000000019',  'BOT-THANDO',  'Thando Mbeki'),
  ('b0000000-0000-4000-8000-000000000020',  'BOT-AMINA',   'Amina Wekesa'),
  ('b0000000-0000-4000-8000-000000000021',  'BOT-NEELAM',  'Neelam Kapoor'),
  ('b0000000-0000-4000-8000-000000000022',  'BOT-FARAH',   'Farah Siddiqui'),
  ('b0000000-0000-4000-8000-000000000023',  'BOT-SONAM',   'Sonam Tshering'),
  ('b0000000-0000-4000-8000-000000000024',  'BOT-CHIDI',   'Chidi Eze')
ON CONFLICT (bot_id) DO NOTHING;