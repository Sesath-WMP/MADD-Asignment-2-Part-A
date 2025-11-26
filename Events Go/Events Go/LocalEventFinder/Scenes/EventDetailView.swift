import SwiftUI
import MapKit

struct EventDetailView: View {
    @ObservedObject var viewModel: EventDetailViewModel
    @State private var region: MKCoordinateRegion

    init(viewModel: EventDetailViewModel) {
        self.viewModel = viewModel
        _region = State(initialValue: MKCoordinateRegion(center: viewModel.event.coordinate, span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02)))
    }

    var body: some View {
        ScrollView {
            headerImage
            VStack(alignment: .leading, spacing: 16) {
                titleBar
                dateSection
                mapSnapshot
                Text(viewModel.event.details)
                    .font(.body)
                    .foregroundStyle(.primary)

                organizerSection
                actionButtons
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerImage: some View {
        Image("Placeholder")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .clipped()
            .accessibilityHidden(true)
    }

    private var titleBar: some View {
        HStack {
            Text(viewModel.event.title)
                .font(.title2.weight(.semibold))
                .accessibilityAddTraits(.isHeader)
            Spacer()
            Button {
                viewModel.toggleSaved()
            } label: {
                Image(systemName: viewModel.event.isSaved ? "star.fill" : "star")
                    .foregroundStyle(viewModel.event.isSaved ? .yellow : .primary)
            }
            .accessibilityLabel(viewModel.event.isSaved ? "Unsave event" : "Save event")
            ShareLink(item: "\(viewModel.event.title) at \(viewModel.event.briefLocation)") {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel("Share")
        }
    }

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(formatDateRange(viewModel.event), systemImage: "calendar")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private var mapSnapshot: some View {
        Map(initialPosition: .region(region))
            .frame(height: 160)
            .cornerRadius(12)
            .allowsHitTesting(false)
            .overlay(alignment: .topLeading) {
                Label(viewModel.event.briefLocation, systemImage: "mappin.circle.fill")
                    .padding(8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(8)
            }
            // Note: For EventKit add-to-calendar integration, request permission via EventKit APIs here.
    }

    private var organizerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Organizer").font(.headline)
            Text("LocalEventFinder Team").foregroundStyle(.secondary)
        }
    }

    private var actionButtons: some View {
        HStack {
            Button {
                // Placeholder for EventKit add-to-calendar
                // Request EKEventStore authorization and create EKEvent with details
            } label: {
                Label("Add to Calendar", systemImage: "calendar.badge.plus")
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
    }

    private func formatDateRange(_ event: EventDTO) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        if let end = event.endDate {
            return "\(df.string(from: event.startDate)) - \(df.string(from: end))"
        }
        return df.string(from: event.startDate)
    }
}
