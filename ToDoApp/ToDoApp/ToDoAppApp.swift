//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/19.
//

import SwiftUI
import RealmSwift

@main
struct ToDoAppApp: SwiftUI.App {
    init() {
        let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: "Category") { _, newObject in
                    newObject?["updatedAt"] = Date()
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        UITabBar.appearance().unselectedItemTintColor = UIColor.black

        UITabBar.appearance().standardAppearance = appearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemIndigo
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
            DependencyContainer.shared.weatherView
                .tabItem {
                    Image(systemName: "cloud.sun")
                    Text("Weather")
                }
            DependencyContainer.shared.tasksView
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Task")
                }
        }
        .accentColor(.indigo)
    }
}
