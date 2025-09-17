//
//  ToDoAppWidgetBundle.swift
//  ToDoAppWidget
//
//  Created by Thokozani Mncube on 2025/09/16.
//

import WidgetKit
import SwiftUI

@main
struct ToDoAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        ToDoAppWidget()
        ToDoAppWidgetControl()
        ToDoAppWidgetLiveActivity()
    }
}
