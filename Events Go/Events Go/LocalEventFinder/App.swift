import SwiftUI
import MapKit

@main
struct LocalEventFinderApp: App {
    // MARK: - Services (Dependency Injection Root)
    @StateObject private var coreDataService = CoreDataService()
    private let networkService: NetworkService = MockNetworkService()

    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            RootView(
                mapVM: MapHomeViewModel(coreData: coreDataService, network: networkService),
                listVM: EventListViewModel(coreData: coreDataService, network: networkService),
                savedVM: SavedEventsViewModel(coreData: coreDataService)
            )
            .environment(\.managedObjectContext, coreDataService.context)
            .environmentObject(coreDataService)
            .tint(.black)
        }
    }
}

// MARK: - RootView with NavigationStack
struct RootView: View {
    @State private var path: [String] = []
    @ObservedObject var mapVM: MapHomeViewModel
    @ObservedObject var listVM: EventListViewModel
    @ObservedObject var savedVM: SavedEventsViewModel
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if selectedTab == 0 {
                    MapHomeView(viewModel: mapVM, onShowList: { selectedTab = 1 })
                } else if selectedTab == 1 {
                    EventListView(viewModel: listVM)
                } else {
                    SavedEventsView(viewModel: savedVM)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        selectedTab = 0
                    } label: {
                        Label("Map", systemImage: selectedTab == 0 ? "map.fill" : "map")
                            .foregroundStyle(Color.black.opacity(0.9))
                    }
                    Spacer()
                    Button {
                        selectedTab = 1
                    } label: {
                        Label("List", systemImage: selectedTab == 1 ? "list.bullet.rectangle" : "list.bullet")
                            .foregroundStyle(Color.black.opacity(0.9))
                    }
                    Spacer()
                    Button {
                        selectedTab = 2
                    } label: {
                        Label("Saved", systemImage: selectedTab == 2 ? "star.fill" : "star")
                            .foregroundStyle(Color.black.opacity(0.9))
                    }
                }
            }
            .toolbarBackground(.ultraThinMaterial, for: .bottomBar)
            .toolbarBackgroundVisibility(.visible, for: .bottomBar)
        }
    }
}
