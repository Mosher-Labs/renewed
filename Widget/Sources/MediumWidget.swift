import SwiftUI
import WidgetKit

struct MediumWidget: Widget {
  let kind: String = "MediumWidget"

  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind, intent: SelectTwoTrackersIntent.self, provider: MediumWidgetProvider()
    ) { entry in
      MediumWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Renewed (Dual)")
    .description("Track two journeys side by side.")
    .supportedFamilies([.systemMedium])
  }
}

struct MediumWidget_Previews: PreviewProvider {
  static var previews: some View {
    MediumWidgetEntryView(
      entry: MediumEntry(
        date: Date(),
        trackers: [
          TrackerData(
            id: "1", title: "Sobriety", days: 42, iconName: "leaf.fill", color: "green"),
          TrackerData(
            id: "2", title: "Meditation", days: 15, iconName: "brain.head.profile",
            color: "purple"),
        ],
        totalTrackerCount: 5
      )
    )
    .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
