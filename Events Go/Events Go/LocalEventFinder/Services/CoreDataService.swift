import Foundation
import CoreData
import Combine

// MARK: - CoreDataService
@MainActor
final class CoreDataService: ObservableObject {
    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext { persistentContainer.viewContext }

    // MARK: - Init
    init(inMemory: Bool = false) {
        let model = Self.makeModel()
        persistentContainer = NSPersistentContainer(name: "LocalEventFinderModel", managedObjectModel: model)
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }
        persistentContainer.loadPersistentStores { _, error in
            if let error { fatalError("Unresolved Core Data error: \(error)") }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Model (Lightweight migration-ready)
    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        // Entity: EventEntity
        let entity = NSEntityDescription()
        entity.name = "EventEntity"
        entity.managedObjectClassName = NSStringFromClass(EventEntity.self)

        func attribute(_ name: String, _ type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = optional
            return a
        }

        entity.properties = [
            attribute("id", .UUIDAttributeType),
            attribute("title_", .stringAttributeType),
            attribute("details_", .stringAttributeType),
            attribute("startDate", .dateAttributeType),
            attribute("endDate", .dateAttributeType, optional: true),
            attribute("latitude", .doubleAttributeType),
            attribute("longitude", .doubleAttributeType),
            attribute("category", .stringAttributeType),
            attribute("imageName", .stringAttributeType),
            attribute("isSaved", .booleanAttributeType),
            attribute("createdAt", .dateAttributeType)
        ]

        let idIndex = NSFetchIndexDescription(name: "idx_id", elements: [NSFetchIndexElementDescription(property: entity.propertiesByName["id"]!, collationType: .binary)])
        entity.indexes = [idIndex]

        model.entities = [entity]
        return model
    }

    // MARK: - CRUD
    func upsert(events: [EventDTO]) throws {
        for dto in events {
            let req = NSFetchRequest<EventEntity>(entityName: "EventEntity")
            req.predicate = NSPredicate(format: "id == %@", dto.id as CVarArg)
            req.fetchLimit = 1
            let existing = try context.fetch(req).first
            let obj = existing ?? EventEntity(entity: context.persistentStoreCoordinator!.managedObjectModel.entitiesByName["EventEntity"]!, insertInto: context)
            obj.apply(from: dto)
        }
        try save()
    }

    func fetchAll() throws -> [EventDTO] {
        let req = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        req.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        return try context.fetch(req).map { $0.toDTO() }
    }

    func fetchSaved() throws -> [EventDTO] {
        let req = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        req.predicate = NSPredicate(format: "isSaved == YES")
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return try context.fetch(req).map { $0.toDTO() }
    }

    func toggleSaved(id: UUID) throws -> EventDTO? {
        let req = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.fetchLimit = 1
        guard let obj = try context.fetch(req).first else { return nil }
        obj.isSaved.toggle()
        try save()
        return obj.toDTO()
    }

    func deleteSaved(id: UUID) throws {
        let req = NSFetchRequest<EventEntity>(entityName: "EventEntity")
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.fetchLimit = 1
        if let obj = try context.fetch(req).first {
            context.delete(obj)
            try save()
        }
    }

    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    // MARK: - Seeding
    func seedIfNeeded(using network: NetworkService) async {
        do {
            let current = try fetchAll()
            if current.isEmpty {
                let events = try await network.fetchEvents()
                try upsert(events: events)
            }
        } catch {
            print("Seed failed: \(error)")
        }
    }

    // MARK: - Utilities for tests
    func removeAll() throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        let batch = NSBatchDeleteRequest(fetchRequest: fetch)
        try persistentContainer.persistentStoreCoordinator.execute(batch, with: context)
        context.reset()
    }
}
