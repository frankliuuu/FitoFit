//
//  MakeFitView.swift
//  FitoFit
//

import SwiftUI

struct MakeFitView: View {
    @EnvironmentObject var closetViewModel: ClosetViewModel
    @EnvironmentObject var fitsViewModel: FitsViewModel

    @State private var selectedHat: ClothingItem?
    @State private var selectedTop: ClothingItem?
    @State private var selectedBottom: ClothingItem?
    @State private var selectedShoes: ClothingItem?

    @State private var lockedCategories: Set<Category> = []
    @State private var selectedCategoryForEditing: Category?
    @State private var showSelectionSheet = false
    @State private var showEmptyClosetMessage = false

    var body: some View {
        NavigationView {
            ZStack {
                if showEmptyClosetMessage {
                    VStack {
                        Text("Your Closet Is Empty!")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        
                        Text("Add at least one top and one bottom to your closet to start making outfits.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.gray)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("Make Fit")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)

                        HStack {
                            // Outfit Display
                            VStack(spacing: 20) {
                                Spacer()

                                // Hat Section
                                OutfitItemView(
                                    label: "Select Hat",
                                    clothingItem: selectedHat,
                                    category: .hat,
                                    onSelect: { selectedCategoryForEditing = .hat; showSelectionSheet = true }
                                )

                                // Top Section
                                OutfitItemView(
                                    label: "Select Top",
                                    clothingItem: selectedTop,
                                    category: .top,
                                    onSelect: { selectedCategoryForEditing = .top; showSelectionSheet = true }
                                )

                                // Bottom Section
                                OutfitItemView(
                                    label: "Select Bottom",
                                    clothingItem: selectedBottom,
                                    category: .bottom,
                                    onSelect: { selectedCategoryForEditing = .bottom; showSelectionSheet = true }
                                )

                                // Shoes Section
                                OutfitItemView(
                                    label: "Select Shoes",
                                    clothingItem: selectedShoes,
                                    category: .shoe,
                                    onSelect: { selectedCategoryForEditing = .shoe; showSelectionSheet = true }
                                )

                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

            
                            VStack(spacing: 30) {
                                Spacer()

                                Button(action: shuffleOutfit) {
                                    VStack {
                                        Image(systemName: "arrow.2.circlepath")
                                            .font(.largeTitle)
                                        Text("Shuffle")
                                            .font(.caption)
                                    }
                                }
                                .buttonStyle(.borderless)

                                Button(action: saveOutfit) {
                                    VStack {
                                        Image(systemName: "bookmark")
                                            .font(.largeTitle)
                                        Text("Save")
                                            .font(.caption)
                                    }
                                }
                                .buttonStyle(.borderless)

                                Spacer()
                            }
                            .frame(maxHeight: .infinity)
                            .padding(.trailing, 16)
                        }
                    }
                }
            }
            .onAppear(perform: setupOutfit)
            .sheet(isPresented: $showSelectionSheet) {
                if let category = selectedCategoryForEditing {
                    ClosetFilterSelectionSheet(
                        category: category,
                        items: closetViewModel.uploadedItems.filter { $0.category == category },
                        locked: lockedCategories.contains(category),
                        onLockToggle: { toggleLock(for: category) },
                        onSelect: { selectedItem in
                            assignSelectedItem(selectedItem, to: category)
                            showSelectionSheet = false
                        }
                    )
                }
            }
        }
    }


    private func setupOutfit() {
        guard hasRequiredItems() else {
            showEmptyClosetMessage = true
            return
        }
        showEmptyClosetMessage = false
        shuffleOutfit()
    }

    private func hasRequiredItems() -> Bool {
        let tops = closetViewModel.uploadedItems.filter { $0.category == .top }
        let bottoms = closetViewModel.uploadedItems.filter { $0.category == .bottom }
        return !tops.isEmpty && !bottoms.isEmpty
    }

    private func shuffleOutfit() {
        if !lockedCategories.contains(.hat) {
            selectedHat = closetViewModel.uploadedItems.filter { $0.category == .hat }.randomElement()
        }
        if !lockedCategories.contains(.top) {
            selectedTop = closetViewModel.uploadedItems.filter { $0.category == .top }.randomElement()
        }
        if !lockedCategories.contains(.bottom) {
            selectedBottom = closetViewModel.uploadedItems.filter { $0.category == .bottom }.randomElement()
        }
        if !lockedCategories.contains(.shoe) {
            selectedShoes = closetViewModel.uploadedItems.filter { $0.category == .shoe }.randomElement()
        }
    }

    private func assignSelectedItem(_ item: ClothingItem?, to category: Category) {
        switch category {
        case .hat:
            selectedHat = item
        case .top:
            selectedTop = item
        case .bottom:
            selectedBottom = item
        case .shoe:
            selectedShoes = item
        }
    }

    private func toggleLock(for category: Category) {
        if lockedCategories.contains(category) {
            lockedCategories.remove(category)
        } else {
            lockedCategories.insert(category)
        }
    }

    private func saveOutfit() {
        guard selectedTop != nil || selectedBottom != nil || selectedHat != nil || selectedShoes != nil else {
            print("Cannot save an outfit with no items")
            return
        }

        let newOutfit = Outfit(
            id: UUID(),
            hat: selectedHat,
            top: selectedTop,
            bottom: selectedBottom,
            shoes: selectedShoes
        )

        fitsViewModel.saveOutfit(newOutfit)
        print("Outfit saved: \(newOutfit)")
    }

}

struct OutfitItemView: View {
    let label: String
    let clothingItem: ClothingItem?
    let category: Category
    let onSelect: () -> Void

    var body: some View {
        ZStack {
            if let clothingItem = clothingItem {
                ClothingItemView(image: clothingItem.image)
                    .onTapGesture {
                        onSelect()
                    }
            } else {
                VStack {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    onSelect()
                }
            }
        }
        .frame(height: category == .top || category == .bottom ? 150 : 100)
    }
}

#Preview {
    MakeFitView()
        .environmentObject(ClosetViewModel())
        .environmentObject(FitsViewModel())
}
