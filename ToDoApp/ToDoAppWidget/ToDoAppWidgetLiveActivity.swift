//
//  ToDoAppWidgetLiveActivity.swift
//  ToDoAppWidget
//
//  Created by Thokozani Mncube on 2025/09/16.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ToDoAppWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
    }
    var name: String
}

struct ToDoAppWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ToDoAppWidgetAttributes.self) { context in
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ToDoAppWidgetAttributes {
    fileprivate static var preview: ToDoAppWidgetAttributes {
        ToDoAppWidgetAttributes(name: "World")
    }
}

extension ToDoAppWidgetAttributes.ContentState {
    fileprivate static var smiley: ToDoAppWidgetAttributes.ContentState {
        ToDoAppWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ToDoAppWidgetAttributes.ContentState {
         ToDoAppWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ToDoAppWidgetAttributes.preview) {
   ToDoAppWidgetLiveActivity()
} contentStates: {
    ToDoAppWidgetAttributes.ContentState.smiley
    ToDoAppWidgetAttributes.ContentState.starEyes
}
