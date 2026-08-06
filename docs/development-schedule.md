# JollyJaunter — Development Schedule to Launch

*Drafted August 2026 · beta live on TestFlight with first real users*

## Where things stand

Shipped and working: iPhone app (Capacitor) on TestFlight · Apple sign-in + email codes · per-user trips with Row Level Security · trip sharing via codes · live-streaming area scouting · auto-built schedules · multi-night hotel stays · voting & budgets · offline itinerary · push notifications ("Leslie added 3 stops") through our own APNs key · night mode.

Domains: **jollyjaunter.com and jollyjaunter.app were available as of this writing — register the .com immediately.**

## Phase A — Beta polish (Week 1)

Let the crew use the app all week; their complaints set the fix list. Alongside, the known quick wins:

- In-app notification banners (pushes currently show only when the app is backgrounded — small native handler)
- "Who's on this trip" member list; owner can remove a member
- Native share sheet for trip invites (one tap instead of copying a code)
- Activity view: what changed on the trip since you last looked
- Any layout/UX papercuts the crew reports

*Also this week (10 minutes, David): register jollyjaunter.com.*

## Phase B — Production map services (Week 2) ⭐ highest value

Scouting and search still depend on free volunteer OpenStreetMap servers, which have twice caused outages during this project. This phase makes the app's core boringly reliable:

- Map tiles → MapTiler or Stadia (free tier covers thousands of users; dark tiles included)
- Geocoding/search → same vendor's API
- Scouting POIs → Geoapify/Foursquare API, or a self-hosted Overpass server (~$20/mo)
- Keep OpenStreetMap attribution (ODbL requirement)

*David's part: create the vendor account (free), hand over the API key.*

## Phase C — Backend split & public-facing pages (Week 3)

- Dedicated Supabase project for JollyJaunter (currently shares the "Bithash" project): migrate schema + data, enable backups
- Sign-in emails from a proper sender on jollyjaunter.com (replacing personal Gmail SMTP)
- Static site at jollyjaunter.com: landing page + privacy policy + support page (the latter two are App Store requirements)
- Flip APNs to production topic checks; rotate the webhook secret into function env vars

## Phase D — Listing & App Review (Week 4)

- App Store screenshots (6.9" and 6.5" sets), description, keywords, promotional text
- Category: Travel (primary), Productivity (secondary) — decided
- Age rating questionnaire, App Privacy "nutrition label" (email + user content)
- Review notes with a demo account for Apple's reviewer
- Submit. First reviews take 1–3 days; a rejection with a specific reason is normal — fix and resubmit.

## Ongoing throughout

- TestFlight builds to the crew at the end of each phase
- Weekly database backup check once on the dedicated project
- Keep the repo in sync (commit + push at each work session's end)

## Deferred / ideas parking lot

Expense splitting between trip members · trip photos & notes · time-of-day scheduling within days · Android (Capacitor makes this a modest lift later) · web app at app.jollyjaunter.com sharing the same backend.

## Rough cost picture at launch

Apple Developer $99/yr · domain ~$15/yr · map vendor $0 (free tier) to start · Supabase $0 → ~$25/mo when usage grows · optional Overpass VPS ~$20/mo.
