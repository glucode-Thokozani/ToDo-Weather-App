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
    @State private var selectedEdit: EditSelection? = nil
    
    private let dependencyContainer: ToDoDependencyContainer
    
    init(viewModel: TaskViewModel, dependencyContainer: ToDoDependencyContainer) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.dependencyContainer = dependencyContainer
    }
    
    var body: some View {
        VStack {
            HStack {
                GreetingView(userName: "TK")
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
                    editTask: { task in
                        selectedEdit = EditSelection(id: task.id)
                    }
                )
            } else {
                Text("Please select a category")
                    .padding()
            }
            
            Spacer()
        }
        .sheet(item: $selectedEdit) { selection in
            if let live = viewModel.todos.first(where: { $0.id == selection.id }) {
                dependencyContainer.editTaskView(for: live)
            } else {
                Text("Task no longer exists")
            }
        }
    }
}

private struct EditSelection: Identifiable {
    let id: String
}
