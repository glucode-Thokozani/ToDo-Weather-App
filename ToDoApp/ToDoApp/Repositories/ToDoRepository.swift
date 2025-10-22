//
//  ToDoRepository.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import Foundation
import RealmSwift

class ToDoRepository: ToDoRepositoryProtocol {
    private let storage: ToDoStorage
    
    init(storage: ToDoStorage) {
        self.storage = storage
    }
    
    func addTodo(to category: Category, todo: ToDo) throws {
        try storage.addTodo(to: category, todo: todo)
    }
    
    func readTodo(for category: Category) -> Results<ToDo> {
        return storage.readTodo(for: category)
    }
    
    func updateTodo(_ todo: ToDo) throws {
        try storage.updateTodo(todo)
    }
    
    func delete(todo: ToDo) throws {
        try storage.delete(todo: todo)
    }
    
    func toggleCompletion(for todo: ToDo) throws {
        try storage.toggleCompletion(for: todo)
    }
    
    func updateTask(_ task: ToDo, title: String, dueDate: Date?, isComplete: Bool) throws {
        try storage.updateTask(task, title: title, dueDate: dueDate, isComplete: isComplete)
    }
    
    func moveTask(_ task: ToDo, to newCategory: Category) throws {
        try storage.moveTask(task, to: newCategory)
    }
}
