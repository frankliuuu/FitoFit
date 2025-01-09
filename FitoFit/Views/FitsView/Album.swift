//
//  Album.swift
//  FitoFit
//

import SwiftUI

struct Album: Identifiable {
    let id: UUID = UUID()
    var name: String
    var outfits: [Outfit] = []
}
