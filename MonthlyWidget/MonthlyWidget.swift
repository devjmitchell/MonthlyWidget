//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Jason Mitchell on 3/28/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of seven entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}

struct MonthlyWidgetEntryView : View {
    var entry: DayEntry
    var config: MonthConfig
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
            
            VStack {
                HStack(spacing: 4) {
                    Text(config.emojiText)
                        .font(.title)
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .bold()
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(config.weekdayTextColor)
                    Spacer()
                }
                
                Text(entry.date.dayDisplayFormat)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundStyle(config.dayTextColor)
            }
            .padding()
        }
    }
}

struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MonthlyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled() // I added to remove extra padding, not in Sean's course (issue from later iOS versions?)
    }
}

#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    DayEntry(date: .now)
    DayEntry(date: dateToDisplay(month: 1, day: 22))
    DayEntry(date: dateToDisplay(month: 2, day: 22))
    DayEntry(date: dateToDisplay(month: 3, day: 22))
    DayEntry(date: dateToDisplay(month: 4, day: 22))
    DayEntry(date: dateToDisplay(month: 5, day: 22))
    DayEntry(date: dateToDisplay(month: 6, day: 22))
    DayEntry(date: dateToDisplay(month: 7, day: 22))
    DayEntry(date: dateToDisplay(month: 8, day: 22))
    DayEntry(date: dateToDisplay(month: 9, day: 22))
    DayEntry(date: dateToDisplay(month: 10, day: 22))
    DayEntry(date: dateToDisplay(month: 11, day: 22))
    DayEntry(date: dateToDisplay(month: 12, day: 22))
}

// TODO: Move inside the new `#Preview` somehow?
private func dateToDisplay(month: Int, day: Int) -> Date {
    let components = DateComponents(calendar: .current, year: 2024, month: month, day: day)
    return Calendar.current.date(from: components)!
}

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}
