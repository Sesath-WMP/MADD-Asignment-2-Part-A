LocalEventFinder
iOS Event Discovery App – SE4041 Assignment 2 (Part A)

LocalEventFinder is an iOS application developed using SwiftUI, MapKit, and Core Data, designed to help users discover nearby events through an interactive map and list interface. Users can explore events, view details, and save favourites for later.

🚀 Features
Core Functionality

Interactive Map View with event pins

Detailed Event View (images, date, time, location, description)

Scrollable List View with filtering (All / Today / This Week)

Saving/unsaving favourites (persisted using Core Data)

Search bar + category chips

Pull-to-refresh (simulated network fetch)

Smooth navigation using NavigationStack

Advanced iOS / Emerging Tech Used

MapKit for mapping & geospatial features

Custom annotations & map snapshots

Core Data for offline persistence

Custom animations & SwiftUI components

🧱 Architecture

Pattern: MVVM

Views: MapHomeView, EventListView, EventDetailView, SavedEventsView

ViewModels: One per major screen

Models: Event, EventCategory

Services:

CoreDataService – persistence

NetworkService – mock API + local JSON loading

🎨 UI / UX

Clean, modern SwiftUI layout

Dynamic Type support

Light/Dark mode

Smooth animations (matchedGeometryEffect on cards)

VoiceOver-friendly labels

🧪 Testing
Unit Tests

Core Data CRUD operations

Event filtering logic

Favourite toggling

UI Tests

Navigation flow

Save/unsave actions

List & map consistency

📁 Folder Structure
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

📦 Installation & Running

Clone the repository

Open LocalEventFinder.xcodeproj

Run on iOS Simulator (iOS 17 recommended)

Works on:

iPhone

iPad

📝 AI Assistance

Some boilerplate sections (UI scaffolding, SwiftUI templates, and documentation outlines) were generated with AI assistance (ChatGPT, Windsurf AI). All logic and structure were independently validated and modified.
