# Test Checklist

## Anonymous public visitor

1. Open the Cloudflare URL in a private/incognito window.
2. Confirm the dashboard loads without logging in.
3. Confirm search, sort, filter tabs, role filters, reason filters, notes expansion, expand-all-feedback, and CSV export work.
4. Confirm Add, Edit, Delete, quick action buttons, Flag rules, Replace-from-xlsx/CSV, and Reload original are not available.
5. In the browser console, try an anonymous write:

```js
await supabase.createClient(
  window.PIPELINE_CONFIG.supabaseUrl,
  window.PIPELINE_CONFIG.supabaseAnonKey
).from('candidates').insert({ name: 'RLS Test' })
```

Expected result: Supabase returns an RLS error and no row is inserted.

## Logged-in editor

1. Click **Log in** and sign in with your editor email/password.
2. Add a test candidate.
3. Edit that candidate.
4. Use a quick action.
5. Delete the candidate, confirming the two-click delete behavior.
6. Change one flag rule and the shared as-of date.

Expected result: all saves succeed and survive refresh.

## Fresh anonymous load

1. Log out or open a new private/incognito window.
2. Open the Cloudflare URL again.
3. Confirm the latest candidates, flag rules, and as-of date are visible.
4. Confirm write controls are gone again.
