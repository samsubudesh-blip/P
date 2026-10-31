-- Семейный календарь: выполнить в Supabase SQL Editor один раз
create table if not exists public.family_events (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 120),
  event_date date not null,
  event_time time,
  reminder_minutes integer not null default 0 check (reminder_minutes in (0,15,60,1440)),
  color text not null default 'blue' check (color in ('blue','green','orange','pink')),
  place text,
  description text,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.family_events enable row level security;
drop policy if exists "family members can read events" on public.family_events;
create policy "family members can read events" on public.family_events
for select to authenticated using (true);
drop policy if exists "family members can add events" on public.family_events;
create policy "family members can add events" on public.family_events
for insert to authenticated with check (auth.uid() = created_by);
drop policy if exists "family members can edit events" on public.family_events;
create policy "family members can edit events" on public.family_events
for update to authenticated using (true) with check (true);
drop policy if exists "family members can delete events" on public.family_events;
create policy "family members can delete events" on public.family_events
for delete to authenticated using (true);
create index if not exists family_events_event_date_idx on public.family_events(event_date);
