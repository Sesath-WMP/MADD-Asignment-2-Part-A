This project was generated to meet the SE4041 Assignment 02 Part A requirements (source: /mnt/data/Assignment 02 - 2025-2.pdf).

# LocalEventFinder

- **Platforms**: iPhone & iPad (iOS 17)
- **Tech**: Swift 5, SwiftUI, MVVM, Core Data, MapKit
- **Persistence**: Programmatic Core Data model with lightweight migration
- **Accessibility**: Dynamic Type, labels, hints, dark mode support

## Features
- **MapHomeView**: Full-screen MapKit with custom color-coded annotations, animated mini-preview, FAB refresh, and navigation to details.
- **EventListView**: Live search, segmented date filters (All/Today/This Week), sort menu, pull-to-refresh (mock network), animated cards.
- **EventDetailView**: Large image header, title, date/time, embedded map snapshot, share, and Save/Unsave via Core Data.
- **SavedEventsView**: Saved list with swipe-to-delete, context menu.

## Architecture
- **MVVM** with dedicated `ViewModels` for each screen.
- **Services**: `NetworkService` + `MockNetworkService` for local JSON and placeholder remote fetching, `CoreDataService` for persistence.
- **Dependency Injection**: Services are constructed in `App.swift` and passed into view models.

## Folder Structure
- LocalEventFinder/
  - App.swift
  - Info.plist
  - Assets.xcassets/
  - Components/
  - Modifiers/
  - Models/
  - Services/
  - ViewModels/
  - Scenes/
  - Resources/
  - Tests/
- scripts/
- Report.md
- AI-Assistance-Log.md
- .gitignore

## Setup
1. Open the folder in Xcode 15 (iOS 17).
2. Ensure `Placeholder` image exists (a blank PNG is fine) in `Assets.xcassets/Placeholder.imageset/placeholder.png`. If missing, Xcode will still compile; the UI will show empty image.
3. Run on any iPhone/iPad simulator.

## MapKit Simulation
- The app displays seeded events as pins without requiring user location.
- You can enable the “Simulate Location” feature in Xcode if needed.

## How to Run Tests
- Product > Test (⌘U).
- Unit tests use an in-memory Core Data store for deterministic results.
- UI tests validate basic navigation and interactions.

## Core Data Notes
- Programmatic model created in `CoreDataService.makeModel()`.
- Entity: `EventEntity` with attributes [id, title_, details_, startDate, endDate, latitude, longitude, category, imageName, isSaved, createdAt].
- Mapping to `EventDTO` via `EventEntity.toDTO()` and `apply(from:)`.
- To reset data, run `scripts/reset_coredata.sh`.

## Seeding
- `Resources/SeedEvents.json` contains 10 events (Music, Sports, Arts, Tech).
- On first launch, if Core Data is empty, data is loaded from seed.

## Accessibility & Design
- Dynamic Type friendly fonts.
- Accessibility labels and hints on interactive elements.
- Dark mode via system colors.
- Color palette (example):
  - Primary: #0A5C50
  - Accent: #D7FF5E
  - Background: systemBackground variants

## Badges / Metrics (placeholders)
- Build: passing
- Code Coverage: 85%
- Lint: clean

## Performance Tips
- Use Instruments (Time Profiler, Allocations).
- Avoid heavy work on main thread; `@MainActor` used for UI-bound VM updates.
- Images are local and loaded lazily by SwiftUI.

## Reset/Seed Data
- `scripts/reset_coredata.sh` removes the app container from Simulator or resets store on device builds (commented steps).

## Demo Script (3 minutes)
1. Launch app to MapHome (see pins).
2. Tap a pin to open mini-preview; open details.
3. Save/Unsave event and share.
4. Return, hit FAB to refresh.
5. Switch to List: search “Tech”, change filter to Today/This Week, show sorting.
6. Open detail from list.
7. Open Saved tab: show saved items and swipe-to-delete.

## Git Branch Layout (recommended)
- `main` (stable)
- `feature/map`
- `feature/coredata`
- `feature/ui`
- `feature/tests`

## Commit Message Examples
- feat(coredata): add programmatic model and persistence
- feat(map): add annotations and mini preview
- feat(ui): implement EventListView with filters and sort
- test(core): add in-memory CRUD tests
- chore(ci): add scripts and docs

## Info.plist Keys
- `NSLocationWhenInUseUsageDescription` – if enabling user location.
- `NSCalendarsUsageDescription` – for EventKit add-to-calendar (placeholder in code).

## AI Assistance Log
See AI-Assistance-Log.md.
