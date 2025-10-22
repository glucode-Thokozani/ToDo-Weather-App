//
//  AddTaskButton.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI

struct AddTaskButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "square.and.pencil")
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
