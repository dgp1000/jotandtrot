# Jot & Trot — App Store listing (v1.0)

Everything below is ready to paste into App Store Connect. Character
limits are noted and all fields fit.

## App Information

- **Name** (24/30): `Jot & Trot: Trip Planner`
- **Subtitle** (25/30): `Plan trips with your crew`
- **Primary category:** Travel
- **Secondary category:** Productivity
- **Content rights:** does not contain third-party content
- **Age rating:** answer **None** to every content question → **4+**

## Version Information

**Promotional text** (149/170):

> Scout ideas on a live map, vote with your crew, auto-build your days,
> then split the bill at the end. Trip planning that feels like part of
> the trip.

**Description:**

> Jot & Trot is a collaborative trip planner for groups of friends — plan
> day by day on a live map, together.
>
> Start with a destination. Scout the area and watch sights, restaurants,
> and hotels stream onto the map. Vote on what makes the cut, then let
> Jot & Trot auto-build your schedule — stops grouped by neighbourhood,
> meals spaced between sights, hotels checked in and out on the right
> days.
>
> PLAN TOGETHER
> • Share a trip with one link — friends tap it and they're in
> • Everything syncs live: stops, votes, comments, photos
> • Can't agree on dates? Run a date poll: propose windows, vote, done
> • Assign tasks — "Leslie books the restaurant" — and check them off
>
> A SCHEDULE YOU CAN TRUST
> • Real walking and driving times between stops
> • A day-load estimate and a warning when a day is overpacked
> • Opening hours, with a heads-up when a stop may be closed that day
> • Morning, afternoon, and evening slots to shape each day
> • Per-day weather in your plan
>
> ON THE TRIP
> • Today view: what's next, one tap to navigate in Apple Maps
> • Check off stops as you go — the whole crew sees progress
> • Your itinerary works offline; budgets stay tallied per day and per trip
> • Split expenses: log who paid, settle up with the fewest transfers
>
> Jot & Trot is free while in early release. Map data © OpenStreetMap
> contributors; maps and places by Geoapify.

**Keywords** (90/100):

```
travel,itinerary,group,friends,vacation,holiday,map,planner,expenses,split,journey,weekend
```

**Support URL:** https://jotandtrot.com/support.html
**Marketing URL:** https://jotandtrot.com
**Privacy Policy URL:** https://jotandtrot.com/privacy.html
**Copyright:** © 2026 David Perkins

## Screenshots (in this folder)

Upload order tells the story: plan → today → map → dark → (iPad).

6.5" iPhone (1284×2778) — the size App Store Connect asks for; use the `as65-*` files:
1. `as65-2-plan-today.png` — Today view hero, weather, travel times
2. `as65-3-plan-days.png` — day-by-day plan, budgets, walking legs
3. `as65-1-map.png` — map with numbered stops and route
4. `as65-4-map-dark.png` — night mode

(6.9"-class versions at 1290×2796 — the `as1..as4` files — kept in case a
6.9" slot appears under "View All Sizes"; regenerate any size with
`SIZE=65 node appstore-shots.js` / `node appstore-shots.js`.)

13" iPad (2064×2752):
5. `as-ipad1.png` — wide layout, plan + map side by side

## App Privacy (nutrition label)

"Do you collect data?" → **Yes**. Then:

| Data type | Collected? | Linked to user? | Tracking? | Purpose |
|---|---|---|---|---|
| Contact Info → Email Address | Yes | Yes | No | App Functionality (sign-in) |
| User Content → Photos or Videos | Yes | Yes | No | App Functionality (stop photos) |
| User Content → Other User Content | Yes | Yes | No | App Functionality (trips, stops, comments) |
| Identifiers → User ID | Yes | Yes | No | App Functionality (account) |

Everything else: not collected. No tracking, no ads, no analytics.

## App Review Information

- **Sign-in required:** yes → check the box and note:
  > The reviewer can use Sign in with Apple — no demo account needed.
  > Email one-time-code sign-in also works with any email address.
- **Contact:** David Perkins · +1 917 704 0692 · dgperkins@gmail.com
- **Notes (suggested):**
  > Jot & Trot is a collaborative trip planner. New accounts receive a
  > pre-populated example trip (Lisbon) so all features are visible
  > immediately: the map, day-by-day plan, travel times, weather,
  > expense split, comments, and photos. Location permission is never
  > requested; maps use OpenStreetMap/Geoapify data.

## Submission checklist

1. App Store Connect → Jot & Trot → **1.0 Prepare for Submission**
2. Paste fields above; upload the 4 iPhone + 1 iPad screenshots
3. Select build **1.0 (12)** (already processed via TestFlight)
4. App Privacy → answer per the table
5. Age rating questionnaire → all None
6. Pricing: Free · all territories (or trim)
7. Submit for Review — first reviews typically take 1–3 days; a
   rejection with a specific reason is normal, fix and resubmit.
