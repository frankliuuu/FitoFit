//
//  SaveOutfitSheet.swift
//  FitoFit
//

import SwiftUI

struct SaveOutfitSheet: View {
    let outfit: Outfit
    @State private var albumName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Save Outfit")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                TextField("Album Name (optional)", text: $albumName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: saveOutfit) {
                    Text("Save")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }

    private func saveOutfit() {
        print("Outfit saved to album: \(albumName.isEmpty ? "Saved" : albumName)")
    }
}
