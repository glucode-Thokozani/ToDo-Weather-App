//
//  EditTaskView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//

import SwiftUI
import RealmSwift

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: EditTaskViewModel
    var categories: Results<Category>

    @State private var selectedCategoryId: String

    init(task: ToDo, categories: Results<Category>) {
        _viewModel = StateObject(wrappedValue: EditTaskViewModel(task: task))
        self.categories = categories
        self._selectedCategoryId = State(initialValue: task.category?.id ?? categories.first?.id ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task")) {
                    TextField("Task name", text: $viewModel.taskTitle)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Select Date", selection: $viewModel.dueDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }

                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategoryId) {
                        ForEach(categories, id: \.id) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(viewModel.taskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage.isEmpty == false },
                set: { _ in viewModel.errorMessage = "" }
            )) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveChanges() {
        guard let newCategory = categories.first(where: { $0.id == selectedCategoryId }) else {
            dismiss()
            return
        }

        do {
            let realm = try Realm()
            try realm.write {
                viewModel.saveChanges()

                if viewModel.task.category?.id != newCategory.id {
                    if let oldCategory = viewModel.task.category {
                        if let index = oldCategory.items.firstIndex(where: { $0.id == viewModel.task.id }) {
                            oldCategory.items.remove(at: index)
                        }
                    }
                    newCategory.items.append(viewModel.task)
                    viewModel.task.category = newCategory
                }
            }
            dismiss()
        } catch {
            viewModel.errorMessage = "Failed to save changes: \(error.localizedDescription)"
        }
    }
}
