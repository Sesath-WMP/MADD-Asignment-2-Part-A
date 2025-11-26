import Foundation
import SwiftUI
import Combine

@MainActor
final class SavedEventsViewModel: ObservableObject {
    private let coreData: CoreDataService

    @Published var saved: [EventDTO] = []
    @Published var errorMessage: String?

    init(coreData: CoreDataService) {
        self.coreData = coreData
        Task { await reload() }
    }

    func reload() async {
        do {
            saved = try coreData.fetchSaved()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(_ event: EventDTO) {
        do {
            try coreData.deleteSaved(id: event.id)
            saved = try coreData.fetchSaved()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
