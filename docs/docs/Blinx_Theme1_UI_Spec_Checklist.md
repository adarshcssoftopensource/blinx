# Blinx App – Theme 1 UI Spec Handoff Checklist (V1.8)

## Purpose

Define the design system and UI requirements for adopting **Theme 1** across all screens in Blinx.  This checklist consolidates the behaviors and visual patterns from the **Use‑Case Specification V1.4** and **Wireframes V1.8** and sets the criteria for design QA and engineering implementation.

Theme 1 is the final design direction for the MVP.  There should be **no redrawing or rebuilding** of screens created under Theme 2.  Instead, apply Theme 1 by swapping design tokens at the library level.  Keep Theme 2 token definitions archived for future experiments but do not use them for the MVP.

## 1. Design Tokens

- **Colors:**  Define color roles for primary/secondary/background/surface, neutrals, success, warning and error.  Assign semantic roles for status chips (Pending review, Verified, Unverified, Urgent) and map pins (Safety, Services, Events).
- **Typography:**  Use the Inter family with documented sizes, weights and line‑heights for display, headlines, body and captions.  Support OS dynamic type scales on iOS and Android.
- **Spacing & Grid:**  Adopt an 8 pt base grid.  All tappable elements must have a minimum **44 × 44 pt** hit target.
- **Radii & Elevation:**  Document corner radii for cards, sheets, chips and buttons.  Specify elevation levels (shadow depths) for surfaces such as modals and bottom sheets.
- **States:**  Provide token values for default, hover, pressed, disabled and focus states on interactive elements.

## 2. Components

Implement Theme 1 styling on the following reusable components:

- **Buttons:**  Primary, secondary, tertiary and destructive variants; include loading and disabled states.
- **Chips:**  Filter chips (All, Safety, Environment, Community Events, Local Business, Public Spaces, Infrastructure), input chips and status badges.
- **Badges:**  Label chips for status (*Pending review*, *Verified*, *Unverified*, *Urgent*).  Ensure colors follow semantic roles defined in the tokens.
- **Inputs:**  Text, password and search fields with validation messaging.  Support 12‑character minimum password requirement in sign‑in and reset flows.
- **Banners & Toasts:**  Non‑modal banners such as “Blinks Near You”, connection errors and success messages (e.g. “Reported successfully”).  Define in‑app alert toast styles.
- **Cards & Lists:**  Post feed items, comment rows, draft rows and user lists.  Include spacing, margins and avatar sizes.
- **Sheets & Modals:**  Bottom sheets (share sheet entry), report drawer and system prompts.  Align with platform guidelines.
- **Map Pins & Legend:**  Pins colored for each topic category; cluster pins display a count.  Provide a legend component.

## 3. Screens & Flows

### Onboarding & Auth
- **Onboarding:**  Three introductory panels explaining the purpose of Blinx with Next/Skip controls; no permission requests here.
- **Sign‑Up:**  Capture full name, email and password (min 12 characters).  Include Apple and Google sign‑in buttons.  Link to Terms and Privacy.
- **Sign‑In:**  Email/password fields, sign‑in with Google/Apple, “Forgot password” link.
- **Forgot/Reset Password:**  Two‑step flow for requesting a reset and entering a new password.

### Home Feed
- **Banner:**  Show “Blinks Near You” banner when location/Bluetooth is off; tapping opens OS settings.  Do not automatically open a Blink.
- **Status Chips:**  Display *Pending review*, *Verified* or *Unverified* on Safety posts.  Only **Verified** blinks can be externally shared.  Urgent posts float to the top only **after verification**.
- **Share:**  Tapping share opens the **native OS share sheet** with a copy‑link action.  Use the deep link `blinx://b/{id}` if the app is installed; otherwise use the web fallback `https://blinx.app/b/{id}`.  Disable share on Pending and Unverified blinks.

### Map
- **Filters:**  Use filter chips for All, Safety, Services, Events; chips control the pins shown on the map.
- **Pins & Legend:**  Pins are colored by topic and cluster into counts.  Include a legend overlay explaining the colors.
- **Controls:**  Provide a **Use This Area** button that appears after the user pans/zooms the map; pressing it reloads the feed based on the visible region.  Provide a **Re‑center** button that returns the map to the user’s current location when the camera is off‑centre.

### Composer (Create Blink)
- **Required Fields:**  Description, **Topic** (Safety/Environment/Community Events/Local Business/Public Spaces/Infrastructure) and location.
- **Visibility:**  Allow posts to be **Public** or **Private**; include helper text.  Remind users not to share personal information.
- **Urgent (Safety only):**  When Topic is Safety, show a **Mark as urgent** toggle with a note that urgent posts may take longer to appear due to moderation.
- **Drafts:**  Support auto‑saving drafts offline for up to 30 days.  Include a “Publish when online” banner if the device is offline.

### Blink Details & Moderation
- **Details:**  Show post content, author, status chip, related topics, like/comment/share actions and an action row.
- **Report & Block:**  Provide a report drawer with selectable reasons and optional note; after submission show a success toast.  Allow users to block the author; blocked users can be unblocked in Settings.

### Topic Feed
- **Select Topic:**  Present a grid of topics; after selecting, show a feed with **Recent** and **Nearby** tabs.  Nearby items include distance chips.

### Settings & Data Preferences
- **Profile:**  Show user profile with name, email, and a grid of the user’s blinks.  Allow editing name and email.
- **Data Preferences:**  Allow users to choose how their name appears on posts (Full name, Username, Anonymous) and whether their profile is searchable.  Provide a **Delete Account** action.
- **Notifications:**  Include a master notifications toggle and individual toggles for each alert category (Safety, Environment, Community Events, Local Business, Public Spaces, Infrastructure, Proximity Alerts).  Provide a **Quiet Hours** time range picker; all alerts must respect this range.
- **Drafts:**  List saved drafts with timestamp; allow opening to edit and publish.
- **Block Users:**  List blocked users with options to unblock.
- **Change Password:**  Allow updating password with validation (min 12 characters).

### Proximity Alerts & Error States
- **Proximity Alerts:**  Deliver at most one proximity notification per blink per 24 hours.  Respect the user’s Quiet Hours settings.  Tapping an alert opens Blink Details.
- **Error/Empty States:**  Provide illustrated states for No Blinks Nearby, Connection Error (with Retry) and Allow Location.

## 4. Acceptance Criteria

To consider Theme 1 “accepted,” the following must be true:

- **Token application:**  All colors, typography, spacing, radii, elevation and states throughout the app reference Theme 1 tokens.  No hard‑coded Theme 2 values remain.
- **Functional parity:**  Converting to Theme 1 does **not** change any functional behavior.  All flows (sharing, map, composing, reporting, drafts, notifications) continue to operate exactly as specified in the Use‑Case doc.
- **Screenshots:**  Provide before/after screenshots of each key screen (Home, Map, Compose, Settings, Profile) comparing Theme 2 and Theme 1.  Highlight any visual changes and fix regressions.
- **Guidelines:**  Document how to add/edit tokens and how to switch between themes.  Include a decision log entry noting that Theme 1 is the final design system for the MVP and Theme 2 is archived.
- **Accessibility:**  All interactive elements meet or exceed the 44 × 44 pt target size and have sufficient contrast (WCAG AA minimum).  Support Dynamic Type.
- **Deep links:**  External sharing opens the app using the `blinx://` URI scheme or the web fallback when the app is not installed.  Share gating follows the status rules.
- **Map behavior:**  The Use This Area button only appears after the user pans/zooms; the Re‑center button appears when the map is not centered on the user’s location.  Both actions perform as specified.
- **Offline & Drafts:**  Drafts auto‑save when offline; posting offline shows a banner prompting to publish when online.
- **Proximity Alerts:**  Alerts follow the 24‑hour limit per blink and respect Quiet Hours.

By meeting these criteria, we can deliver a consistent Theme 1 experience across Blinx, enabling the team to proceed with development and QA without further design reversions.
