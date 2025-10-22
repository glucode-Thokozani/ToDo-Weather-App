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
    func updateTask(_ task: ToDo, title: String, dueDate: Date?, isComplete: Bool) throws
    func moveTask(_ task: ToDo, to newCategory: Category) throws
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

    init(configuration: Realm.Configuration) {
        do {
            realm = try Realm(configuration: configuration)
        } catch {
            fatalError("Failed to initialize Realm with configuration: \(error)")
        }
    }
    
    func addTodo(to category: Category, todo: ToDo) throws {
            try realm.write {
                todo.category = category
                category.items.append(todo)
                category.updatedAt = Date()
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

    func updateTask(_ task: ToDo, title: String, dueDate: Date?, isComplete: Bool) throws {
        try realm.write {
            task.task = title
            task.dueDate = dueDate
            task.isComplete = isComplete
            if let category = task.category ?? task.parentCategory.first {
                category.updatedAt = Date()
            }
        }
    }
    
    func delete(todo: ToDo) throws {
        guard let task = realm.object(ofType: ToDo.self, forPrimaryKey: todo.id) else {
            throw NSError(domain: "ToDoApp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Task not found"])
        }

        try realm.write {
            if let category = task.category ?? task.parentCategory.first {
                category.updatedAt = Date()
                
                if let index = category.items.firstIndex(where: { $0.id == task.id }) {
                    category.items.remove(at: index)
                }
            }

            realm.delete(task)
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
        guard let task = realm.object(ofType: ToDo.self, forPrimaryKey: todo.id) else {
            throw NSError(domain: "ToDoApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Task not found"])
        }

        try realm.write {
            task.isComplete.toggle()
            
            if let category = task.category ?? task.parentCategory.first {
                category.updatedAt = Date()
            }
        }
    }

    func moveTask(_ task: ToDo, to newCategory: Category) throws {
        guard let liveTask = realm.object(ofType: ToDo.self, forPrimaryKey: task.id) else {
            throw NSError(domain: "ToDoApp", code: 3, userInfo: [NSLocalizedDescriptionKey: "Task not found for move"])
        }
        try realm.write {
            if let oldCategory = liveTask.category ?? liveTask.parentCategory.first,
               let index = oldCategory.items.firstIndex(where: { $0.id == liveTask.id }) {
                oldCategory.items.remove(at: index)
                oldCategory.updatedAt = Date()
            }
            if !newCategory.items.contains(where: { $0.id == liveTask.id }) {
                newCategory.items.append(liveTask)
            }
            liveTask.category = newCategory
            newCategory.updatedAt = Date()
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
