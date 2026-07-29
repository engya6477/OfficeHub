# OfficeHub

OfficeHub is a Flutter mobile application designed for employees working in companies inside a shared office building. It allows employees to manage meeting room bookings and expected visitors without needing to visit reception.

## Overview

OfficeHub helps employees in a shared office building handle two everyday tasks digitally instead of going through reception:

- **Meeting Room Booking** — browsing, reserving, and managing meeting rooms.
- **Visitor Management** — registering and managing expected visitors.

This implementation was built for the **OfficeHub Mobile Application Design & Frontend Challenge**. Per the assessment's technical constraints, no backend, API, or integration environment is provided, so the application runs entirely on **mock/local data** held in memory, structured so a real API could be swapped in later without touching the UI layer (see [Mock / Local Data](#mock--local-data)).

## Features

### Meeting Room Booking

- Browse available meeting rooms, by name (search, with recent/most-searched suggestions and filters) or by criteria (date, time, duration, attendees, facilities).
- View room details, capacity, and facilities.
- Select a booking date, time, and duration, and specify the number of attendees.
- Reserve an available room, with a review step before confirming.
- View booking details, including status.
- View upcoming bookings and booking history (including cancelled/past bookings).
- Cancel an eligible booking.
- Edit an eligible booking — implemented as cancel-and-rebook (see [Assumptions](#assumptions)).

### Visitor Management

- Register a visitor: name, phone number, visit date, arrival time, purpose, and meeting location.
- Review visit details before submitting.
- View visitor/visit details, including status.
- View upcoming visits and visit history (including cancelled/past visits).
- Edit an eligible visit (reuses the registration form, pre-filled).
- Cancel an eligible visit.

Supporting screens implemented beyond the two core features (per the assessment's allowance for candidate discretion on supporting flows): splash, onboarding, mock sign in / sign up / forgot password, a home dashboard with quick actions and "Today" activity, and a profile screen with sign out.

## Business Rules

All business rules below are enforced in the data layer (`lib/data/repositories/booking_validation.dart`, `visit_validation.dart`, and the mock repositories), not just in the UI, and are covered by unit tests in `test/`.

### Meeting Room Booking

- Business days are Sunday through Thursday — enforced when creating a booking and when picking a date (Friday/Saturday are disabled in the date picker).
- Business hours are 8:00 AM – 6:00 PM — enforced on the requested start time + duration; the time picker only offers slots in this window.
- Bookings cannot be created in the past.
- A room cannot be double-booked — new bookings are checked for time overlap against existing active bookings for that room.
- The selected room must support the requested number of attendees.
- Employees may only manage their own bookings (ownership is checked by employee ID on cancel).
- Booking availability is revalidated at creation time, immediately before confirming — not just when the results list was first shown.
- Cancelled bookings remain visible in booking history.

### Visitor Management

- Visits cannot be scheduled in the past.
- Visits can only be scheduled Sunday through Thursday, matching the office's business days (an addition beyond the PDF's explicit visitor rules — see [Assumptions](#assumptions)).
- Required visitor information (name, phone, date, arrival time, purpose, location) must be completed before submission.
- Employees may only manage visitors they created (ownership is checked by employee ID).
- Visits may only be edited or cancelled before the visitor's arrival time.
- Cancelled visits remain visible in history.

## Design

The application's UI/UX was designed separately in Figma and implemented in Flutter.

**Figma Design:** https://www.figma.com/design/MTvU0NFN0EL66TMKubMA5g/office?node-id=0-1

**Interactive Prototype:** https://www.figma.com/proto/MTvU0NFN0EL66TMKubMA5g/office?node-id=11-10892

## Tech Stack

- **Flutter / Dart** — cross-platform mobile framework.
- **provider** (`^6.1.5`) — app-wide state management via `ChangeNotifier` controllers.
- **iconsax_flutter** (`^1.0.1`) — the icon set used throughout the Figma file (`search-normal`, `arrow-left`, `calendar`, etc.).
- **intl** (`^0.20.3`) — date/time formatting.
- **uuid** (`^4.6.0`) — generating IDs for mock bookings/visits.
- **Outfit** and **Inter** — the two typefaces used in the Figma file, bundled as local variable-font assets (`assets/fonts/`) rather than fetched at runtime, so the app renders correctly offline.
- Navigation uses plain `Navigator`/`MaterialPageRoute` rather than a routing package: the app's flows are linear wizards (booking, visitor registration) without a deep-linking requirement, so a router added complexity without benefit.

## Architecture

The codebase follows a **feature-first** structure with a clear separation between presentation, business logic, and data:

- **`lib/core/`** — design system (colors, typography, spacing/radius tokens, `ThemeData`) and shared widgets (`AppButton`, `AppTextField`, bottom sheets, chips, etc.) used across features.
- **`lib/data/`** — the data layer:
  - `models/` — plain Dart data classes (`Booking`, `Visit`, `MeetingRoom`, `Employee`, enums).
  - `repositories/` — an abstract interface per resource (`RoomRepository`, `BookingRepository`, `VisitRepository`, `SessionRepository`) plus a `Mock*Repository` implementation holding in-memory data and enforcing the business rules above.
  - `mock/` — static seed data (the current employee, meeting rooms, visit locations).
- **`lib/features/<feature>/`** — one folder per feature (`auth`, `home`, `rooms`, `visitors`, `profile`), each split into:
  - `application/` — `ChangeNotifier` controllers (`AuthController`, `BookingsController`, `VisitsController`) that call into repositories and expose state to the UI.
  - `presentation/` — screens and feature-specific widgets.
- **`lib/app/`** — app wiring: `MultiProvider` setup (`app.dart`), the splash → onboarding → sign-in → main-shell state machine (`app_root.dart`), and the bottom-nav shell (`main_shell.dart`).

**Why this supports future API integration:** every screen and controller depends only on the abstract repository interfaces (`RoomRepository`, `BookingRepository`, `VisitRepository`, `SessionRepository`), never on the mock classes directly. The mock implementations are wired up in one place (`lib/app/app.dart`). Replacing mock/local data with a real backend means writing `ApiRoomRepository`, `ApiBookingRepository`, etc. against the same interfaces and swapping the `Provider<...>(create: ...)` lines in `app.dart` — no changes to any screen or controller.

## Project Structure

```
officehub/
├── lib/
│   ├── main.dart
│   ├── app/                     # App wiring: providers, root state machine, bottom-nav shell
│   ├── core/
│   │   ├── theme/                # Colors, typography, spacing, ThemeData
│   │   ├── widgets/               # Shared components (buttons, inputs, sheets, chips, ...)
│   │   └── utils/                 # Business hours, date/time formatting
│   ├── data/
│   │   ├── models/                # Booking, Visit, MeetingRoom, Employee, enums
│   │   ├── mock/                  # Seed data
│   │   └── repositories/          # Interfaces + Mock*Repository implementations + validation
│   └── features/
│       ├── auth/                  # Splash, onboarding, sign in/up, forgot password
│       ├── home/                  # Home dashboard
│       ├── rooms/                 # Room search, booking flow, my bookings
│       ├── visitors/               # Visitor registration flow, my visits
│       └── profile/                # Profile / sign out
├── test/                          # Unit tests (business rules, repositories) + a widget smoke test
├── assets/fonts/                  # Bundled Outfit & Inter variable fonts
├── pubspec.yaml
└── README.md
```

Standard generated platform folders (`android/`, `ios/`, `web/`, etc.) are omitted above for brevity.

## Mock / Local Data

Per the assessment's technical constraints:

- No backend implementation is required, and none is provided.
- The application therefore uses mock/local data to demonstrate the complete experience.

Concretely: `MockRoomRepository`, `MockBookingRepository`, `MockVisitRepository`, and `MockSessionRepository` (in `lib/data/repositories/`) hold in-memory data, seeded on first use from `lib/data/mock/mock_seed.dart` (one employee, five meeting rooms, a couple of sample bookings/visits so the "Today" and history views aren't empty on first launch). All state is per-app-session; nothing is persisted to disk, so data resets on a full app restart. Every repository implements an abstract interface with no mock-specific details leaking into the interface, which is what allows a future real API implementation to be substituted without changing any screen (see [Architecture](#architecture)).

## Assumptions

Genuine assumptions made where the assessment did not specify behavior:

- **Single mock identity.** Since there's no backend/auth, the app always operates as one fixed employee ("Ahmed Alharbi", Nova Company). Sign in / sign up / forgot password screens exist (matching the Figma flows) and simulate a network round trip, but accept any non-empty input — there's no real credential store to validate against.
- **"Edit booking" for rooms is cancel-and-rebook.** The PDF's Meeting Room Booking requirements only list *cancelling* an eligible booking (unlike Visitor Management, which explicitly requires *editing*). The Figma booking-details frame still shows an "Edit booking" button, so it's implemented, but as cancelling the existing booking and opening a fresh booking flow, rather than an in-place multi-field edit that isn't described as a requirement.
- **Visitor date picker follows the same Sunday–Thursday rule as bookings.** The PDF's business-day rule is listed only under Meeting Room Booking, but Figma's "Select date" sheet is shared by both flows and the office is only staffed Sunday–Thursday, so the same restriction is enforced for visitor registration too (disabled days in the picker, and validated in `VisitValidation.assertBusinessDay`).
- **Room photos.** Figma's room-details frame contains exactly one real exported photo, for Atlas Room (`assets/images/room_atlas.jpg`), used in a swipeable photo header with page-count/dot indicators. No other room has a photo in the Figma file, so the remaining rooms show a themed icon tile instead (each room gets a distinct icon so tiles aren't identical) rather than an invented or reused stock photo. The onboarding illustrations, by contrast, are the actual artwork exported from Figma (`assets/images/`).
- **Optional meeting title.** Figma's Home "Today" card shows a meeting subject (e.g. "Product Sync") distinct from the room name — a field the PDF's booking requirements don't mention. `Booking.title` was added as an optional field, with a matching optional "Meeting title" input on the booking form, to match Figma without making it a required field the PDF never asked for.
- **Fixed option lists.** Facilities (Display, Whiteboard, Video Conferencing), visit purposes, and meeting locations are limited to the exact sets shown in Figma's bottom sheets, since the assessment didn't specify a broader catalogue.
- **Voice search is a UI mock.** The Figma file includes a voice-search flow; since no backend/speech service is available or required, it's simulated (a "Listening…" sheet that auto-fills a sample query) rather than wired to real speech recognition.

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio and/or Xcode, depending on target platform
- An emulator/simulator, a physical device, or a web browser (the app also runs as a Flutter web app)

## Installation

```bash
git clone <repository-url>
cd officehub
flutter pub get
```

## Running the Application

```bash
flutter run
```

No environment variables or backend configuration are required, since the application uses mock/local data.

## Testing

`test/` covers the business rules and repository behavior described above with plain unit tests, plus one widget smoke test:

- `business_hours_test.dart` — Sunday–Thursday / 8:00 AM–6:00 PM checks.
- `booking_validation_test.dart` — past-date, business-hours, and capacity validation.
- `mock_booking_repository_test.dart` — capacity rejection, double-booking prevention, ownership on cancel, cancelled bookings remaining in history.
- `visit_validation_test.dart` — past-date and required-field validation.
- `mock_visit_repository_test.dart` — past-date rejection, ownership checks, editing an eligible visit, cancelled visits remaining in history.
- `app_smoke_test.dart` — the app boots and renders the splash and onboarding screens.

```bash
flutter test
```

`flutter analyze` runs clean with no issues.

## Code Quality

```bash
dart format .
flutter analyze
```

## Screenshots

_Screenshots of the running application can be added here._

## Future API Integration

Because every screen and controller depends on the abstract repository interfaces (`RoomRepository`, `BookingRepository`, `VisitRepository`, `SessionRepository`) rather than the mock implementations, introducing a real backend means:

1. Implementing `Api*Repository` classes against the same interfaces (e.g. `ApiBookingRepository implements BookingRepository`), making HTTP calls instead of reading/writing in-memory lists.
2. Swapping the `Provider<...>(create: ...)` registrations in `lib/app/app.dart` to construct the API-backed repositories instead of the mock ones.

No screen, controller, or widget needs to change, since none of them reference the mock classes directly.

## Assessment

This project was developed as part of the **OfficeHub Mobile Application Design & Frontend Challenge**.
