//
//  ToDoStorage.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/27.
//
import RealmSwift
import UIKit

protocol StorageProtocol {
    func save<T: Object>(_ object: T) throws
    func fetch<T: Object>(_ type: T.Type) -> Results<T>
    func delete<T: Object>(_ object: T) throws
    func update<T: Object>(_ object: T) throws
}

protocol ToDoRepositoryProtocol {
    func addTodo(to category: Category, todo: ToDo)
    func readTodo(for category: Category) -> Results<ToDo>
    func updateTodo(_ todo: ToDo)
    func delete(todo: ToDo)
    func toggleCompletion(for todo: ToDo)
}

protocol CategoryRepositoryProtocol {
    func addCategory(name: String)
    func readCategories() -> Results<Category>
    func delete(category: Category)
    func addCategoryObject(_ category: Category)
}

protocol WeatherDependencies {
    var weatherService: WeatherServiceProtocol { get }
}

protocol ToDoDependencies {
    var toDoRepository: ToDoRepositoryProtocol { get }
    var categoryRepository: CategoryRepositoryProtocol { get }
}

protocol AppDependencies: WeatherDependencies, ToDoDependencies {}

class ToDoStorage: StorageProtocol, ToDoRepositoryProtocol, CategoryRepositoryProtocol {
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func addTodo(to category: Category, todo: ToDo) {
        do {
            try realm.write {
                category.items.append(todo)
            }
        } catch {
            print("An error occurred while saving the Task: \(error)")
        }
    }
    
    func readTodo(for category: Category) -> Results<ToDo> {
        return category.items.sorted(byKeyPath: "dueDate", ascending: true)
    }
    
    func updateTodo(_ todo: ToDo) {
        do {
            try realm.write {
                realm.add(todo, update: .modified)
            }
        } catch {
            print("An error occurred while updating the task: \(error)")
        }
    }
    
    func delete(todo: ToDo) {
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print("An error occurred while deleting the task: \(error)")
        }
    }
    
    func addCategory(name: String) {
        let category = Category()
        category.name = name
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error adding Category: \(error)")
        }
    }
    
    func readCategories() -> Results<Category> {
        return realm.objects(Category.self).sorted(byKeyPath: "name")
    }
    
    func delete(category: Category) {
        do {
            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
        } catch {
            print("Error deleting Category: \(error)")
        }
    }
    
    func toggleCompletion(for todo: ToDo) {
        do {
            try realm.write {
                todo.isComplete.toggle()
            }
        } catch {
            print("Failed to toggle task completion: \(error)")
        }
    }
    func addCategoryObject(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error adding Category: \(error)")
        }
    }
    
    // MARK: - StorageProtocol Implementation
    func save<T: Object>(_ object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func fetch<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func delete<T: Object>(_ object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    
    func update<T: Object>(_ object: T) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
}
