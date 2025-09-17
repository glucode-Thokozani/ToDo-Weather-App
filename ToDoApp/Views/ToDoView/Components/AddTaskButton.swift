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
