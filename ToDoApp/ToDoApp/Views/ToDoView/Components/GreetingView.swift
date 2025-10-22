//
//  GreetingView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI

struct GreetingView: View {
    var userName: String
    
    var body: some View {
        HStack {
            Text("Hey \(userName)! 👋")
                .font(.system(size: 30, weight: .medium))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
