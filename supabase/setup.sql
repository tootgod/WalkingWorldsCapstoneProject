-- Run once in Supabase: Dashboard > SQL Editor > New query > paste > Run.

-- One profile row per player, holding their public username.
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null check (username ~ '^[A-Za-z0-9_]{3,20}$'),
  created_at timestamptz not null default now()
);

-- Usernames are unique ignoring case ("Bob" and "bob" can't both exist).
create unique index profiles_username_lower_idx on public.profiles (lower(username));

-- Row Level Security: nobody can read/write rows unless a policy allows it.
alter table public.profiles enable row level security;

create policy "Logged-in players can see profiles"
  on public.profiles for select
  to authenticated
  using (true);

-- Automatically create the profile when a player signs up.
create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, username)
  values (new.id, new.raw_user_meta_data ->> 'username');
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Lets the sign-up screen check a username before creating the account,
-- without exposing the profiles table to logged-out users.
create function public.username_available(name text)
returns boolean
language sql
stable
security definer set search_path = ''
as $$
  select not exists (
    select 1 from public.profiles where lower(username) = lower(name)
  );
$$;

grant execute on function public.username_available(text) to anon, authenticated;
