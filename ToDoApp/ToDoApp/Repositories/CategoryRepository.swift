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
    
    func addCategory(name: String) throws {
        let category = Category()
        category.name = name
        try storage.save(category)
    }
    
    func readCategories() -> Results<Category> {
        return storage.fetch(Category.self).sorted(byKeyPath: "name")
    }
    
    func delete(category: Category) throws {
        for item in category.items {
            try storage.delete(item)
        }
        try storage.delete(category)
    }
    
    func addCategoryObject(_ category: Category) throws {
        try storage.save(category)
    }
}
