//
//  EditTaskViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import RealmSwift
import Combine
import Foundation

class EditTaskViewModel: ObservableObject {
    private let storage: ToDoStorage
    
    @Published var taskTitle: String
    @Published var dueDate: Date
    @Published var isComplete: Bool
    @Published var errorMessage: String = ""
    @Published var selectedCategoryId: String = ""
    @Published var categories: [Category] = []
    
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
           do {
               let realm = try Realm()
               let allCategories = realm.objects(Category.self)
               self.categories = Array(allCategories)
               self.selectedCategoryId = task.category?.id ?? allCategories.first?.id ?? ""
           } catch {
               self.errorMessage = "Failed to load categories: \(error.localizedDescription)"
           }
       }
    
    func saveChanges() {
        do {
            let realm = try Realm()
            try realm.write {
                task.task = taskTitle
                task.dueDate = dueDate
                task.isComplete = isComplete
            }
        } catch {
            errorMessage = "Failed to save changes: \(error.localizedDescription)"
        }
    }

    func deleteTask() {
        storage.delete(todo: task)
    }
}
