//
//  RealmStorage.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import Foundation
import RealmSwift

class RealmStorage: StorageProtocol {
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
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
