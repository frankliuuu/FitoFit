//
//  ClosetSelectionSheet.swift
//  FitoFit
//
//  Created by Frank Liu on 1/7/25.
//


import SwiftUI

struct ClosetFilterSelectionSheet: View {
    let category: Category
    let items: [ClothingItem]
    let onSelect: (ClothingItem) -> Void
    @Environment(\.dismiss) var dismiss

    @State private var selectedType: String = "TYPE"
    @State private var selectedColor: String = "COLOR"
    @State private var favoritesOnly: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Filter options
                HStack {
                    Toggle(isOn: $favoritesOnly) {
                        Image(systemName: favoritesOnly ? "heart.fill" : "heart")
                            .foregroundColor(favoritesOnly ? .red : .black)
                    }
                    .toggleStyle(.button)

                    Spacer()

                    DropdownFilterButton(
                        label: "TYPE",
                        options: ["TYPE"] + Types.forCategory(category),
                        selectedOption: $selectedType
                    )
                    DropdownFilterButton(
                        label: "COLOR",
                        options: ["COLOR"] + NamedColor.all.map { $0.name },
                        selectedOption: $selectedColor
                    )
                }
                .padding()

                // Filtered clothing items grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredItems, id: \.id) { item in
                            ClothingItemView(image: item.image)
                                .onTapGesture {
                                    onSelect(item)
                                    dismiss()
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select \(category.rawValue.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Computed property for filtered items
    private var filteredItems: [ClothingItem] {
        items.filter { item in
            (!favoritesOnly || item.isFavorited) &&
            (selectedType == "TYPE" || item.type == selectedType) &&
            (selectedColor == "COLOR" || item.color.name == selectedColor)
        }
    }
}
