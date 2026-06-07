-- =====================================================
-- TradeFlow — DEN AFGØRENDE FIX: table grants
-- (Tabellerne manglede adgang for app-brugeren fordi
--  "auto-expose new tables" var slået fra)
-- Kør HELE filen i SQL Editor → Run
-- =====================================================

-- Giv app-roller adgang til schema + tabeller
grant usage on schema public to authenticated, anon;
grant all on all tables in schema public to authenticated;
grant all on all sequences in schema public to authenticated;
grant select on all tables in schema public to anon;

-- Sørg for at FREMTIDIGE tabeller også får adgang automatisk
alter default privileges in schema public grant all on tables to authenticated;
alter default privileges in schema public grant all on sequences to authenticated;

-- Storage (fotos/tegninger) — giv adgang til uploads-bucket objekter
grant all on storage.objects to authenticated;
grant select on storage.objects to anon;

-- =====================================================
-- VERIFICÉR — kør denne for at se det virkede:
-- (skal vise 'authenticated' har privileges på sager-tabellen)
-- =====================================================
select grantee, privilege_type
from information_schema.role_table_grants
where table_name = 'sager' and grantee = 'authenticated';
