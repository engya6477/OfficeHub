# OfficeHub

OfficeHub is a Flutter mobile application designed for employees working in companies inside a shared office building. It allows employees to manage meeting room bookings and expected visitors without needing to visit reception.

> **Status:** This repository currently contains the project documentation only. The Flutter application (source code, `pubspec.yaml`, `lib/`, tests, etc.) has not yet been scaffolded/committed. Sections below that depend on the implementation (Tech Stack, Architecture, Project Structure, Testing) are marked as **planned** and will be updated to reflect the actual code once it exists in this repository.

## Overview

OfficeHub helps employees in a shared office building handle two everyday tasks digitally instead of going through reception:

- **Meeting Room Booking** — reserving and managing meeting rooms.
- **Visitor Management** — registering and managing expected visitors.

This implementation is being created for the **OfficeHub Mobile Application Design & Frontend Challenge**. Per the assessment's technical constraints, no backend, API, or integration environment is provided, so the application uses **mock/local data** to demonstrate the complete experience end to end.

## Features

> The lists below reflect the business requirements from the assessment. This section will be updated to state which of these are implemented, partially implemented, or pending once the Flutter application exists in this repository.

### Meeting Room Booking

- Browse available meeting rooms
- View room details
- View room capacity and facilities
- Select booking date
- Select booking time
- Select booking duration
- Specify number of attendees
- Reserve an available room
- View booking details
- View upcoming bookings
- View previous bookings
- Cancel eligible bookings

### Visitor Management

- Register a visitor
- Provide visitor information
- Select visit date
- Select arrival time
- Specify visit purpose
- Specify meeting location
- View visitor details
- View upcoming visits
- View previous visits
- Edit eligible visits
- Cancel eligible visits

## Business Rules

The following business rules are defined by the assessment and are intended to be enforced by the application. This section will be updated with implementation notes (e.g., which layer enforces each rule) once the codebase exists.

### Meeting Room Booking

- Business days are Sunday through Thursday.
- Business hours are 8:00 AM – 6:00 PM.
- Bookings cannot be created in the past.
- Rooms cannot be double-booked.
- Room capacity must support the requested attendee count.
- Employees can only manage their own bookings.
- Room availability is revalidated before confirmation.
- Cancelled bookings remain visible in booking history.

### Visitor Management

- Visits cannot be scheduled in the past.
- Required visitor information must be completed before submission.
- Employees can only manage visitors they created.
- Visits can only be edited or cancelled before arrival.
- Cancelled visits remain visible in history.

## Design

The application's UI/UX is being designed separately in Figma and implemented in Flutter.

**Figma Design:** https://www.figma.com/design/MTvU0NFN0EL66TMKubMA5g/office?node-id=0-1&t=I1HH9HhTfji4iltA-1

**Interactive Prototype:** https://www.figma.com/proto/MTvU0NFN0EL66TMKubMA5g/office?node-id=11-10892&t=ZjlkjcACZKGuQIsG-1&scaling=min-zoom&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=11%3A6844

## Tech Stack _(planned)_

To be finalized once the Flutter project is scaffolded and dependencies are added to `pubspec.yaml`. Expected at minimum:

- Flutter
- Dart

Additional choices for state management, routing, and mock data handling will be documented here once decided and reflected in `pubspec.yaml`.

## Architecture _(planned)_

To be documented once source code exists, covering:

- Presentation/UI organization
- Business logic
- Data layer and mock/local data implementation
- Repositories/services (if applicable)
- State management approach
- Routing approach
- How the structure allows mock/local data to be swapped for a real API later

## Project Structure

Current repository contents:

```
officehub/
├── Frontend Design & Development Assessment.pdf   # Assessment brief
└── README.md
```

Once the Flutter project is added, this section will be updated with the actual `lib/`, `test/`, and `assets/` structure.

## Mock / Local Data

Per the assessment's technical constraints:

- No backend implementation is required.
- No API, API documentation, or integration environment is provided.
- The application must therefore use mock/local data to demonstrate the complete experience.
- The application should be structured so that mock/local data can later be replaced by a real API without significant changes.

Details of how mock/local data is implemented (e.g., static data sources, repository interfaces) will be documented here once the codebase exists.

## Assumptions

To be completed once implementation decisions are made. Only genuine assumptions — details the assessment did not specify — will be listed here (e.g., handling of authentication, company scoping, or facility lists), not explicit requirements from the PDF.

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio and/or Xcode, depending on target platform
- An emulator/simulator or a physical device

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

No tests currently exist in this repository. Once implemented, this section will document test coverage and the command to run them:

```bash
flutter test
```

## Code Quality

```bash
dart format .
flutter analyze
```

## Screenshots

_Screenshots of the implemented application will be added here once available._

## Future API Integration

The application is intended to be structured so that mock/local data sources can be replaced by real API calls without requiring significant changes elsewhere in the app. Concrete details will be documented here once the data layer is implemented.

## Assessment

This project is being developed as part of the **OfficeHub Mobile Application Design & Frontend Challenge**.
