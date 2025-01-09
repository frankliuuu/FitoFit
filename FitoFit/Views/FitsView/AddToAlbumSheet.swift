//
//  AddToAlbumSheet.swift
//  FitoFit
//


import SwiftUI

struct AddToAlbumSheet: View {
    @EnvironmentObject var fitsViewModel: FitsViewModel
    let outfit: Outfit
    let currentAlbum: Album 
    var onComplete: () -> Void

    @State private var selectedAlbums: Set<UUID> = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Add Outfit To Albums")
                    .font(.headline)
                    .padding()

                List(fitsViewModel.albums.filter { $0.id != currentAlbum.id }) { album in
                    HStack {
                        Text(album.name)
                        Spacer()
                        if selectedAlbums.contains(album.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedAlbums.contains(album.id) {
                            selectedAlbums.remove(album.id)
                        } else {
                            selectedAlbums.insert(album.id)
                        }
                    }
                }

                Button(action: addOutfitToAlbums) {
                    Text("Add To Selected")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Add To Albums")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func addOutfitToAlbums() {
        for albumID in selectedAlbums {
            if let album = fitsViewModel.albums.first(where: { $0.id == albumID }) {
                fitsViewModel.addOutfit(outfit, to: album)
            }
        }
        onComplete()
    }
}
