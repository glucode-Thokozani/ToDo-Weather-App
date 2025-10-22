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
    var editTask: (ToDo) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YOUR TASKS")
                .font(.headline)
                .padding(.bottom, 5)

            let rows: [TaskRowVM] = tasks
                .compactMap { $0.isInvalidated ? nil : $0.freeze() }
                .map { frozen in
                    TaskRowVM(id: frozen.id, title: frozen.task, dueDate: frozen.dueDate, isComplete: frozen.isComplete)
                }

            List {
                ForEach(rows, id: \.id) { row in
                    HStack {
                        Button(action: {
                            if let live = tasks.first(where: { $0.id == row.id }), !live.isInvalidated {
                                toggleCompletion(live)
                            }
                        }) {
                            Image(systemName: row.isComplete ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(row.isComplete ? .green : .gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        VStack(alignment: .leading) {
                            Text(row.title)
                                .font(.system(size: 19))
                            if let due = row.dueDate {
                                Text("Due: \(due.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            if let live = tasks.first(where: { $0.id == row.id }), !live.isInvalidated {
                                editTask(live)
                            }
                        }

                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .id(row.id)
                }
                .onDelete { indexSet in
                    let ids = indexSet.compactMap { rows[$0].id }
                    ids.forEach { id in
                        if let toDelete = tasks.first(where: { $0.id == id }), !toDelete.isInvalidated {
                            deleteTask(toDelete)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal)
    }
}

private struct TaskRowVM: Identifiable, Hashable {
    let id: String
    let title: String
    let dueDate: Date?
    let isComplete: Bool
}
