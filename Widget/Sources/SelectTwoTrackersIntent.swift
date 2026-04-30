import AppIntents
import WidgetKit

struct SelectTwoTrackersIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource = "Select Two Trackers"
  static var description: IntentDescription = "Choose two trackers to display side by side."

  @Parameter(title: "First Tracker")
  var tracker1: TrackerEntity?

  @Parameter(title: "Second Tracker")
  var tracker2: TrackerEntity?
}
