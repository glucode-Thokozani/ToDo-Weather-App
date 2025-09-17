//
//  TasksView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/20.
//

import SwiftUI
import RealmSwift

struct TasksView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showAddTask = false
    @State private var showAddCategory = false

    var body: some View {
        VStack {
            GreetingView(userName: "TK")
            
            CategoriesView(categories: viewModel.categories, selectedCategory: $viewModel.selectedCategory)
            Button(action: {
                showAddCategory = true
            }) {
                HStack {
                    Image(systemName: "folder.badge.plus")
                    Text("Add Category")
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $showAddCategory) {
                AddCategoryView { newCategoryName in
                    viewModel.addCategory(name: newCategoryName)
                    showAddCategory = false
                }
            }
            
            if let _ = viewModel.selectedCategory {
                UserTasksView(
                    tasks: viewModel.todos,
                    toggleCompletion: viewModel.toggleTaskCompletion,
                    deleteTask: viewModel.deleteTask
                )
            } else {
                Text("Please select a category")
                    .padding()
            }

            Spacer()

            AddTaskButton {
                showAddTask = true
            }
            .sheet(isPresented: $showAddTask) {
                if let selected = viewModel.selectedCategory {
                    AddTaskView(viewModel: AddTaskViewModel(category: selected))
                } else {
                    Text("Please select a category before adding a task.")
                        .padding()
                }
            }
        }
    }
}

struct GreetingView: View {
    var userName: String
    
    var body: some View {
        HStack {
            Text("Hey \(userName)! 👋")
                .font(.system(size: 40, weight: .medium))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CategoriesView: View {
    var categories: [Category]
    @Binding var selectedCategory: Category?

    var body: some View {
        VStack(alignment: .leading) {
            Text("CATEGORIES")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(categories, id: \.id) { category in
                        let total = category.items.count
                        let complete = category.items.filter { $0.isComplete }.count

                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(total) tasks")
                                .font(.subheadline)
                            Text(category.name)
                                .font(.headline)

                            ZStack(alignment: .leading) {
                                Capsule()
                                    .frame(height: 6)
                                    .foregroundColor(.gray.opacity(0.3))

                                Capsule()
                                    .frame(width: CGFloat(complete) / CGFloat(max(total, 1)) * 180, height: 6)
                                    .foregroundColor(.pink)
                                    .animation(.easeInOut, value: complete)
                            }
                            .frame(height: 6)
                        }
                        .padding()
                        .frame(width: 200, height: 130)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .onTapGesture {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 150)
        }
    }
}

struct UserTasksView: View {
    var tasks: [ToDo]
    var toggleCompletion: (ToDo) -> Void
    var deleteTask: (ToDo) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YOUR TASKS")
                .font(.headline)
                .padding(.bottom, 5)

            List {
                ForEach(tasks, id: \.id) { task in
                    Button(action: {
                        toggleCompletion(task)
                    }) {
                        HStack {
                            Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(task.isComplete ? .green : .gray)

                            VStack(alignment: .leading) {
                                Text(task.task)
                                    .font(.system(size: 19))
                                if let due = task.dueDate {
                                    Text("Due: \(due.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        deleteTask(tasks[index])
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal)
    }
}

struct AddTaskButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()
                .background(Color.pink)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct AddCategoryView: View {
    @State private var categoryName: String = ""
    @Environment(\.dismiss) var dismiss

    var onSave: (String) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $categoryName)
                    .disableAutocorrection(true)
            }
            .navigationTitle("Add Category")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedName.isEmpty else { return }
                        onSave(trimmedName)
                        dismiss()
                    }
                    .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
#Preview{
    TasksView()
}

