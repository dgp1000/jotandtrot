# Jot & Trot — Development Schedule to Launch

*Drafted August 2026 · beta live on TestFlight with first real users*

## Where things stand

Shipped and working: iPhone app (Capacitor) on TestFlight · Apple sign-in + email codes · per-user trips with Row Level Security · trip sharing via codes · live-streaming area scouting · auto-built schedules · multi-night hotel stays · voting & budgets · offline itinerary · push notifications ("Leslie added 3 stops") through our own APNs key · night mode.

Domains: **jotandtrot.com and jotandtrot.app registered 7 Aug 2026 (Vercel, auto-renew on).**

## Phase A — Beta polish (Week 1)

Let the crew use the app all week; their complaints set the fix list. Alongside, the known quick wins:

- In-app notification banners (pushes currently show only when the app is backgrounded — small native handler)
- "Who's on this trip" member list; owner can remove a member
- Native share sheet for trip invites (one tap instead of copying a code)
- Activity view: what changed on the trip since you last looked
- Any layout/UX papercuts the crew reports

*Done: jotandtrot.com registered 7 Aug 2026.*

## Phase B — Production map services (Week 2) ⭐ highest value

Scouting and search still depend on free volunteer OpenStreetMap servers, which have twice caused outages during this project. This phase makes the app's core boringly reliable:

- Map tiles → MapTiler or Stadia (free tier covers thousands of users; dark tiles included)
- Geocoding/search → same vendor's API
- Scouting POIs → Geoapify/Foursquare API, or a self-hosted Overpass server (~$20/mo)
- Keep OpenStreetMap attribution (ODbL requirement)

*David's part: create the vendor account (free), hand over the API key.*

## Phase C — Backend split & public-facing pages (Week 3)

- Dedicated Supabase project for Jot & Trot (currently shares the "Bithash" project): migrate schema + data, enable backups
- Sign-in emails from a proper sender on jotandtrot.com (replacing personal Gmail SMTP)
- Static site at jotandtrot.com: landing page + privacy policy + support page (the latter two are App Store requirements)
- Flip APNs to production topic checks; rotate the webhook secret into function env vars

## Phase D — Listing & App Review (Week 4)

- App Store screenshots (6.9" and 6.5" sets), description, keywords, promotional text
- Category: Travel (primary), Productivity (secondary) — decided
- Age rating questionnaire, App Privacy "nutrition label" (email + user content)
- Review notes with a demo account for Apple's reviewer
- Submit. First reviews take 1–3 days; a rejection with a specific reason is normal — fix and resubmit.

## Phase E — Post-launch expansion

Prioritized after talking through where the app goes next (August 2026):

1. **Universal invite links** — ✅ shipped 7 Aug 2026, tested end-to-end on device. jotandtrot.com/join/CODE opens the app if installed (universal links via AASA + LinkPlugin), or an invite web page if not; the native share sheet sends the link.
2. **Web app** — ✅ shipped 7 Aug 2026 at app.jotandtrot.com (Vercel project jotandtrot-app serving the built single-file app; /join/CODE joins after sign-in). Together with #1 these are the growth pair.
3. **Today view (during-trip mode)** — ✅ built 8 Aug 2026. When today falls inside the trip dates: "Up next" hero with Directions (Apple Maps hand-off) and one-tap check-off, TODAY chip + auto-scroll to today's plan, tap the stop number to mark visited (syncs live to the crew, `visited_at/visited_by` on trip_stops), per-day weather icons via Open-Meteo (keyless, 16-day window).
4. **Planning quality** — travel times ✅ built 8 Aug 2026 (Geoapify-routed legs between stops, walk/drive by hop length, day-load estimate in headers, overpacked warnings past ~10h). Still open: opening hours on suggestions and in the auto-scheduler; morning/afternoon/evening slots within days.
5. **Richer collaboration** — comments on stops, date polling before a trip exists ("when can everyone go?"), task assignments ("Leslie books the restaurant"), notes/links/photos per stop.
6. **Expense splitting** — ✅ built 8 Aug 2026, scoped tight as planned: 💸 Split in the trip header logs who paid what (equal split across the crew), shows total and per-head, and computes minimal settle-up transfers; realtime-synced `trip_expenses` table, delete by expense creator/payer/owner.

## Name decision — RESOLVED 7 Aug 2026

Renamed from JollyJaunter to **Jot & Trot** (jot the plan, trot the route). jotandtrot.com and jotandtrot.app registered the same day; codebase, Xcode project, and website copy renamed. Bundle ID changed to com.wavey.jotandtrot before App Store submission.

## Ongoing throughout

- TestFlight builds to the crew at the end of each phase
- Weekly database backup check once on the dedicated project
- Keep the repo in sync (commit + push at each work session's end)

## Deferred / ideas parking lot

Android (Capacitor makes this a modest lift later) · iPad layout (map + plan side by side) · lock-screen widgets / Live Activities for today's plan. (Expense splitting, photos & notes, time-of-day slots, and the web app graduated to Phase E above.)

## Rough cost picture at launch

Apple Developer $99/yr · domain ~$15/yr · map vendor $0 (free tier) to start · Supabase $0 → ~$25/mo when usage grows · optional Overpass VPS ~$20/mo.
