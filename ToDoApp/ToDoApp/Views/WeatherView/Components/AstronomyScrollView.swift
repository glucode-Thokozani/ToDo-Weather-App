//
//  AstronomyScrollView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI
import SwiftUIPager

struct AstronomyScrollView: View {
    @StateObject private var page: Page = .first()
    let astronomy: Astro?
    
    var body: some View {
        let pages = [
            [
                AstronomyEvent(title: "Sunrise", icon: "sunrise.fill", time: astronomy?.sunrise ?? "--"),
                AstronomyEvent(title: "Sunset", icon: "sunset.fill", time: astronomy?.sunset ?? "--")
            ],
            [
                AstronomyEvent(title: "Moonrise", icon: "moon.stars.fill", time: astronomy?.moonrise ?? "--"),
                AstronomyEvent(title: "Moonset", icon: "moon.zzz.fill", time: astronomy?.moonset ?? "--")
            ]
        ]
        
        Pager(page: page, data: Array(pages.indices), id: \.self) { index in
            HStack(spacing: 175) {
                ForEach(pages[index], id: \.title) { event in
                    VStack {
                        Image(systemName: event.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                        
                        Text(event.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(event.time)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
        .loopPages()
        .itemSpacing(10)
        .preferredItemSize(CGSize(width: UIScreen.main.bounds.width * 0.8, height: 130))
        .frame(height: 130)
        .animation(.easeInOut(duration: 0.3), value: page.index)
    }
}

struct AstronomyEvent: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let time: String
}
