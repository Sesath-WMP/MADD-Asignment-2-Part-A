#if canImport(XCTest)
import XCTest
#if canImport(LocalEventFinder)
@testable import LocalEventFinder
#elseif canImport(Events_Go)
@testable import Events_Go
#endif
import CoreData

final class CoreDataServiceTests: XCTestCase {
    func testCRUDAndToggleSaved() async throws {
        let core = CoreDataService(inMemory: true)
        let now = Date()
        let dto = EventDTO(
            id: UUID(),
            title: "Test",
            details: "Details",
            startDate: now,
            endDate: nil,
            latitude: 1, longitude: 2,
            category: "Tech",
            imageName: "Placeholder",
            isSaved: false,
            createdAt: now
        )
        try core.upsert(events: [dto])

        var fetched = try core.fetchAll()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched[0].isSaved, false)

        _ = try core.toggleSaved(id: dto.id)
        fetched = try core.fetchAll()
        XCTAssertEqual(fetched[0].isSaved, true)

        let saved = try core.fetchSaved()
        XCTAssertEqual(saved.count, 1)
    }
}
#endif
