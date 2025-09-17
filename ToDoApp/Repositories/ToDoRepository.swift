//
//  ToDoRepository.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import Foundation
import RealmSwift

class ToDoRepository: ToDoRepositoryProtocol {
    private let storage: StorageProtocol
    
    init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    func addTodo(to category: Category, todo: ToDo) {
        do {
            try storage.save(todo)
            try storage.update(category)
        } catch {
            print("An error occurred while saving the Task: \(error)")
        }
    }
    
    func readTodo(for category: Category) -> Results<ToDo> {
        return category.items.sorted(byKeyPath: "dueDate", ascending: true)
    }
    
    func updateTodo(_ todo: ToDo) {
        do {
            try storage.update(todo)
        } catch {
            print("An error occurred while updating the task: \(error)")
        }
    }
    
    func delete(todo: ToDo) {
        do {
            try storage.delete(todo)
        } catch {
            print("An error occurred while deleting the task: \(error)")
        }
    }
    
    func toggleCompletion(for todo: ToDo) {
        do {
            try storage.update(todo)
        } catch {
            print("Failed to toggle task completion: \(error)")
        }
    }
}
