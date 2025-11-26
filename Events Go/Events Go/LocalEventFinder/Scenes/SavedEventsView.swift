import SwiftUI

struct SavedEventsView: View {
    @ObservedObject var viewModel: SavedEventsViewModel

    var body: some View {
        List {
            ForEach(viewModel.saved) { event in
                EventCard(event: event, isSaved: true, onTap: {}, onLongPress: {})
                    .contextMenu {
                        ShareLink(item: "\(event.title) at \(event.briefLocation)")
                    }
            }
            .onDelete(perform: delete)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Saved")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { await viewModel.reload() }
                } label: { Image(systemName: "arrow.clockwise") }
            }
        }
        .task { await viewModel.reload() }
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { idx in
            let e = viewModel.saved[idx]
            viewModel.delete(e)
        }
    }
}
