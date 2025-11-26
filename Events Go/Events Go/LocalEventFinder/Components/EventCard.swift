import SwiftUI
import MapKit

// MARK: - EventCard
struct EventCard: View {
    let event: EventDTO
    let isSaved: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 12) {
            Image("Placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 84, height: 84)
                .clipped()
                .cornerRadius(10)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(event.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Spacer(minLength: 8)
                    Image(systemName: isSaved ? "star.fill" : "star")
                        .foregroundStyle(isSaved ? .yellow : .secondary)
                        .accessibilityLabel(isSaved ? "Saved" : "Not saved")
                }

                Text(formattedDates(event))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill").foregroundStyle(categoryColor(event.category))
                    Text(event.briefLocation)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .modifier(CardStyleModifier())
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .onTapGesture(perform: onTap)
        .onLongPressGesture(perform: onLongPress)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(event.title), \(formattedDates(event)), \(event.briefLocation)")
        .accessibilityHint("Double tap for details. Long press for quick actions.")
        .animation(.easeInOut(duration: 0.25), value: isSaved)
    }

    private func formattedDates(_ event: EventDTO) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        if let end = event.endDate {
            return "\(df.string(from: event.startDate)) - \(df.string(from: end))"
        } else {
            return df.string(from: event.startDate)
        }
    }

    private func categoryColor(_ category: String) -> Color {
        switch category.lowercased() {
        case "music": return .pink
        case "sports": return .blue
        case "arts": return .purple
        case "tech": return .green
        default: return .gray
        }
    }
}
