import Foundation
import SwiftUI
import Combine

enum EventListFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case thisWeek = "This Week"
}

enum EventListSort: String, CaseIterable {
    case dateAsc = "Date ↑"
    case dateDesc = "Date ↓"
    case title = "Title"
}

@MainActor
final class EventListViewModel: ObservableObject {
    private let coreData: CoreDataService
    private let network: NetworkService

    @Published var allEvents: [EventDTO] = []
    @Published var visibleEvents: [EventDTO] = []
    @Published var query: String = "" { didSet { applyFilters() } }
    @Published var filter: EventListFilter = .all { didSet { applyFilters() } }
    @Published var sort: EventListSort = .dateAsc { didSet { applyFilters() } }
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String?

    init(coreData: CoreDataService, network: NetworkService) {
        self.coreData = coreData
        self.network = network
        Task { await load() }
    }

    func load() async {
        do {
            allEvents = try coreData.fetchAll()
            applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh() async {
        isRefreshing = true
        do {
            let remote = try await network.fetchEvents()
            try coreData.upsert(events: remote)
            allEvents = try coreData.fetchAll()
            applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }
        isRefreshing = false
    }

    func toggleSaved(_ event: EventDTO) {
        do {
            _ = try coreData.toggleSaved(id: event.id)
            allEvents = try coreData.fetchAll()
            applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func applyFilters() {
        var items = allEvents

        // search
        if !query.isEmpty {
            let q = query.lowercased()
            items = items.filter { $0.title.lowercased().contains(q) || $0.details.lowercased().contains(q) || $0.category.lowercased().contains(q) }
        }

        // filter by date
        let cal = Calendar.current
        let now = Date()
        switch filter {
        case .all: break
        case .today:
            items = items.filter { cal.isDate($0.startDate, inSameDayAs: now) }
        case .thisWeek:
            if let week = cal.dateInterval(of: .weekOfYear, for: now) {
                items = items.filter { ($0.startDate >= week.start) && ($0.startDate < week.end) }
            }
        }

        // sort
        switch sort {
        case .dateAsc: items = items.sorted { $0.startDate < $1.startDate }
        case .dateDesc: items = items.sorted { $0.startDate > $1.startDate }
        case .title: items = items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }

        visibleEvents = items
    }
}
