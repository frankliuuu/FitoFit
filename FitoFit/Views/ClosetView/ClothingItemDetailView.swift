//
//  ClothingItemDetailView.swift
//  FitoFit
//

import SwiftUI

struct ClothingItemDetailView: View {
    @Binding var clothingItem: ClothingItem
    let onRemove: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Image(uiImage: clothingItem.image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding()

            Form {
                Picker("Category", selection: $clothingItem.category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .onChange(of: clothingItem.category) { _, newValue in
                    clothingItem.type = Types.forCategory(newValue).first ?? ""
                }

                Picker("Type", selection: $clothingItem.type) {
                    ForEach(Types.forCategory(clothingItem.category), id: \.self) { type in
                        Text(type).tag(type)
                    }
                }

                Picker("Color", selection: $clothingItem.color) {
                    ForEach(NamedColor.all, id: \.self) { color in
                        Text(color.name).tag(color)
                    }
                }

                Toggle("Favorite", isOn: $clothingItem.isFavorited)

                Button(action: {
                               onRemove()
                               dismiss()
                           }) {
                               HStack {
                                   Image(systemName: "trash")
                                       .font(.body)
                                   Text("Remove Item")
                                       .font(.headline)
                               }
                               .foregroundColor(.red)
                               .padding()
                               .frame(maxWidth: .infinity)
                               .background(Color(UIColor.systemGray6))
                               .cornerRadius(10)
                               .padding(.horizontal)
                           }
            }
            .navigationTitle("Edit Clothing Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}




