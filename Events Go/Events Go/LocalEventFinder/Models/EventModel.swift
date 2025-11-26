import Foundation
import CoreData
import MapKit

// MARK: - DTO used by ViewModels/Views
struct EventDTO: Identifiable, Equatable {
    let id: UUID
    var title: String
    var details: String
    var startDate: Date
    var endDate: Date?
    var latitude: Double
    var longitude: Double
    var category: String
    var imageName: String
    var isSaved: Bool
    var createdAt: Date

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }

    var briefLocation: String {
        "\(String(format: "%.3f", latitude)), \(String(format: "%.3f", longitude))"
    }
}

// MARK: - Core Data NSManagedObject subclass mapping
@objc(EventEntity)
class EventEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title_: String
    @NSManaged var details_: String
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var category: String
    @NSManaged var imageName: String
    @NSManaged var isSaved: Bool
    @NSManaged var createdAt: Date
}

extension EventEntity {
    // Bridge to DTO
    func toDTO() -> EventDTO {
        EventDTO(
            id: id,
            title: title_,
            details: details_,
            startDate: startDate,
            endDate: endDate,
            latitude: latitude,
            longitude: longitude,
            category: category,
            imageName: imageName,
            isSaved: isSaved,
            createdAt: createdAt
        )
    }

    func apply(from dto: EventDTO) {
        id = dto.id
        title_ = dto.title
        details_ = dto.details
        startDate = dto.startDate
        endDate = dto.endDate
        latitude = dto.latitude
        longitude = dto.longitude
        category = dto.category
        imageName = dto.imageName
        isSaved = dto.isSaved
        createdAt = dto.createdAt
    }
}
