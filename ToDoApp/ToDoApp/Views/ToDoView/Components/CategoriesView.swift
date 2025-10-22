//
//  CategoriesView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI
import RealmSwift

struct CategoriesView: View {
    var categories: [Category]
    @Binding var selectedCategory: Category?

    var body: some View {
        VStack(alignment: .leading) {
            Text("CATEGORIES")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(categories, id: \.id) { category in
                        CategoryCard(category: category) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 150)
        }
    }
}

private struct CategoryCard: View {
    @ObservedRealmObject var category: Category
    var onTap: () -> Void

    init(category: Category, onTap: @escaping () -> Void) {
        self.onTap = onTap
        self._category = ObservedRealmObject(wrappedValue: category)
    }

    var body: some View {
        let total = category.items.count
        let complete = category.items.filter { $0.isComplete }.count

        return VStack(alignment: .leading, spacing: 10) {
            Text("\(total) tasks")
                .font(.subheadline)
            Text(category.name)
                .font(.headline)

            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 6)
                    .foregroundColor(.gray.opacity(0.3))

                Capsule()
                    .frame(width: CGFloat(complete) / CGFloat(max(total, 1)) * 180, height: 6)
                    .foregroundColor(.pink)
                    .animation(.easeInOut, value: complete)
                    .animation(.easeInOut, value: total)
            }
            .frame(height: 6)
        }
        .padding()
        .frame(width: 200, height: 130)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .onTapGesture { onTap() }
    }
}
