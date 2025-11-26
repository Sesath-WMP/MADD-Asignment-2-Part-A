import Foundation
import SwiftUI
import MapKit
import Combine

@MainActor
final class EventDetailViewModel: ObservableObject {
    private let coreData: CoreDataService

    @Published var event: EventDTO

    init(event: EventDTO, coreData: CoreDataService) {
        self.event = event
        self.coreData = coreData
    }

    func toggleSaved() {
        do {
            if let updated = try coreData.toggleSaved(id: event.id) {
                event = updated
            }
        } catch { print("Toggle saved failed: \(error)") }
    }
}
