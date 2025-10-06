//
//  WeatherWidget.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/22.
//

import WidgetKit
import SwiftUI

struct WeatherEntry: TimelineEntry {
    let date: Date
    let temperature: Int
    let condition: String
    let city: String
}

struct WeatherProvider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), temperature: 0, condition: "Loading", city: "City")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        completion(loadEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let entry = loadEntry()
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800)))
        completion(timeline)
    }
    
    private func loadEntry() -> WeatherEntry {
#if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return WeatherEntry(date: Date(), temperature: 26, condition: "Sunny", city: "Johannesburg")
        }
#endif
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.TK.ToDoApp")
        let temperature = sharedDefaults?.integer(forKey: "temperature") ?? 0
        let condition = sharedDefaults?.string(forKey: "condition") ?? "Unknown"
        let city = sharedDefaults?.string(forKey: "city") ?? "City"
        
        return WeatherEntry(date: Date(), temperature: temperature, condition: condition, city: city)
    }
}

struct WeatherWidgetEntryView: View {
    var entry: WeatherProvider.Entry
    //var action: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.city)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(entry.temperature)°C")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Blah blah blah")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50, alignment: .topLeading)
                        .font(.system(size: 14, weight: .semibold))
                        .padding()
                    
                }.background(.ultraThinMaterial.opacity(0.12))
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                HStack {
                    Spacer()
                    Link(destination: URL(string: "myapp://addtask")!) {
                        Text("Add Task")
                            .foregroundColor(.black)
                            .padding(7)
                            .background(Color.white)
                            .cornerRadius(19)
                    }
                }
            }
        }
        .containerBackground(for: .widget) {
            NightTimeView()
        }
    }
}

struct DayTimeView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.55), Color("WidgetDayTime")]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct NightTimeView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color("WidgetNightTime"), Color("WidgetDayTime")]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct WeatherWidget: Widget {
    let kind = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Shows the latest weather info.")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemMedium) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, temperature: 26, condition: "Sunny", city: "Johannesburg")
    WeatherEntry(date: .now.addingTimeInterval(3600), temperature: 28, condition: "Partly Cloudy", city: "Johannesburg")
}



