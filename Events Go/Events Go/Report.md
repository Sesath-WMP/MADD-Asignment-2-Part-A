# Report: LocalEventFinder

## Purpose & Target Audience
- Help users discover local events near them via a map and list.
- Audience: students and community members attending events (music, sports, arts, tech).

## UX Decisions & Mockups
- NavigationStack root with bottom toolbar tabs to Map, List, and Saved.
- Map-first approach to encourage spatial discovery.
- Card-based lists with clear hierarchy and accessible labels.

## Architecture & Design Patterns
- MVVM separation:
  - Models: `EventDTO`, `EventEntity`.
  - ViewModels: per screen for state and logic.
  - Services: network and persistence via DI.
- Programmatic Core Data model for lightweight migrations.

## Emerging Technology Integration (MapKit)
- Map annotations by category with custom color pins and bounce animation.
- Embedded map snapshot in details (non-interactive view).

## Testing & Optimization
- Unit tests:
  - CoreData in-memory CRUD and toggle.
  - ViewModel filtering and sorting logic.
- UI tests:
  - Launch, search, open detail, navigate to saved.
- Performance:
  - Main actor for UI updates.
  - Lazy views and minimal synchronous work on main thread.

## Challenges & Reflections
- Balancing feature completeness with determinism for tests.
- Ensuring accessibility and adaptive layouts.

## Results
- App launches with seeded events on map and list.
- Users can save events and manage favorites.

## Viva Notes
- Explain MVVM and DI approach.
- Core Data model mapping and seeding.
- MapKit annotations and custom pin design.
- Accessibility features and testing strategy.
