//
//  MoveToAlbumSheet.swift
//  FitoFit
//


import SwiftUI

struct MoveToAlbumSheet: View {
    @EnvironmentObject var fitsViewModel: FitsViewModel
    let outfit: Outfit
    let currentAlbum: Album

    @Environment(\.dismiss) private var dismiss
    @State private var selectedAlbum: Album?

    var body: some View {
        NavigationView {
            VStack {
                Text("Move Outfit To Album")
                    .font(.headline)
                    .padding()

                List(fitsViewModel.albums) { album in
                    if album.id != currentAlbum.id {
                        HStack {
                            Text(album.name)
                            Spacer()
                            if selectedAlbum?.id == album.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedAlbum = album
                        }
                    }
                }

                Button(action: moveOutfit) {
                    Text("Move To Selected")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectedAlbum == nil)
            }
            .navigationTitle("Move To Album")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func moveOutfit() {
        guard let selectedAlbum = selectedAlbum else { return }
        fitsViewModel.removeOutfit(outfit, from: currentAlbum)
        fitsViewModel.addOutfit(outfit, to: selectedAlbum)
        dismiss()
    }
}
