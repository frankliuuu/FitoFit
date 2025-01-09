//
//  ClothingItem.swift
//  FitoFit
//


import SwiftUI

struct ClothingItem: Identifiable, Hashable {
    let id: UUID = UUID() // Unique identifier
    var image: UIImage
    var category: Category
    var type: String
    var color: NamedColor
    var isFavorited: Bool
}

enum Category: String, CaseIterable {
    case top = "Top"
    case bottom = "Bottom"
    case hat = "Hat"
    case shoe = "Shoe"
}

struct Types {
    static let tops = ["T-Shirt", "Sweater", "Button Down", "Sweatshirt", "Jacket"]
    static let bottoms = ["Jeans", "Shorts", "Dress Pants"]
    static let hats = ["Cap", "Beanie"]
    static let shoes = ["Sneakers", "Boots", "Loafers"]

    static func forCategory(_ category: Category) -> [String] {
        switch category {
        case .top: return tops
        case .bottom: return bottoms
        case .hat: return hats
        case .shoe: return shoes
        }
    }
}

struct NamedColor: Hashable {
    let color: Color
    let name: String

    static let all: [NamedColor] = [
        NamedColor(color: .white, name: "White"),
        NamedColor(color: .black, name: "Black"),
        NamedColor(color: .gray, name: "Gray"),
        NamedColor(color: .red, name: "Red"),
        NamedColor(color: .orange, name: "Orange"),
        NamedColor(color: .yellow, name: "Yellow"),
        NamedColor(color: .green, name: "Green"),
        NamedColor(color: .blue, name: "Blue")
    ]
}



