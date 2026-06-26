const fs = require("fs");
const path = require("path");

const required = ["SUPABASE_URL", "SUPABASE_ANON_KEY"];
const missing = required.filter((key) => !process.env[key]);

if (missing.length) {
  console.error(`Missing required environment variables: ${missing.join(", ")}`);
  console.error("In Cloudflare Pages, add them under Settings > Environment variables for Production, then redeploy.");
  process.exit(1);
}

const root = path.resolve(__dirname, "..");
const src = path.join(root, "index.html");
const outDir = path.join(root, "dist");
const out = path.join(outDir, "index.html");

let html = fs.readFileSync(src, "utf8");
html = html
  .replaceAll("%SUPABASE_URL%", process.env.SUPABASE_URL)
  .replaceAll("%SUPABASE_ANON_KEY%", process.env.SUPABASE_ANON_KEY);

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(out, html);
fs.writeFileSync(
  path.join(outDir, "_headers"),
  [
    "/*",
    "  X-Content-Type-Options: nosniff",
    "  Referrer-Policy: strict-origin-when-cross-origin",
    "  Permissions-Policy: camera=(), microphone=(), geolocation=()",
    ""
  ].join("\n")
);

console.log("Built dist/index.html for Cloudflare Pages.");
