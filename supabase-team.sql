-- =====================================================
-- TradeFlow — Hold/invitationer (kør HELE filen i SQL Editor → Run)
-- =====================================================

-- Invitationer: admin opretter en invitation til en email + rolle.
-- Når den person logger ind, kobles de automatisk til organisationen.
create table if not exists public.invites (
  id uuid default gen_random_uuid() primary key,
  org_id uuid references public.organizations on delete cascade not null,
  email text not null,
  role text not null default 'worker' check (role in ('owner','manager','worker','viewer')),
  created_by uuid references auth.users on delete set null,
  created_at timestamptz default now() not null
);

alter table public.invites enable row level security;

-- Admin (samme org) kan oprette/se/slette invitationer
drop policy if exists "invites same org" on public.invites;
create policy "invites same org" on public.invites
  for all using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- Alle authenticated kan SE invitationer der matcher deres egen email
-- (så de kan blive koblet til org ved login)
drop policy if exists "invites for my email" on public.invites;
create policy "invites for my email" on public.invites
  for select to authenticated
  using (lower(email) = lower((select email from auth.users where id = auth.uid())));

-- Grants
grant all on public.invites to authenticated;

-- Tillad at en bruger opdaterer sin EGEN profils org_id/rolle (når de accepterer invite)
drop policy if exists "profiles join org" on public.profiles;
create policy "profiles join org" on public.profiles
  for update using (id = auth.uid());

-- =====================================================
-- FÆRDIG
-- =====================================================
