//
//  AIRecView.swift
//  FitoFit
//

import SwiftUI

import SwiftUI

struct AIRecView: View {
    @State private var currentOutfitIndex: Int = 0
    @EnvironmentObject var profileViewModel: ProfileViewModel

    // Dummy data: List of outfits
    let outfits = ["Outfit 1", "Outfit 2", "Outfit 3", "Outfit 4"]

    var body: some View {
        VStack {
            HStack {
                ProfilePictureView()
                    .environmentObject(profileViewModel)
                Text("Your Recs")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            Text("Type Here")
                .font(.headline)
                .padding(.vertical, 10)

            // Swipeable Outfit Card
            ZStack {
                ForEach(Array(outfits.enumerated()), id: \.offset) { index, outfit in
                    if index == currentOutfitIndex {
                        OutfitCard(outfit: outfit)
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        handleSwipe(translation: value.translation)
                                    }
                            )
                    }
                }
            }
            .frame(height: 400)
            .padding()

            Spacer()

        }
    }

    // right to like, left to dislike
    private func handleSwipe(translation: CGSize) {
        if translation.width < -100 {
            print("Swiped Left (No)")
            moveToNextOutfit()
        } else if translation.width > 100 {
            print("Swiped Right (Yes)")
            moveToNextOutfit()
        }
    }

    // Move to the next outfit in the list
    private func moveToNextOutfit() {
        if currentOutfitIndex < outfits.count - 1 {
            currentOutfitIndex += 1
        } else {
            currentOutfitIndex = 0
        }
    }
}

struct OutfitCard: View {
    let outfit: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.blue.opacity(0.2))
            .overlay(
                Text(outfit)
                    .font(.title)
                    .fontWeight(.bold)
            )
            .frame(width: 300, height: 400)
            .shadow(radius: 5)
    }
}



#Preview {
    AIRecView()
        .environmentObject(ProfileViewModel())
}
