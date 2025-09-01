//
//  AddTaskViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import RealmSwift
import Combine
import Foundation

class AddTaskViewModel: ObservableObject {
    private let storage = ToDoStorage()

    @Published var taskTitle: String = ""
    @Published var dueDate: Date = Date()
    @Published var errorMessage: String? = nil

    private let category: Category

    init(category: Category) {
        self.category = category
    }

    func addTask() {
        let trimmedTitle = taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Task title can't be empty"
            return
        }

        let newTask = ToDo()
        newTask.task = trimmedTitle
        newTask.dueDate = dueDate
        
        storage.addTodo(to: category, todo: newTask)
        taskTitle = ""
        dueDate = Date()
        errorMessage = nil
    }
}

