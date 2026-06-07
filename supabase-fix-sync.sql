-- =====================================================
-- TradeFlow — FIX cloud sync (kør HELE filen i SQL Editor → Run)
-- =====================================================

-- 1) Tillad bruger at oprette sin egen organisation (manglede!)
drop policy if exists "orgs insert own" on public.organizations;
create policy "orgs insert own" on public.organizations
  for insert to authenticated
  with check (created_by = auth.uid());

-- 2) Forenkl profiles select-policy (undgå rekursion)
drop policy if exists "profiles select own" on public.profiles;
create policy "profiles select own" on public.profiles
  for select using (id = auth.uid() or org_id = public.current_org_id());

-- 3) Tillad profile upsert (insert + update)
drop policy if exists "profiles insert own" on public.profiles;
create policy "profiles insert own" on public.profiles
  for insert with check (id = auth.uid());
drop policy if exists "profiles update own" on public.profiles;
create policy "profiles update own" on public.profiles
  for update using (id = auth.uid());

-- 4) Sørg for kolonner findes (fra tidligere migration)
alter table public.tegninger add column if not exists category text default 'A';
alter table public.pins add column if not exists assigned_to_name text;

-- 5) BACKFILL: opret org + profil til alle auth-brugere der mangler det
do $$
declare u record; new_org_id uuid;
begin
  for u in select * from auth.users loop
    -- Skip if profile already exists with org
    if exists (select 1 from public.profiles where id = u.id and org_id is not null) then
      continue;
    end if;
    insert into public.organizations (name, created_by)
    values (coalesce(u.raw_user_meta_data->>'company', 'Mit firma'), u.id)
    returning id into new_org_id;
    insert into public.profiles (id, email, name, company, org_id, role)
    values (
      u.id, u.email,
      coalesce(u.raw_user_meta_data->>'name', split_part(u.email, '@', 1)),
      u.raw_user_meta_data->>'company',
      new_org_id, 'owner'
    )
    on conflict (id) do update set org_id = excluded.org_id;
  end loop;
end $$;

-- 6) VERIFICÉR — skal vise din bruger med en org_id
select email, name, org_id, role from public.profiles;
