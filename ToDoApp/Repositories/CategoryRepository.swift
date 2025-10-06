//
//  CategoryRepository.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import Foundation
import RealmSwift

class CategoryRepository: CategoryRepositoryProtocol {
    private let storage: ToDoStorage
    
    init(storage: ToDoStorage) {
        self.storage = storage
    }
    
    func addCategory(name: String) {
        let category = Category()
        category.name = name
        
        do {
            try storage.save(category)
        } catch {
            print("Error adding Category: \(error)")
        }
    }
    
    func readCategories() -> Results<Category> {
        return storage.fetch(Category.self).sorted(byKeyPath: "name")
    }
    
    func delete(category: Category) {
        do {
            for item in category.items {
                try storage.delete(item)
            }
            try storage.delete(category)
        } catch {
            print("Error deleting Category: \(error)")
        }
    }
    
    func addCategoryObject(_ category: Category) {
        do {
            try storage.save(category)
        } catch {
            print("Error adding Category: \(error)")
        }
    }
}
