//
//  ClothingItemPlaceholder.swift
//  FitoFit
//
import SwiftUI

struct ClothingItemPlaceholder: View {
    let item: ClothingItem?
    let category: Category
    @Binding var locked: Bool
    let onEdit: () -> Void

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(locked ? Color.red : Color.gray, lineWidth: 2)
                    .frame(width: 100, height: 100)

                if let item = item {
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                } else {
                    Text(category.rawValue.capitalized)
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture {
                if !locked {
                    onEdit()
                }
            }

            HStack {
                Button(action: { locked.toggle() }) {
                    Image(systemName: locked ? "lock.fill" : "lock.open")
                }

                Button(action: onEdit) {
                    Image(systemName: "square.and.pencil")
                }
            }
            .padding(.top, 5)
        }
    }
}
