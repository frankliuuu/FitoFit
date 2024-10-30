//
//  ContentView.swift
//  FitoFit
//
//  Created by Frank Liu on 10/29/24.
//

import SwiftUI

struct ClosetView: View {
    var body: some View {
        VStack {
            // Top Icons and Filters Section
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Image(systemName: "heart")
                    .frame(width: 50, height: 50)
                Spacer()
                FilterButton(label: "CATEGORY")
                FilterButton(label: "TYPE")
                FilterButton(label: "COLOR")
            }
            .padding()

            // Grid of Clothing Items
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(0..<6) { index in
                        ClothingItemView()
                    }
                    Button(action: {
                        print("Add Piece Tapped")
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
    }
}

// Reusable Components
struct FilterButton: View {
    let label: String
    var body: some View {
        Text(label)
            .padding(8)
            .background(Capsule().stroke())
    }
}

struct ClothingItemView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 100)
            .foregroundColor(.gray)
    }
}


struct FloatingAddButton: View {
    var body: some View {
        Button(action: {
            print("Floating Add Button Tapped")
        }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.red)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}

//


#Preview {
    ClosetView()
}
