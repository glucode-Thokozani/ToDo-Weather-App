//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/19.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        UITabBar.appearance().unselectedItemTintColor = UIColor.black

        UITabBar.appearance().standardAppearance = appearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.lightBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
            WeatherTasksTabView()
        }
    }
}

struct WeatherTasksTabView: View {
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Image(systemName: "cloud.sun")
                    Text("Weather")
                }
            
            TasksView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Task")
                }
        }
        .accentColor(.blue)
    }
}


