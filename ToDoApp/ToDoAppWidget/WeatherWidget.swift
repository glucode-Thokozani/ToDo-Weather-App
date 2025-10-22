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
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.TK.ToDoApp")
        let temperature = sharedDefaults?.integer(forKey: "temperature") ?? 0
        let condition = sharedDefaults?.string(forKey: "condition") ?? "Unknown"
        let city = sharedDefaults?.string(forKey: "city") ?? "City"
        
        return WeatherEntry(date: Date(), temperature: temperature, condition: condition, city: city)
    }
}

struct WeatherWidgetEntryView: View {
    var entry: WeatherProvider.Entry
    
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
                    Text("No Tasks for today ;)")
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
                        HStack{
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(12)
                                    .frame(width: 90, height: 35)
                                
                                Text("🔍 Location")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                    .padding(7)
                            }
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(12)
                                    .frame(width: 80, height: 35)
                                
                                Text("Add Task")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                    .padding(7)
                            }
                        }
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
            gradient: Gradient(colors: [Color.blue.opacity(0.6), Color("WidgetDayTime")]),
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

extension WeatherEntry {
    static func fromSharedDefaults() -> WeatherEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.TK.ToDoApp")
        let temp = 22
        let condition = "Sunny"
        let city = "Johannesburg"
        return WeatherEntry(date: Date(), temperature: temp, condition: condition, city: city)
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherEntry.fromSharedDefaults())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

