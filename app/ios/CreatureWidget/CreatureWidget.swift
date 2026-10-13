import SwiftUI
import WidgetKit

/// Muss zur App-Gruppe in `HomeWidgetPublisher.appGroup` passen.
private let appGroup = "group.app.wandoo.wandoo"

struct CreatureEntry: TimelineEntry {
  let date: Date
  let face: String
  let stage: String
  let detail: String
  let mood: String

  static let sample = CreatureEntry(
    date: Date(), face: "🥚", stage: "Ei", detail: "0 neue Wege",
    mood: "wartet auf den ersten Gang")
}

/// Liest die Texte, die die App über `home_widget` abgelegt hat.
struct CreatureProvider: TimelineProvider {
  func placeholder(in context: Context) -> CreatureEntry { .sample }

  func getSnapshot(in context: Context, completion: @escaping (CreatureEntry) -> Void) {
    completion(read())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<CreatureEntry>) -> Void) {
    // Die App stößt nach jedem Gang ein Neuladen an.
    completion(Timeline(entries: [read()], policy: .never))
  }

  private func read() -> CreatureEntry {
    let data = UserDefaults(suiteName: appGroup)
    let sample = CreatureEntry.sample
    return CreatureEntry(
      date: Date(),
      face: data?.string(forKey: "face") ?? sample.face,
      stage: data?.string(forKey: "stage") ?? sample.stage,
      detail: data?.string(forKey: "detail") ?? sample.detail,
      mood: data?.string(forKey: "mood") ?? sample.mood)
  }
}

struct CreatureWidgetView: View {
  let entry: CreatureEntry

  var body: some View {
    VStack(spacing: 4) {
      Text(entry.face).font(.system(size: 40))
      Text(entry.stage).font(.headline)
      Text(entry.detail).font(.caption).foregroundColor(.secondary)
      Text(entry.mood).font(.caption2).multilineTextAlignment(.center)
    }
    .padding(8)
    .widgetBackground(Color(red: 0.93, green: 0.96, blue: 0.90))
  }
}

extension View {
  /// Ab iOS 17 verlangt WidgetKit einen eigenen Hintergrund.
  @ViewBuilder
  func widgetBackground(_ color: Color) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      containerBackground(for: .widget) { color }
    } else {
      background(color)
    }
  }
}

@main
struct CreatureWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "CreatureWidget", provider: CreatureProvider()) { entry in
      CreatureWidgetView(entry: entry)
    }
    .configurationDisplayName("Wandoo")
    .description("Dein Wesen auf einen Blick.")
    .supportedFamilies([.systemSmall])
  }
}
