#if canImport(XCTest)
import XCTest
#if canImport(LocalEventFinder)
@testable import LocalEventFinder
#elseif canImport(Events_Go)
@testable import Events_Go
#endif

final class EventListViewModelTests: XCTestCase {

    func testFilteringAndSorting() async throws {
        let core = CoreDataService(inMemory: true)
        let mock = DummyNet()
        try core.upsert(events: mock.events)
        let vm = EventListViewModel(coreData: core, network: mock)
        // Wait a moment to load
        try? await Task.sleep(nanoseconds: 50_000_000)

        vm.query = "swiftui"
        XCTAssertTrue(vm.visibleEvents.allSatisfy { $0.title.lowercased().contains("swiftui") || $0.details.lowercased().contains("swiftui") })

        vm.query = ""
        vm.sort = .title
        let titles = vm.visibleEvents.map { $0.title }
        XCTAssertEqual(titles, titles.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending })
    }

    private struct DummyNet: NetworkService {
        var events: [EventDTO] {
            let now = Date()
            return [
                EventDTO(id: UUID(), title: "SwiftUI Talk", details: "swiftui deep dive", startDate: now, endDate: nil, latitude: 0, longitude: 0, category: "Tech", imageName: "Placeholder", isSaved: false, createdAt: now),
                EventDTO(id: UUID(), title: "Music Night", details: "jazz", startDate: now, endDate: nil, latitude: 0, longitude: 0, category: "Music", imageName: "Placeholder", isSaved: false, createdAt: now)
            ]
        }
        func fetchEvents() async throws -> [EventDTO] { events }
        func fetchRemoteEvents(from url: URL) async throws -> [EventDTO] { events }
    }
}
#endif
