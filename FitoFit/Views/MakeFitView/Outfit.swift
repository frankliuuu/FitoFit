//
//  Outfit.swift
//  FitoFit
//


import SwiftUI

struct Outfit: Identifiable, Equatable {
    let id: UUID
    var hat: ClothingItem?
    var top: ClothingItem?
    var bottom: ClothingItem?
    var shoes: ClothingItem?

    static func == (lhs: Outfit, rhs: Outfit) -> Bool {
        return lhs.id == rhs.id
    }
}



