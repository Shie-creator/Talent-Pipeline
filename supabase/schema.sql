create extension if not exists pgcrypto;

create table if not exists public.candidates (
  id uuid primary key default gen_random_uuid(),
  name text not null default '',
  role text not null default 'Unspecified',
  location text not null default '',
  emp text not null default '',
  status text not null default '',
  pre text not null default '',
  init text not null default '',
  fin text not null default '',
  "oSent" text not null default '',
  "oAcc" text not null default '',
  "recFeedback" text not null default '',
  "mikeComment" text not null default '',
  "pritiFeedback" text not null default '',
  reason text not null default '',
  "emailSent" boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.app_settings (
  id boolean primary key default true,
  "thPre" integer not null default 4,
  "thInit" integer not null default 3,
  "thFinal" integer not null default 2,
  "thOffer" integer not null default 5,
  "enPre" boolean not null default true,
  "enInit" boolean not null default true,
  "enFinal" boolean not null default true,
  "enOffer" boolean not null default true,
  "enReject" boolean not null default true,
  "refDate" text not null default '',
  updated_at timestamptz not null default now(),
  constraint app_settings_singleton check (id)
);

insert into public.app_settings (id)
values (true)
on conflict (id) do nothing;

create table if not exists public.change_log (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  actor_email text not null default '',
  action text not null check (action in ('add','edit','delete')),
  candidate_id uuid,
  candidate_name text not null default '',
  field text not null default '',
  old_value text not null default '',
  new_value text not null default ''
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_candidates_updated_at on public.candidates;
create trigger set_candidates_updated_at
before update on public.candidates
for each row execute function public.set_updated_at();

drop trigger if exists set_app_settings_updated_at on public.app_settings;
create trigger set_app_settings_updated_at
before update on public.app_settings
for each row execute function public.set_updated_at();

alter table public.candidates enable row level security;
alter table public.app_settings enable row level security;
alter table public.change_log enable row level security;

drop policy if exists "Public can view candidates" on public.candidates;
create policy "Public can view candidates"
on public.candidates for select
using (true);

drop policy if exists "Authenticated editor can insert candidates" on public.candidates;
create policy "Authenticated editor can insert candidates"
on public.candidates for insert
to authenticated
with check (true);

drop policy if exists "Authenticated editor can update candidates" on public.candidates;
create policy "Authenticated editor can update candidates"
on public.candidates for update
to authenticated
using (true)
with check (true);

drop policy if exists "Authenticated editor can delete candidates" on public.candidates;
create policy "Authenticated editor can delete candidates"
on public.candidates for delete
to authenticated
using (true);

drop policy if exists "Public can view app settings" on public.app_settings;
create policy "Public can view app settings"
on public.app_settings for select
using (true);

drop policy if exists "Authenticated editor can insert app settings" on public.app_settings;
create policy "Authenticated editor can insert app settings"
on public.app_settings for insert
to authenticated
with check (id = true);

drop policy if exists "Authenticated editor can update app settings" on public.app_settings;
create policy "Authenticated editor can update app settings"
on public.app_settings for update
to authenticated
using (id = true)
with check (id = true);

drop policy if exists "Authenticated editor can delete app settings" on public.app_settings;
create policy "Authenticated editor can delete app settings"
on public.app_settings for delete
to authenticated
using (id = true);

drop policy if exists "Public can view change log" on public.change_log;
create policy "Public can view change log"
on public.change_log for select
using (true);

drop policy if exists "Authenticated editor can insert change log" on public.change_log;
create policy "Authenticated editor can insert change log"
on public.change_log for insert
to authenticated
with check (true);
