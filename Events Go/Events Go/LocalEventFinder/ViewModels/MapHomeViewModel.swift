import Foundation
import SwiftUI
import MapKit
import Combine

@MainActor
final class MapHomeViewModel: ObservableObject {
    // MARK: - Inputs
    private let coreData: CoreDataService
    private let network: NetworkService

    // MARK: - Outputs
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), span: .init(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var events: [EventDTO] = []
    @Published var selectedEvent: EventDTO?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(coreData: CoreDataService, network: NetworkService) {
        self.coreData = coreData
        self.network = network
        Task { await initialLoad() }
    }

    func initialLoad() async {
        isLoading = true
        await coreData.seedIfNeeded(using: network)
        do {
            events = try coreData.fetchAll()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func refresh() async {
        isLoading = true
        do {
            let remote = try await network.fetchEvents()
            try coreData.upsert(events: remote)
            events = try coreData.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func toggleSaved(for event: EventDTO) {
        do {
            _ = try coreData.toggleSaved(id: event.id)
            events = try coreData.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
