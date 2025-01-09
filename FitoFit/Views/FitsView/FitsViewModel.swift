//
//  FitsViewModel.swift
//  FitoFit
//

import SwiftUI

class FitsViewModel: ObservableObject {
    @Published var albums: [Album] = [
        Album(name: "Favorites"),
        Album(name: "Saved")
    ]

    func saveOutfit(_ outfit: Outfit) {
        if let savedAlbum = albums.first(where: { $0.name == "Saved" }) {
            addOutfit(outfit, to: savedAlbum)
        }
    }

    func addOutfit(_ outfit: Outfit, to album: Album) {
        if let index = albums.firstIndex(where: { $0.id == album.id }) {
            // Create a unique copy of the outfit to ensure independence
            let newOutfit = Outfit(
                id: UUID(),
                hat: outfit.hat,
                top: outfit.top,
                bottom: outfit.bottom,
                shoes: outfit.shoes
            )
            albums[index].outfits.append(newOutfit)
        }
    }

    func removeOutfit(_ outfit: Outfit, from album: Album) {
        if let index = albums.firstIndex(where: { $0.id == album.id }) {
            albums[index].outfits.removeAll(where: { $0.id == outfit.id })
        }
    }
    func addAlbum(name: String) {
        albums.append(Album(name: name))
        
    }
    
    func deleteAlbum(_ album: Album) {
        albums.removeAll(where: { $0.id == album.id })
    }

}
