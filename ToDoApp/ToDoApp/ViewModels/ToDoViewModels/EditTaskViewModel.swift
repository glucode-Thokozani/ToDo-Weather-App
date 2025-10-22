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
    private let toDoRepository: ToDoRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol
    
    @Published var taskTitle: String
    @Published var dueDate: Date
    @Published var isComplete: Bool
    @Published var errorMessage: String = ""
    @Published var selectedCategoryId: String? = nil
    @Published var categories: [Category] = []
    
    @Environment(\.dismiss) var dismiss
    
    var task: ToDo

    init(task: ToDo, toDoRepository: ToDoRepositoryProtocol, categoryRepository: CategoryRepositoryProtocol) {
        self.task = task
        self.toDoRepository = toDoRepository
        self.categoryRepository = categoryRepository
        self.taskTitle = task.task
        self.dueDate = task.dueDate ?? Date()
        self.isComplete = task.isComplete
        
        loadCategories()
    }

    private func loadCategories() {
        let allCategories = categoryRepository.readCategories()
        self.categories = Array(allCategories)
        self.selectedCategoryId = task.category?.id ?? allCategories.first?.id ?? ""
    }
    
    func saveChanges(to newCategory: Category) {
        do {
            try toDoRepository.updateTask(task, title: taskTitle, dueDate: dueDate, isComplete: isComplete)
            if task.category?.id != newCategory.id {
                try toDoRepository.moveTask(task, to: newCategory)
            }
        } catch {
            errorMessage = "Failed to save changes: \(error.localizedDescription)"
        }
    }

    func deleteTask() {
        do {
            try toDoRepository.delete(todo: task)
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
