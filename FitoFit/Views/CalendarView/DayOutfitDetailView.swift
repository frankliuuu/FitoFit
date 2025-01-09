//
//  DayOutfitDetailView.swift
//  FitoFit
//

import SwiftUI

struct DayOutfitDetailView: View {
    let outfit: Outfit
    let selectedDate: Date
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirmation = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Planned Outfit")
                .font(.title)
                .bold()
                .padding(.top)

            VStack(spacing: 20) {
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
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Spacer()

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
            .padding(.bottom, 20)

        }
        .alert("Delete Outfit", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteOutfit()
            }
        } message: {
            Text("Are you sure you want to delete this outfit from \(formatDate(selectedDate))?")
        }
    }

    private func deleteOutfit() {
        calendarViewModel.removeOutfit(outfit, from: selectedDate)
        dismiss()
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
