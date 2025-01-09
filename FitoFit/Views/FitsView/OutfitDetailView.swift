//
//  OutfitDetailView.swift
//  FitoFit
//

import SwiftUI

struct OutfitDetailView: View {
    @EnvironmentObject var fitsViewModel: FitsViewModel
    @EnvironmentObject var toastManager: ToastManager
    @Binding var outfit: Outfit
    var currentAlbum: Album
    @Environment(\.dismiss) private var dismiss

    @State private var showingDeleteConfirmation = false
    @State private var showingAddToSheet = false
    @State private var showingWearOnSheet = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("View Outfit")
                    .font(.title)
                    .bold()
                    .padding(.top)

                HStack {
                    // Outfit Display
                    VStack(spacing: 20) {
                        Spacer()

                        if let hat = outfit.hat {
                            ClothingItemView(image: hat.image)
                                .frame(height: 100)
                        }

                        if let top = outfit.top {
                            ClothingItemView(image: top.image)
                                .frame(height: 150)
                        }

                        if let bottom = outfit.bottom {
                            ClothingItemView(image: bottom.image)
                                .frame(height: 150)
                        }

                        if let shoes = outfit.shoes {
                            ClothingItemView(image: shoes.image)
                                .frame(height: 100)
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    // Action Buttons
                    VStack(spacing: 30) {
                        Spacer()

                        Button(action: { showingAddToSheet = true }) {
                            VStack {
                                Image(systemName: "folder.badge.plus")
                                    .font(.largeTitle)
                                Text("Add To")
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(.borderless)

                        Button(action: { showingWearOnSheet = true }) {
                            VStack {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.largeTitle)
                                Text("Wear On")
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(.borderless)

                        Menu {
                            ForEach(fitsViewModel.albums, id: \.id) { album in
                                if album.id != currentAlbum.id {
                                    Button(album.name) {
                                        moveOutfit(to: album)
                                    }
                                }
                            }
                        } label: {
                            VStack {
                                Image(systemName: "folder")
                                    .font(.largeTitle)
                                Text("Move")
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(.borderless)

                        Button(action: { showingDeleteConfirmation = true }) {
                            VStack {
                                Image(systemName: "trash")
                                    .font(.largeTitle)
                                    .foregroundColor(.red)
                                Text("Delete")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .buttonStyle(.borderless)

                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.trailing, 16)
                }
            }
            .sheet(isPresented: $showingAddToSheet) {
                AddToAlbumSheet(outfit: outfit, currentAlbum: currentAlbum, onComplete: {
                    toastManager.showToast(message: "Outfit Added to Albums")
                    dismissToFitsView()
                })
            }
            .sheet(isPresented: $showingWearOnSheet) {
                WearOnCalendarView(outfit: outfit) {
                    toastManager.showToast(message: "Outfit Assigned to Dates")
                }
            }
            .alert("Delete Outfit", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteOutfit()
                }
            } message: {
                Text("Are you sure you want to delete this outfit?")
            }
        }
    }

    private func moveOutfit(to album: Album) {
        fitsViewModel.removeOutfit(outfit, from: currentAlbum)
        fitsViewModel.addOutfit(outfit, to: album)
        toastManager.showToast(message: "Outfit Moved")
        dismiss()
    }

    private func deleteOutfit() {
        fitsViewModel.removeOutfit(outfit, from: currentAlbum)
        toastManager.showToast(message: "Outfit Deleted")
        dismiss()
    }

    private func dismissToFitsView() {
        dismiss()
        dismiss()
    }
}
