# BR Explorer iOS — Screen Content Priority

Source: legacy screenshots (`/screenshots`) + `prd.md`. Legacy app = phone+password login, no OTP. PRD wants OTP flow (modernize). Legacy has no journey-planner home — just icon grid. We redesign per PRD but carry over real data fields so mock data feels authentic.

---

## Screen 1: Login (Phone + Password)

Deviates from PRD's OTP spec — going with phone+password instead, matches legacy flow exactly.

Legacy shows: phone number (prefilled `01797751266`), password field, Sign In, Forgot Password, Sign Up, FAQ/Info links top-left.

Priority for new login screen:
1. **Phone number** — input, +880 prefix, legacy format `01797751266` (11-digit local, drop leading 0 after +880).
2. **Password** — input w/ show/hide eye toggle (kept from legacy).
3. **Primary action** — Sign In, full-width, w/ loading state (Idle/Loading/Success/Error per PRD's original state-hoisting intent, just no OTP).
4. **Forgot password** — secondary action, kept.
5. **Sign up** — new user entry, bottom.
6. Drop: FAQ/info chips — not needed for prototype.

---

## Screen 2: Home Dashboard

Legacy shows (top → bottom): app logo+version, notification bell, hamburger menu, "Places of Interest" banner/promo card, red "Onboard Extras / Arrival Alert" strip, 3×icon grid — Train, Search, Account, Routes, Amenity, Fare, Ticket, Freight, Predict, About.

PRD wants journey-planner-first design. Reconcile — show in this order:
1. **Greeting + avatar/bell** (top header) — from legacy header pattern.
2. **Journey Planner card** (new, elevated) — From/To station, swap icon, date, Search Trains button. This is the #1 job-to-be-done (legacy buries it — user has to tap "Train" then search; we surface it immediately).
3. **Quick actions row** — trim legacy's 10-icon grid down to top 3 by evident usage: **Live Tracking** (legacy "Train"/location-of-train screen), **Train Schedules**, **Fare Calculator** (legacy "Fare"). Rest (Account, Routes, Amenity, Ticket, Freight, Predict, About) deferred to a "More" surface later, not on dashboard.
4. **Live status snippet** — maps to legacy's "Location of Train" screen: show active/last-searched trip as a compact card (train name/number + on-time badge), tap-through to full map.
5. **Places of Interest promo** — legacy's big banner; kept but lowest priority, below live status (marketing content, not task-critical).
6. **Bottom nav** — Home / Search / Live Map / Profile (Account).
7. Drop from dashboard: Onboard Extras/Arrival Alert strip, About, Predict, Freight, Amenity — not core to booking/tracking flow.

---

## Screen 3: Train Search & Schedule Results (Map + List)

Legacy "Location of Train" screen is the closest analog — real fields to reuse as mock data:
1. **Train identity** — number + name (`725 Sundarban`).
2. **Route** — origin–destination (`Khulna–Dhaka`).
3. **Departure time** — "Left Khulna at 21:45".
4. **ETA / arrival time** — "ETA at Dhaka: 05:14".
5. **Live position** — "Now at Jashore Jn", next stop + ETA — drives the map marker + live-dot tag.
6. **Delay** — "Delay: 00:04" — feeds the "On Time"/delayed badge.
7. **Coach info** (total coaches, coach position) — secondary detail, not on card, maybe expandable.
8. **Current speed, last update timestamp** — lowest priority, map overlay only if space allows.
9. Ticket classes + base fares — not in legacy screenshot but required by PRD for result cards — add as mock data per train.
10. Legal disclaimer text — drop from UI (not user-critical for prototype).

Card priority order (top→bottom per result card): Train Name/Number → Departure/ETA times → Live indicator (if active) → ticket classes/fares row.

---

## Cross-screen notes
- Real phone number format from legacy: 11-digit BD mobile starting `01`. Use for mock/test data.
- Legacy is a dark-only app; PRD doesn't mandate dark mode — can go Material/custom light or dark, but dark theme is safe default matching brand familiarity.
- Legacy branding: red "BR" square logo mark, version stamp — keep red as accent color for continuity.
