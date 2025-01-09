//
//  ClosetSelectionSheet.swift
//  FitoFit
//


import SwiftUI

struct ClosetFilterSelectionSheet: View {
    @EnvironmentObject var viewModel: ClosetViewModel
    @State private var selectedType: String = "TYPE"
    @State private var selectedColor: String = "COLOR"
    @State private var favoritesOnly: Bool = false

    let category: Category
    let items: [ClothingItem]
    let locked: Bool
    let onLockToggle: () -> Void
    let onSelect: (ClothingItem?) -> Void

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 10) {
                    Button(action: {
                        onLockToggle()
                    }) {
                        HStack {
                            Image(systemName: locked ? "lock.fill" : "lock.open")
                                .foregroundColor(.gray)
                            Image(systemName: favoritesOnly ? "heart.fill" : "heart")
                                .foregroundColor(favoritesOnly ? .red : .black)
                                .onTapGesture {
                                    favoritesOnly.toggle()
                                }
                        }
                    }
                        
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

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        Button(action: {
                            onSelect(nil)
                        }) {
                            VStack {
                                Image(systemName: "xmark.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.red)
                                Text("Remove")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()

                        ForEach(filteredItems, id: \.id) { item in
                            ClothingItemView(image: item.image)
                                .onTapGesture {
                                    onSelect(item)
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select a \(category.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var filteredItems: [ClothingItem] {
        items.filter { item in
            (!favoritesOnly || item.isFavorited) &&
            (selectedType == "TYPE" || item.type == selectedType) &&
            (selectedColor == "COLOR" || item.color.name == selectedColor)
        }
    }
}

