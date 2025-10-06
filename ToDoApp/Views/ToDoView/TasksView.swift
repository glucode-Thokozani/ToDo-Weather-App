//
//  TasksView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/20.
//

import SwiftUI
import RealmSwift

struct TasksView: View {
    @StateObject private var viewModel: TaskViewModel
    @State private var selectedTaskEdit: ToDo? = nil
    
    private let dependencyContainer: ToDoDependencyContainer
    
    init(viewModel: TaskViewModel, dependencyContainer: ToDoDependencyContainer) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.dependencyContainer = dependencyContainer
    }

    var body: some View {
        VStack {
            GreetingView(userName: "TK")
            
            CategoriesView(categories: viewModel.categories, selectedCategory: $viewModel.selectedCategory)
            
            AddCategoryButton {
                viewModel.showAddCategory = true
            }
            .sheet(isPresented: $viewModel.showAddCategory) {
                AddCategoryView { newCategoryName in
                    viewModel.addCategory(name: newCategoryName)
                    viewModel.showAddCategory = false
                }
            }
            
            if let _ = viewModel.selectedCategory {
                UserTasksView(
                    tasks: viewModel.todos,
                    toggleCompletion: viewModel.toggleTaskCompletion,
                    deleteTask: viewModel.deleteTask,
                    editTask: { task in      // <-- Added missing comma before this line
                        selectedTaskEdit = task
                    }
                )
            } else {
                Text("Please select a category")
                    .padding()
            }

            Spacer()

            AddTaskButton {
                viewModel.showAddTask = true
            }
            .sheet(isPresented: $viewModel.showAddTask) {
                if let selected = viewModel.selectedCategory {
                    dependencyContainer.addTaskView(for: selected)
                } else {
                    Text("Please select a category before adding a task.")
                        .padding()
                }
            }
        }
        .sheet(item: $selectedTaskEdit) { taskToEdit in
            let editVM = EditTaskViewModel(task: taskToEdit, toDoStorage: viewModel.toDoStorage)
            EditTaskView(viewModel: editVM)
        }
    }
}
