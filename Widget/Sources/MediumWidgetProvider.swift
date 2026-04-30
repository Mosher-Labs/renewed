import SwiftData
import WidgetKit

struct MediumWidgetProvider: AppIntentTimelineProvider {
  private static let container: ModelContainer = SharedModelContainer.create()

  func placeholder(in context: Context) -> MediumEntry {
    MediumEntry(
      date: Date(),
      trackers: [
        TrackerData(id: "1", title: "Sobriety", days: 42, iconName: "leaf.fill", color: "green"),
        TrackerData(
          id: "2", title: "Meditation", days: 15, iconName: "brain.head.profile", color: "purple"),
      ],
      totalTrackerCount: 2
    )
  }

  func snapshot(for configuration: SelectTwoTrackersIntent, in context: Context) async
    -> MediumEntry
  {
    if context.isPreview {
      return placeholder(in: context)
    }

    return fetchEntry(for: configuration, at: Date())
  }

  func timeline(
    for configuration: SelectTwoTrackersIntent, in context: Context
  ) async -> Timeline<MediumEntry> {
    let calendar = Calendar.current
    let startOfToday = calendar.startOfDay(for: Date())
    let trackers = fetchTrackers(for: configuration)
    let totalCount = fetchAllTrackerCount()

    var entries: [MediumEntry] = []
    for dayOffset in 0..<7 {
      let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfToday)!
      let entry = makeEntry(
        for: trackers, at: entryDate, totalCount: totalCount, calendar: calendar)
      entries.append(entry)
    }

    return Timeline(entries: entries, policy: .atEnd)
  }

  private func fetchTrackers(for configuration: SelectTwoTrackersIntent) -> [Tracker] {
    let context = ModelContext(Self.container)
    context.autosaveEnabled = false

    let hasUserSelection = configuration.tracker1 != nil || configuration.tracker2 != nil

    // No user selection — show 2 newest trackers as default
    if !hasUserSelection {
      var descriptor = FetchDescriptor<Tracker>(
        sortBy: [SortDescriptor(\.startDate, order: .reverse)]
      )
      descriptor.fetchLimit = 2
      return (try? context.fetch(descriptor)) ?? []
    }

    // User has configured at least one picker — resolve selections, skip duplicates
    var resolved: [Tracker] = []
    var resolvedIDs: Set<UUID> = []

    for selectedID in [configuration.tracker1?.id, configuration.tracker2?.id] {
      guard let idString = selectedID, let uuid = UUID(uuidString: idString) else { continue }
      guard !resolvedIDs.contains(uuid) else { continue }
      let predicate = #Predicate<Tracker> { $0.id == uuid }
      var descriptor = FetchDescriptor<Tracker>(predicate: predicate)
      descriptor.fetchLimit = 1
      if let tracker = try? context.fetch(descriptor).first {
        resolved.append(tracker)
        resolvedIDs.insert(tracker.id)
      }
    }

    return resolved
  }

  private func fetchAllTrackerCount() -> Int {
    let context = ModelContext(Self.container)
    context.autosaveEnabled = false
    let descriptor = FetchDescriptor<Tracker>()
    return (try? context.fetchCount(descriptor)) ?? 0
  }

  private func fetchEntry(for configuration: SelectTwoTrackersIntent, at date: Date) -> MediumEntry
  {
    let trackers = fetchTrackers(for: configuration)
    let totalCount = fetchAllTrackerCount()
    return makeEntry(for: trackers, at: date, totalCount: totalCount, calendar: .current)
  }

  private func makeEntry(
    for trackers: [Tracker], at date: Date, totalCount: Int, calendar: Calendar
  ) -> MediumEntry {
    let trackerData = trackers.map { tracker -> TrackerData in
      let startDay = calendar.startOfDay(for: tracker.startDate)
      let entryDay = calendar.startOfDay(for: date)
      let days = calendar.dateComponents([.day], from: startDay, to: entryDay).day ?? 0
      return TrackerData(
        id: tracker.id.uuidString,
        title: tracker.title,
        days: days,
        iconName: tracker.iconName,
        color: tracker.color
      )
    }

    return MediumEntry(
      date: date,
      trackers: trackerData,
      totalTrackerCount: totalCount
    )
  }
}
