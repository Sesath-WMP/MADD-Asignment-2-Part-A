import Foundation

// MARK: - NetworkService protocol
protocol NetworkService {
    func fetchEvents() async throws -> [EventDTO]
    func fetchRemoteEvents(from url: URL) async throws -> [EventDTO]
}

// MARK: - MockNetworkService (loads local JSON)
struct MockNetworkService: NetworkService {
    private let fileName = "SeedEvents"
    private let fileExt = "json"

    func fetchEvents() async throws -> [EventDTO] {
        try await loadSeed()
    }

    func fetchRemoteEvents(from url: URL) async throws -> [EventDTO] {
        // Placeholder real request
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decode(data: data)
    }

    private func loadSeed() async throws -> [EventDTO] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExt) else {
            throw NSError(domain: "SeedMissing", code: -1, userInfo: [NSLocalizedDescriptionKey: "SeedEvents.json not found in bundle"])
        }
        let data = try Data(contentsOf: url)
        return try decode(data: data)
    }

    private func decode(data: Data) throws -> [EventDTO] {
        struct Seed: Decodable {
            let id: String
            let title: String
            let details: String
            let startDate: String
            let endDate: String?
            let latitude: Double
            let longitude: Double
            let category: String
            let imageName: String
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let seeds = try decoder.decode([Seed].self, from: data)
        let now = Date()
        return seeds.map { s in
            EventDTO(
                id: UUID(uuidString: s.id) ?? UUID(),
                title: s.title,
                details: s.details,
                startDate: ISO8601DateFormatter().date(from: s.startDate) ?? now,
                endDate: s.endDate.flatMap { ISO8601DateFormatter().date(from: $0) },
                latitude: s.latitude,
                longitude: s.longitude,
                category: s.category,
                imageName: s.imageName,
                isSaved: false,
                createdAt: now
            )
        }
    }
}
