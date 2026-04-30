import WidgetKit

struct TrackerData {
  let id: String
  let title: String
  let days: Int
  let iconName: String
  let color: String
}

struct MediumEntry: TimelineEntry {
  let date: Date
  let trackers: [TrackerData]
  let totalTrackerCount: Int
}
