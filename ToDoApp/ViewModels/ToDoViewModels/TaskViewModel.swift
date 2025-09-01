//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import RealmSwift
import Combine
import Foundation

class TaskViewModel: ObservableObject {
    private let storage = ToDoStorage()
    private var notificationToken: NotificationToken?
    private var categoryToken: NotificationToken?

    @Published var todos: [ToDo] = []
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category? {
        didSet {
            observeTodos()
        }
    }

    init() {
        observeCategories()
    }

    private func observeCategories() {
        let results = storage.readCategories()
        categoryToken?.invalidate()
        categoryToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                DispatchQueue.main.async {
                    self?.categories = Array(results)
                }
            case .error(let error):
                print("Error observing categories: \(error)")
            }
        }
    }

    private func observeTodos() {
        notificationToken?.invalidate()

        guard let category = selectedCategory else {
            DispatchQueue.main.async {
                self.todos = []
            }
            return
        }

        let results = storage.readTodo(for: category)
        notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                DispatchQueue.main.async {
                    self.todos = Array(results)
                }
            case .error(let error):
                print("Error observing tasks: \(error)")
            }
        }
    }

    func toggleTaskCompletion(_ todo: ToDo) {
        storage.toggleCompletion(for: todo)
    }

    func deleteTask(_ todo: ToDo) {
        storage.delete(todo: todo)
    }

    func addCategory(name: String) {
        let category = Category()
        category.name = name
        storage.addCategoryObject(category)
    }

    deinit {
        notificationToken?.invalidate()
        categoryToken?.invalidate()
    }
}

