//
//  ToDo.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/27.
//
import Foundation
import RealmSwift

class ToDo: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var task: String = ""
    @objc dynamic var dueDate: Date? = nil
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var category: Category? = nil
    
    let parentCategory = LinkingObjects(fromType:Category.self, property: "items")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Category: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String = ""
    let items = List<ToDo>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
