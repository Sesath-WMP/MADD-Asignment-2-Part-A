iOS Event Discovery App – SE4041 Assignment 2 (Part A)

LocalEventFinder is an iOS application built using SwiftUI, MapKit, and Core Data. It allows users to discover local events via a map-based interface, browse event lists, view detailed event information, and save favourites for later.

🚀 Features
Core Features

Interactive Map View with event pins

Scrollable Event List with filters (All / Today / This Week)

Event Details (image, time, date, description, location)

Save / Unsave favourites (Core Data persistence)

Search bar & category filters

Pull-to-refresh (simulated network)

Smooth SwiftUI navigation using NavigationStack

Advanced iOS Technologies

MapKit (emerging tech requirement)

Core Data for offline storage

Custom SwiftUI components

Lightweight mock networking using local JSON

🧱 Architecture

Pattern: MVVM

Views: MapHomeView, EventListView, EventDetailView, SavedEventsView

ViewModels: One per screen

Services:

CoreDataService

NetworkService (mock)

Models: Event, EventCategory

🎨 UI / UX

Clean, modern iOS 17 SwiftUI design

Map-based event discovery

Animated event cards

Light & Dark mode support

VoiceOver & accessibility labels

Dynamic Type text scaling

🧪 Testing
Unit Tests

Core Data CRUD operations

Event filtering logic

Favourite toggling

UI Tests

Navigation flow

Save/unsave behaviour

Map/List consistency

📦 Installation & Running

Clone the repository

Open the project in Xcode (iOS 17 recommended)

Run on iPhone/iPad simulator

Events are loaded from SeedEvents.json

📁 Project Structure
LocalEventFinder/
 ├── App.swift
 ├── Models/
 ├── ViewModels/
 ├── Views/
 ├── Services/
 ├── Resources/SeedEvents.json
 ├── Assets.xcassets
 ├── Tests/
 └── README.md

📝 AI Assistance

AI tools (ChatGPT & Windsurf) were used for code scaffolding, UI ideas, and documentation support. All logic and architecture were customized, validated, and refined manually.
