import SwiftUI
import MapKit

// MARK: - MapHomeView
struct MapHomeView: View {
    @ObservedObject var viewModel: MapHomeViewModel
    var onShowList: () -> Void
    @EnvironmentObject private var coreData: CoreDataService
    @Namespace private var ns
    @State private var showFAB = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(initialPosition: .region(viewModel.region)) {
                ForEach(viewModel.events) { e in
                    Annotation(e.title, coordinate: e.coordinate) {
                        MapAnnotationPin(category: e.category)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.selectedEvent = e
                                }
                            }
                            .accessibilityLabel("\(e.title) pin")
                            .accessibilityHint("Double tap to preview")
                    }
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Text("LocalEventFinder")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        onShowList()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "list.bullet")
                            Text("List")
                        }
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Color.black.opacity(0.35),
                            in: Capsule()
                        )
                        .foregroundStyle(.white)
                    }
                    .accessibilityLabel("Show list")
                }
                .padding(.horizontal, 16)
                .padding(.top, 2)
                .padding(.bottom, 6)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.65), Color.black.opacity(0.25)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 8)
                )

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)

            if let selected = viewModel.selectedEvent {
                miniPreview(for: selected)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            FloatingActionButton(systemImage: "location.circle.fill") {
                Task { await viewModel.refresh() }
            }
            .padding()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { showFAB = true }
        }
    }

    // MARK: - Mini Preview
    @ViewBuilder
    private func miniPreview(for event: EventDTO) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(event.title).font(.headline)
                Spacer()
                Button {
                    viewModel.toggleSaved(for: event)
                } label: {
                    Image(systemName: event.isSaved ? "star.fill" : "star")
                        .foregroundStyle(event.isSaved ? .yellow : .primary)
                }
                Button {
                    withAnimation { viewModel.selectedEvent = nil }
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                }
            }

            Text(event.briefLocation).font(.subheadline).foregroundStyle(.secondary)

            NavigationLink {
                EventDetailView(
                    viewModel: EventDetailViewModel(event: event, coreData: coreData)
                )
            } label: {
                Text("Open details")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                    .foregroundStyle(.white)
            }
            .accessibilityLabel("Open details")
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding()
        .accessibilityElement(children: .combine)
    }
}

// MARK: - MapAnnotationPin (custom, animated)
private struct MapAnnotationPin: View {
    let category: String
    @State private var bounce = false

    private var color: Color {
        switch category.lowercased() {
        case "music": return .pink
        case "sports": return .blue
        case "arts": return .purple
        case "tech": return .green
        default: return .red
        }
    }

    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .font(.title)
            .foregroundStyle(color)
            .scaleEffect(bounce ? 1.1 : 1.0)
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 250, damping: 6).repeatCount(1, autoreverses: true)) {
                    bounce = true
                }
            }
    }
}
