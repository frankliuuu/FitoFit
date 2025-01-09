//
//  AlbumDetailView.swift
//  FitoFit
//



import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var fitsViewModel: FitsViewModel
    @EnvironmentObject var toastManager: ToastManager
    let album: Album

    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirmation = false

    var body: some View {
        VStack {
            if album.outfits.isEmpty {
                Text("No outfits in this album.")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(album.outfits) { outfit in
                            NavigationLink(
                                destination: OutfitDetailView(outfit: .constant(outfit), currentAlbum: album)
                                    .environmentObject(fitsViewModel)
                                    .environmentObject(toastManager)
                            ) {
                                OutfitThumbnailView(outfit: outfit)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(album.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if album.name != "Favorites" && album.name != "Saved" {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("Delete Album", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAlbum()
            }
        } message: {
            Text("Are you sure you want to delete the album '\(album.name)'? This will also delete all outfits inside the album.")
        }
    }

    private func deleteAlbum() {
        fitsViewModel.deleteAlbum(album)
        toastManager.showToast(message: "Album Deleted")
        dismiss()
    }
}

