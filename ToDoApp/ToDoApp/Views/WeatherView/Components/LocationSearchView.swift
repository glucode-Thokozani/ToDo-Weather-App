//
//  LocationSearchView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/10/06.
//
import SwiftUI

struct WeatherSearchView: View {
    @Binding var searchQuery: String
    @Binding var isPresented: Bool
    var onSearch: () async -> Void

    @State private var tempQuery: String = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10)
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 20) {
                Text("Search City")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                TextField("Enter city name", text: $tempQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .foregroundColor(.primary)
                    .onSubmit {
                        search()
                    }

                Button(action: {
                    search()
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(.ultraThinMaterial) 
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .onAppear {
            tempQuery = searchQuery
        }
    }

    private func search() {
        searchQuery = tempQuery
        Task {
            await onSearch()
            isPresented = false
        }
    }
}
