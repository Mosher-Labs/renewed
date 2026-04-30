import SwiftUI
import WidgetKit

struct MediumWidgetEntryView: View {
  var entry: MediumEntry

  var body: some View {
    Group {
      if entry.trackers.isEmpty {
        emptyStateView
      } else {
        trackerContentView
      }
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }

  private var trackerContentView: some View {
    VStack(spacing: 4) {
      HStack(spacing: 12) {
        trackerCard(for: entry.trackers[0])

        if entry.trackers.count > 1 {
          trackerCard(for: entry.trackers[1])
        } else {
          emptySlotView
        }
      }

      if entry.totalTrackerCount > entry.trackers.count {
        let remaining = entry.totalTrackerCount - entry.trackers.count
        Text("+\(remaining) more")
          .font(.caption2)
          .foregroundStyle(.secondary)
      }
    }
  }

  private func trackerCard(for tracker: TrackerData) -> some View {
    VStack(spacing: 4) {
      Image(systemName: tracker.iconName)
        .font(.title2)
        .foregroundStyle(color(for: tracker.color))

      Text("\(tracker.days)")
        .font(.system(.title, design: .rounded, weight: .bold))
        .foregroundStyle(color(for: tracker.color))

      Text(tracker.days == 1 ? "day" : "days")
        .font(.caption)
        .foregroundStyle(.secondary)

      Text(tracker.title)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity)
  }

  private var emptySlotView: some View {
    VStack(spacing: 4) {
      Image(systemName: "plus.circle.dashed")
        .font(.title2)
        .foregroundStyle(.quaternary)

      Text("Add another")
        .font(.caption)
        .foregroundStyle(.quaternary)

      Text("tracker")
        .font(.caption2)
        .foregroundStyle(.quaternary)
    }
    .frame(maxWidth: .infinity)
  }

  private var emptyStateView: some View {
    VStack(spacing: 4) {
      Image(systemName: "plus.circle")
        .font(.title2)
        .foregroundStyle(.secondary)

      Text("Add a tracker")
        .font(.caption)
        .foregroundStyle(.secondary)

      Text("in Renewed")
        .font(.caption2)
        .foregroundStyle(.tertiary)
    }
  }

  private func color(for name: String) -> Color {
    switch name {
    case "red": return .red
    case "orange": return .orange
    case "yellow": return .yellow
    case "green": return .green
    case "blue": return .blue
    case "purple": return .purple
    case "pink": return .pink
    case "mint": return .mint
    case "teal": return .teal
    case "indigo": return .indigo
    default: return .green
    }
  }
}
