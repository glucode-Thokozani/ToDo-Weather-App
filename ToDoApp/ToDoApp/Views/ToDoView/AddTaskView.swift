//
//  AddTaskView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddTaskViewModel
    init(viewModel: AddTaskViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $viewModel.taskTitle)
                    
                    DatePicker("Due Date", selection: $viewModel.dueDate, displayedComponents: .date)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                Section {
                    Button(action: {
                        viewModel.addTask()
                        dismiss()
                        
                    }) {
                        Text("Add Task")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Add Task")
        }
    }
}

