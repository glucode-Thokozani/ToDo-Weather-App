//
//  EditTaskViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import RealmSwift
import Combine
import Foundation
import SwiftUICore

class EditTaskViewModel: ObservableObject {
    private let storage: ToDoStorage
    
    @Published var taskTitle: String
    @Published var dueDate: Date
    @Published var isComplete: Bool
    @Published var errorMessage: String = ""
    @Published var selectedCategoryId: String? = nil
    @Published var categories: [Category] = []
    
    @Environment(\.dismiss) var dismiss
    
    var task: ToDo

    init(task: ToDo, toDoStorage: ToDoStorage) {
        self.task = task
        self.storage = toDoStorage
        self.taskTitle = task.task
        self.dueDate = task.dueDate ?? Date()
        self.isComplete = task.isComplete
        
        loadCategories()
    }

    private func loadCategories() {
        let allCategories = storage.readCategories()
        self.categories = Array(allCategories)
        self.selectedCategoryId = task.category?.id ?? allCategories.first?.id ?? ""
    }
    
    func saveChanges(to newCategory: Category) {
        do {
            let realm = try Realm()
            try realm.write {
                task.task = taskTitle
                task.dueDate = dueDate
                task.isComplete = isComplete

                if task.category?.id != newCategory.id {
                    if let oldCategory = task.category,
                       let index = oldCategory.items.firstIndex(where: { $0.id == task.id }) {
                        oldCategory.items.remove(at: index)
                    }
                    if !newCategory.items.contains(where: { $0.id == task.id }) {
                        newCategory.items.append(task)
                    }

                    task.category = newCategory
                }
            }
        } catch {
            errorMessage = "Failed to save changes: \(error.localizedDescription)"
        }
    }

    func deleteTask() {
        do {
            try storage.delete(todo: task)
        } catch {
            errorMessage = "Failed to delete the task"
        }
    }
    
    func UpdateChanges() {
        guard let newCategory = categories.first(where: { $0.id == selectedCategoryId }) else {
            dismiss()
            return
        }

        saveChanges(to: newCategory)

        if errorMessage.isEmpty {
            
        }
    }
}
