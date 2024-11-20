//
//  ClothingItem.swift
//  FitoFit
//
//  Created by Frank Liu on 11/6/24.
//


import SwiftUI

struct ClothingItem: Identifiable, Hashable {
    let id = UUID()
    var image: UIImage
    var category: Category
    var type: String
    var color: Color
    var isFavorited: Bool
}

enum Category: String, CaseIterable {
    case top = "Top"
    case bottom = "Bottom"
    case hat = "Hat"
    case shoe = "Shoe"
}

// Sample types based on category; more sophisticated implementation would tie these to the specific category
struct Types {
    static let tops = ["T-Shirt", "Sweater", "Button Down", "Sweatshirt"]
    static let bottoms = ["Jeans", "Shorts", "Dress Pants"]
    static let hats = ["Cap", "Beanie"]
    static let shoes = ["Sneakers", "Boots"]
}
