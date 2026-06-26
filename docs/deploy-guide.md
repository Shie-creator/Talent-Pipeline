# Cloudflare Pages + Supabase Deploy Guide

## 1. Create the Supabase project

1. Go to Supabase and create a new project.
2. Open **SQL Editor**.
3. Paste the contents of `supabase/schema.sql`.
4. Click **Run**.

This creates the shared tables, turns on Row Level Security, and makes the public anon role read-only.

## 2. Create your editor login

1. In Supabase, open **Authentication** > **Users**.
2. Click **Add user**.
3. Enter your editor email and password.
4. Keep this as the only editor account.

Do not put this password in Cloudflare. Do not use the Supabase service-role key in the app.

## 3. Get the public Supabase keys

1. In Supabase, open **Project Settings** > **API**.
2. Copy the **Project URL**.
3. Copy the **anon public** key.

These two values are safe in the browser because RLS only allows public reads.

## 4. Deploy to Cloudflare

1. Push this folder to a private GitHub repository.
2. In Cloudflare, open **Workers & Pages** > **Create application** and connect the GitHub repository.
3. Connect the GitHub repository.
4. Use these build settings:
   - Framework preset: **None**
   - Build command: `npm run build`
   - Deploy command: `npx wrangler deploy`
   - Non-production branch deploy command: `npx wrangler versions upload`
   - Path / root directory: `/`
5. Add environment variables:
   - `SUPABASE_URL`: your Supabase Project URL
   - `SUPABASE_ANON_KEY`: your Supabase anon public key
6. Click **Save and Deploy**.

The `wrangler.toml` file tells Cloudflare to deploy the generated `dist` folder as static assets. Cloudflare gives you one public URL. Your team opens that URL with no account and gets view-only access.

## 5. Seed your candidates

Use the deployed page itself:

1. Open the Cloudflare public URL.
2. Click **Log in** and enter your Supabase editor email/password.
3. Click **Replace from .xlsx/CSV**.
4. Choose the candidate CSV with these headers:
   `Candidate, Role, Location, Employment, Status, Pre-screen, Initial, Final, Offer sent, Offer accepted, Recruiter notes, Mike comment, Dr Priti feedback, Reason`
5. Confirm the replacement.

The import writes to Supabase as your authenticated editor account. After that, every viewer sees the current shared database.

## 6. Optional realtime

The app subscribes to Supabase realtime for `candidates` and `app_settings`. If updates do not appear live, viewers can refresh; the database is still the source of truth.
