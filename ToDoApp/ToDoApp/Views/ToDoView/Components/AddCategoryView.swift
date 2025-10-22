//
//  AddCategoryView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI

struct AddCategoryView: View {
    @State private var categoryName: String = ""
    @Environment(\.dismiss) var dismiss

    var onSave: (String) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $categoryName)
                    .disableAutocorrection(true)
            }
            .navigationTitle("Add Category")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedName.isEmpty else { return }
                        onSave(trimmedName)
                        dismiss()
                    }
                    .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
