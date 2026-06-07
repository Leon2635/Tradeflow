-- ============================================================
-- TradeFlow — Supabase schema
-- Kør hele denne fil i Supabase: SQL Editor → New query → indsæt → Run
-- ============================================================

-- =========================================
-- 1) TABELLER
-- =========================================

-- Organisationer (firmaer)
create table if not exists public.organizations (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  cvr text,
  created_by uuid references auth.users on delete set null,
  created_at timestamptz default now() not null
);

-- Profiler (linket til Supabase Auth users)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text not null,
  name text not null,
  company text,
  org_id uuid references public.organizations on delete restrict not null,
  role text not null default 'owner' check (role in ('owner', 'manager', 'worker', 'viewer')),
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

-- Sager
create table if not exists public.sager (
  id uuid default gen_random_uuid() primary key,
  org_id uuid references public.organizations on delete cascade not null,
  created_by uuid references auth.users on delete set null,
  title text not null,
  customer text,
  address text,
  status text default 'active' check (status in ('active', 'planned', 'done', 'invoiced')),
  created_at timestamptz default now() not null
);

-- Tegninger
create table if not exists public.tegninger (
  id uuid default gen_random_uuid() primary key,
  sag_id uuid references public.sager on delete cascade not null,
  org_id uuid references public.organizations on delete cascade not null,
  name text not null,
  type text default 'image',
  storage_path text not null,
  created_at timestamptz default now() not null
);

-- Pins
create table if not exists public.pins (
  id uuid default gen_random_uuid() primary key,
  tegning_id uuid references public.tegninger on delete cascade not null,
  org_id uuid references public.organizations on delete cascade not null,
  created_by uuid references auth.users on delete set null,
  assigned_to uuid references auth.users on delete set null,
  x numeric not null,
  y numeric not null,
  type text default 'inspection' check (type in ('inspection', 'inquiry')),
  status text default 'open' check (status in ('open', 'assigned', 'done', 'closed')),
  note text,
  gps_lat numeric,
  gps_lng numeric,
  created_at timestamptz default now() not null
);

-- KS instances (kontrolplaner)
create table if not exists public.ks_instances (
  id uuid default gen_random_uuid() primary key,
  sag_id uuid references public.sager on delete cascade not null,
  org_id uuid references public.organizations on delete cascade not null,
  template_key text not null,
  title text not null,
  status text default 'active',
  created_at timestamptz default now() not null
);

-- KS items (checkpoints)
create table if not exists public.ks_items (
  id uuid default gen_random_uuid() primary key,
  instance_id uuid references public.ks_instances on delete cascade not null,
  org_id uuid references public.organizations on delete cascade not null,
  "order" int not null,
  title text not null,
  description text,
  status text default 'pending' check (status in ('pending', 'ok', 'afvigelse')),
  note text,
  completed_by uuid references auth.users on delete set null,
  completed_at timestamptz
);

-- Fotos
create table if not exists public.fotos (
  id uuid default gen_random_uuid() primary key,
  org_id uuid references public.organizations on delete cascade not null,
  pin_id uuid references public.pins on delete cascade,
  ks_item_id uuid references public.ks_items on delete cascade,
  sag_id uuid references public.sager on delete cascade,
  taken_by uuid references auth.users on delete set null,
  storage_path text not null,
  gps_lat numeric,
  gps_lng numeric,
  taken_at timestamptz default now() not null
);

-- =========================================
-- 2) HELPER FUNCTION til RLS
-- =========================================

create or replace function public.current_org_id()
returns uuid
language sql
stable
security definer set search_path = public
as $$
  select org_id from public.profiles where id = auth.uid()
$$;

-- =========================================
-- 3) ROW LEVEL SECURITY (RLS)
-- Hver bruger ser kun data i sin egen organisation
-- =========================================

alter table public.organizations enable row level security;
alter table public.profiles enable row level security;
alter table public.sager enable row level security;
alter table public.tegninger enable row level security;
alter table public.pins enable row level security;
alter table public.fotos enable row level security;
alter table public.ks_instances enable row level security;
alter table public.ks_items enable row level security;

-- Profiles
drop policy if exists "profiles select own" on public.profiles;
create policy "profiles select own" on public.profiles
  for select using (id = auth.uid() or org_id = public.current_org_id());
drop policy if exists "profiles update own" on public.profiles;
create policy "profiles update own" on public.profiles
  for update using (id = auth.uid());
drop policy if exists "profiles insert own" on public.profiles;
create policy "profiles insert own" on public.profiles
  for insert with check (id = auth.uid());

-- Organizations
drop policy if exists "orgs members can read" on public.organizations;
create policy "orgs members can read" on public.organizations
  for select using (id = public.current_org_id());
drop policy if exists "orgs owners can update" on public.organizations;
create policy "orgs owners can update" on public.organizations
  for update using (id = public.current_org_id() and
    exists (select 1 from public.profiles where id = auth.uid() and role = 'owner'));

-- Sager
drop policy if exists "sager same org" on public.sager;
create policy "sager same org" on public.sager
  for all using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- Tegninger
drop policy if exists "tegninger same org" on public.tegninger;
create policy "tegninger same org" on public.tegninger
  for all using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- Pins
drop policy if exists "pins same org" on public.pins;
create policy "pins same org" on public.pins
  for all using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- Fotos
drop policy if exists "fotos same org" on public.fotos;
create policy "fotos same org" on public.fotos
  for all using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- KS instances
drop policy if exists "ks_instances same org" on public.ks_instances;
create policy "ks_instances same org" on public.ks_instances
  for all using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- KS items
drop policy if exists "ks_items same org" on public.ks_items;
create policy "ks_items same org" on public.ks_items
  for all using (org_id = public.current_org_id())
  with check (org_id = public.current_org_id());

-- =========================================
-- 4) AUTO-CREATE PROFILE + ORG ved signup
-- =========================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  new_org_id uuid;
  user_name text;
  user_company text;
begin
  user_name := coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1));
  user_company := coalesce(new.raw_user_meta_data->>'company', user_name || ''''s firma');

  -- Opret org til den nye bruger
  insert into public.organizations (name, created_by)
  values (user_company, new.id)
  returning id into new_org_id;

  -- Opret profil
  insert into public.profiles (id, email, name, company, org_id, role)
  values (new.id, new.email, user_name, user_company, new_org_id, 'owner');

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- =========================================
-- 5) STORAGE BUCKET til fotos + tegninger
-- =========================================

insert into storage.buckets (id, name, public)
values ('uploads', 'uploads', false)
on conflict (id) do nothing;

-- Storage policy: brugere kan kun uploade til deres org's mappe
drop policy if exists "Users can upload to own org folder" on storage.objects;
create policy "Users can upload to own org folder"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'uploads' and
    (storage.foldername(name))[1] = ('org_' || public.current_org_id()::text)
  );

drop policy if exists "Users can read own org files" on storage.objects;
create policy "Users can read own org files"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'uploads' and
    (storage.foldername(name))[1] = ('org_' || public.current_org_id()::text)
  );

drop policy if exists "Users can delete own org files" on storage.objects;
create policy "Users can delete own org files"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'uploads' and
    (storage.foldername(name))[1] = ('org_' || public.current_org_id()::text)
  );

-- ============================================================
-- FÆRDIG — du kan nu signe op via appen, og din profil + org
-- bliver oprettet automatisk. Hver bruger ser KUN deres egen
-- organisations data (sager, tegninger, pins, fotos).
-- ============================================================
