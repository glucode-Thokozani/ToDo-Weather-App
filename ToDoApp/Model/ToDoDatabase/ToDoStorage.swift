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
    func addTodo(to category: Category, todo: ToDo) throws
    func readTodo(for category: Category) -> Results<ToDo>
    func updateTodo(_ todo: ToDo) throws
    func delete(todo: ToDo) throws
    func toggleCompletion(for todo: ToDo) throws
}

protocol CategoryRepositoryProtocol {
    func addCategory(name: String) throws
    func readCategories() -> Results<Category>
    func delete(category: Category) throws
    func addCategoryObject(_ category: Category) throws
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
    
    func addTodo(to category: Category, todo: ToDo) throws {
            try realm.write {
                category.items.append(todo)
            }
    }
    
    func readTodo(for category: Category) -> Results<ToDo> {
        return category.items.sorted(byKeyPath: "dueDate", ascending: true)
    }
    
    func updateTodo(_ todo: ToDo) throws {
            try realm.write {
                realm.add(todo, update: .modified)
            }
    }
    
    func delete(todo: ToDo) throws {
            try realm.write {
                realm.delete(todo)
            }
        
    }
    
    func addCategory(name: String) throws {
        let category = Category()
        category.name = name
        
            try realm.write {
                realm.add(category)
            }
    }
    
    func readCategories() -> Results<Category> {
        return realm.objects(Category.self).sorted(byKeyPath: "name")
    }
    
    func delete(category: Category) throws {
            try realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
    }
    
    func toggleCompletion(for todo: ToDo) throws {
            try realm.write {
                todo.isComplete.toggle()
            }
        
    }
    func addCategoryObject(_ category: Category) throws {
            try realm.write {
                realm.add(category)
            }
    }
    
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
