//
//  AddCategoryButton.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI

struct AddCategoryButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "folder.badge.plus")
                Text("Add Category")
            }
            .padding(.horizontal)
        }
    }
}
