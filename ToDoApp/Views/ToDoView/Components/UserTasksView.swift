//
//  UserTasksView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI
import RealmSwift

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
