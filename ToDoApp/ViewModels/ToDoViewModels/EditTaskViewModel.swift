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
    private let storage = ToDoStorage()
    
    @Published var taskTitle: String
    @Published var dueDate: Date
    @Published var isComplete: Bool
    @Published var errorMessage: String = ""
    
    var task: ToDo

    init(task: ToDo) {
        self.task = task
        self.taskTitle = task.task
        self.dueDate = task.dueDate ?? Date()
        self.isComplete = task.isComplete
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
