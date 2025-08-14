//
//  ZLWidget.swift
//  ZLWidget
//
//  Created by zhangliang on 2022/7/29.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import WidgetKit
import ActivityKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), providerInfo: "ZLWidget", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), providerInfo: "snapshot", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
//        for hourOffset in 0 ..< 60 {
//            if let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate) {
//                let entry = SimpleEntry(date: entryDate, providerInfo: "timeline", configuration: configuration)
//                entries.append(entry)
//            }
//        }

//        let nextDate = Calendar.current.date(byAdding: DateComponents(minute: 10), to: Date())!
        let entry = SimpleEntry(date: currentDate, providerInfo: "timeline", configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
    let configuration: ConfigurationIntent
}

struct ZLWidgetEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(entry.date, style: .time)
                Text(entry.providerInfo)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.purple)
    //        .widgetURL(<#T##Foundation.URL?#>)
        }
    }
}

//MARK: - new sample entry
//struct NewSimpleEntry: TimelineEntry {
//  public let date: Date
////  let character: CharacterDetail
//  let relevance: TimelineEntryRelevance?
//}


@main
struct ZLWidget: Widget {
    let kind: String = "ZLWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ZLWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//struct ZLWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        ZLWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
