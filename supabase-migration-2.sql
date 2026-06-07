-- =====================================================
-- TradeFlow — Migration 2 — Cloud sync columns
-- =====================================================
-- Kør HELE denne fil i Supabase SQL Editor → Run

-- Tilføj category til tegninger (Molio A104-stil)
alter table public.tegninger add column if not exists category text default 'A';

-- Tilføj assigned_to_name til pins (når man sender forespørgsel til håndværker)
alter table public.pins add column if not exists assigned_to_name text;

-- Tilføj photo-ids array til ks_items (foto-links pr checkpoint)
alter table public.ks_items add column if not exists photo_ids text[];

-- Tilføj fields til fotos-tabellen som klienten har lokalt
alter table public.fotos add column if not exists tegning_id uuid references public.tegninger on delete cascade;

-- Ensure all upserts work — Allow user to insert/update rows with the
-- new policies (they already exist from earlier schema)

-- =====================================================
-- FÆRDIG
-- =====================================================
