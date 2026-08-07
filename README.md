# Jot & Trot 🧭

A collaborative trip planner in a single HTML file. Map-first itineraries with
live area scouting, auto-built schedules, multi-night hotel stays, voting,
budgets, and real-time sync.

## Features
- **Map-first planning** — search places (scoped to the current map view), click the map, or scout an area; day routes draw on the map with numbered pins
- **✨ Scouting** — finds sights, restaurants, and hotels around wherever the map is looking (OpenStreetMap/Overpass), streaming onto the map live; stoppable mid-search; works in dense cities
- **⚡ Auto-build schedule** — slots every idea into your days, grouped by area, meals between sights, hotels as multi-night stays split across the trip
- **🛏️ Hotel stays** — check-in/check-out days, "staying at" shown through the stay, nightly costs in each day's budget
- **Collaboration** — shared trips, votes on stops, live sync (Supabase realtime)
- **Budgets** — per-stop costs, per-day totals, trip total in the trip's currency

## Structure
- `app.template.html` — the app source (edit this)
- `lib/` — vendored Leaflet + Supabase JS (inlined at build time)
- `build.py` — assembles the shippable single file
- `jotandtrot.html` — the built app (open in any browser)
- `docs/jotandtrot-app-store-plan.md` — roadmap to the Apple App Store

## Build
```
python3 build.py
```

## Backend
Supabase (Postgres + realtime + auth). Tables: `trip_trips`, `trip_stops`,
`trip_suggestions`, `trip_votes`, `trip_members`.

**Security (Phase 1 complete):** sign-in is required (email one-time codes via
Supabase Auth). Row Level Security is enforced on every table: users see only
trips they own or have joined; joining happens through a share code
(`jj_join_trip` RPC); votes are tied to the voting account; only owners can
delete a trip. The bundled publishable key grants nothing without a signed-in
session.

Map data © OpenStreetMap contributors (ODbL). Geocoding by Nominatim; POI
scouting via Overpass API.

## iOS app (Phase 2)

The `ios/` folder is a Capacitor project (Swift Package Manager — no CocoaPods
needed). To run Jot & Trot on an iPhone:

1. On a Mac with Xcode: `open ios/App/JotAndTrot.xcodeproj`
2. Select the `JotAndTrot` scheme and your iPhone (or a simulator), set your Apple
   Developer team under Signing & Capabilities, and hit Run.
3. After changing the web app: `npm run ios` (rebuilds `jotandtrot.html`,
   copies it into `www/`, and syncs it into the iOS project), then run again
   from Xcode.

Bundle ID: `com.wavey.jotandtrot`. Icon/splash sources live in `assets/` —
regenerate the full iOS set with `npx @capacitor/assets generate --ios`.
