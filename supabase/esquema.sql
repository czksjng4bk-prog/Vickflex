-- VickFlex Descanso · tabla donde la app guarda los datos
-- Cópialo entero en Supabase › SQL Editor › New query y pulsa «Run». Solo hace falta una vez.
-- Cada usuario tiene una sola fila con todos sus datos (representantes, clientes, facturación, visitas, coche expositor…).

create table if not exists public.vickflex_datos (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null,
  version    bigint not null default 1,
  updated_at timestamptz not null default now()
);

-- Seguridad: cada usuario solo puede ver y cambiar su propia fila.
alter table public.vickflex_datos enable row level security;

drop policy if exists "vickflex leer lo mio" on public.vickflex_datos;
drop policy if exists "vickflex crear lo mio" on public.vickflex_datos;
drop policy if exists "vickflex cambiar lo mio" on public.vickflex_datos;

create policy "vickflex leer lo mio" on public.vickflex_datos
  for select to authenticated using (auth.uid() = user_id);
create policy "vickflex crear lo mio" on public.vickflex_datos
  for insert to authenticated with check (auth.uid() = user_id);
create policy "vickflex cambiar lo mio" on public.vickflex_datos
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
