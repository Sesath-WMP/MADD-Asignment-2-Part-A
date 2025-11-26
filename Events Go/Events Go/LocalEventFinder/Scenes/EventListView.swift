import SwiftUI

struct EventListView: View {
    @ObservedObject var viewModel: EventListViewModel
    @EnvironmentObject private var coreData: CoreDataService
    @Namespace private var ns

    var body: some View {
        VStack {
            header
            controls
            listContent
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await viewModel.refresh() }
        .padding(.horizontal)
    }

    private var header: some View {
        HStack {
            TextField("Search events", text: $viewModel.query)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Search events")
        }
        .padding(.top)
    }

    private var controls: some View {
        HStack {
            Picker("Filter", selection: $viewModel.filter) {
                ForEach(EventListFilter.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)

            Menu {
                ForEach(EventListSort.allCases, id: \.self) { sort in
                    Button(sort.rawValue) { viewModel.sort = sort }
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down.circle")
            }
            .accessibilityLabel("Sort options")
        }
    }

    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.visibleEvents) { event in
                    EventCard(
                        event: event,
                        isSaved: event.isSaved,
                        onTap: {},
                        onLongPress: { /* Quick actions if needed */ }
                    )
                    .contextMenu {
                        Button {
                            viewModel.toggleSaved(event)
                        } label: {
                            Label(event.isSaved ? "Unsave" : "Save", systemImage: "star")
                        }
                        ShareLink(item: "\(event.title) at \(event.briefLocation)")
                    }

                    NavigationLink {
                        EventDetailView(viewModel: EventDetailViewModel(event: event, coreData: coreData))
                    } label: {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .hidden()
                }
            }
            .padding(.vertical)
        }
    }
}
