-- Моё меню: облачное хранение данных пользователей
-- Выполни весь SQL в Supabase Dashboard → SQL Editor → New query.
create table if not exists public.menu_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{"products":[],"plan":[],"shopping":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.menu_user_data enable row level security;

drop policy if exists "Users can read own menu data" on public.menu_user_data;
create policy "Users can read own menu data"
on public.menu_user_data for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert own menu data" on public.menu_user_data;
create policy "Users can insert own menu data"
on public.menu_user_data for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update own menu data" on public.menu_user_data;
create policy "Users can update own menu data"
on public.menu_user_data for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant select, insert, update on public.menu_user_data to authenticated;
