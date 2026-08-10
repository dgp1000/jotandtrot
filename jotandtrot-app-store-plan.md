# Jot & Trot — Path to the Apple App Store

*Prepared August 2026*

## Where Jot & Trot stands today

Jot & Trot is a single-file web app: Leaflet map, vanilla JS, and a shared Supabase backend (Postgres + realtime). That architecture was perfect for getting here fast, but three things about it must change before it can be a public App Store product, independent of anything Apple requires.

**1. Accounts and data privacy.** Today every copy of Jot & Trot shares one database with one public key — anyone with the file can see and edit anyone's trips. Before strangers download this, it needs Supabase Auth (Sign in with Apple is mandatory if you offer any social login) and Row Level Security policies so each user sees only their own trips, plus share-links for inviting Leslie or Will to a specific trip. This is the single biggest work item and it touches everything.

**2. Map and data services on production terms.** Jot & Trot currently uses free community services: OpenStreetMap tiles, Nominatim geocoding, and public Overpass servers for scouting. All three explicitly disallow or throttle production app traffic. The Tokyo scouting slowness you hit is that reality showing. For a shipped app: map tiles from MapTiler, Mapbox, or Stadia (free tiers cover thousands of users); geocoding/search from the same vendor; and scouting either from a paid POI API (Foursquare, Geoapify) or a self-hosted Overpass instance (~$20/mo VPS). OpenStreetMap attribution must remain visible per the ODbL license.

**3. A privacy policy and support page.** Apple requires a public privacy policy URL and support URL for every listing. One static page each is fine.

## The technical path: wrap, don't rewrite

The pragmatic route is **Capacitor** — it wraps the existing web app in a real native iOS shell, giving access to native APIs without rewriting the UI. React Native or SwiftUI rewrites are months of work for little user-visible gain at this stage.

One caution: Apple's guideline 4.2 ("minimum functionality") rejects apps that are just a website in a box. Jot & Trot clears this by adding a few native capabilities that also make the app better:

- **Push notifications** — "Leslie added 3 stops to Tokyo" (Capacitor Push + Supabase realtime webhooks)
- **Offline itinerary** — cache your trip so the day's schedule works without data while traveling (huge real-world value)
- **Native share sheet** — share a trip invite from the app
- **Haptics and app icon/splash** — small, cheap polish that reads as "real app"

Note: as of 2026, Capacitor apps must be built with the current Xcode (Xcode 26) — keep the toolchain updated.

## What you'll need

- **Apple Developer Program: $99/year** (still the 2026 price)
- **A Mac with Xcode**, or a cloud build service (Codemagic, Ionic Appflow, Xcode Cloud) if you don't have one
- **App identity:** the name "Jot & Trot" is distinctive, so it is very likely available — still confirm with a quick App Store search before committing. Register the bundle ID (e.g. `com.wavey.jotandtrot`) early; grab jotandtrot domains/social handles at the same time.
- **Assets:** 1024px app icon, screenshots for 6.9" and 6.5" iPhones (and iPad if you support it), a short description and keyword list

## Suggested phases

**Phase 1 — Foundations. ✅ Mostly complete (Aug 2026).** Shipped: email one-time-code sign-in (Supabase Auth), Row Level Security on every table, per-trip sharing via membership-granting share codes, and votes tied to accounts. Auth decisions made: passwordless-only (no passwords — no reset flows or breach surface; email codes are the universal method), with Sign in with Apple arriving in Phase 2 via the native flow (not required by Apple's rules since we offer no other third-party logins — it's purely an experience upgrade). Map/geocoding/POI services migrated to Geoapify (done — see Phase B in docs/development-schedule.md). Still open from this phase: custom SMTP for sign-in emails (the built-in service is limited to a few per hour), a dedicated Supabase project for Jot & Trot (it currently shares the "Bithash" project), and privacy policy + support pages.

**Phase 2 — Wrap it.** Capacitor project, app icon/splash, offline caching, push notifications, share sheet, and Sign in with Apple through the native AuthenticationServices flow (one Capacitor plugin + Supabase signInWithIdToken). First builds on your own phone, then TestFlight.

**Phase 3 — Beta.** TestFlight with your actual travel crew (up to 10,000 external testers). Real trips, real airports, flaky hotel wifi — this is where offline mode earns its keep.

**Phase 4 — Submission.** App Privacy "nutrition label" (what data you collect — with auth it's at minimum email + user content), age rating questionnaire, review notes with a demo account. First reviews take 1–3 days; rejections are normal and usually specific — fix and resubmit.

## Costs at a glance

Apple $99/yr · map/geocoding vendor free tier to start · Supabase free tier is fine through beta, ~$25/mo Pro when real users arrive · optional self-hosted Overpass ~$20/mo · optional cloud Mac builds ~$0–40/mo.

## What I'd do next, in order

1. Confirm "Jot & Trot" is free in App Store search (it almost certainly is)
2. Buy the Apple Developer membership (activation takes a day or two)
3. Start Phase 1 with auth + RLS — I can build this in the current codebase now
4. Pick the map vendor (I'd default to MapTiler's free tier) and I'll swap the tile/geocoding layers

Sources: [Apple Developer — Submitting to the App Store](https://developer.apple.com/app-store/submitting/) · [Apple Developer Program Fee 2026](https://ambsandigital.com/apple-developer-program-fee-2026/) · [Xcode 26 requirement for Capacitor apps](https://capawesome.io/blog/xcode-26-requirement-for-capacitor-apps/) · [iOS Distribution Guide 2026](https://foresightmobile.com/blog/ios-app-distribution-guide-2026)
