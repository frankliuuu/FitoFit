//
//  Fits.swift
//  FitoFit
//
//  Created by Frank Liu on 10/30/24.
//

import SwiftUI

struct FitsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                // Header Section: Profile Icon, "Your FITS", and Add Button
                HStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray) // Placeholder for profile image
                    Text("Your Fits")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        print("Add Fit Tapped")
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                // Sort Button and Display
                HStack {
                    Button(action: {
                        print("Sort Button Tapped")
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text("Sort")
                                .fontWeight(.medium)
                        }
                    }
                    Spacer()
                    Button(action : {
                        print("Change Display")
                    }) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)

                // Scrollable List of Categories and Fits
                ScrollView {
                    VStack(spacing: 20) {
                        // Example sections for categories
                        FitCategory(title: "Favorites")
                        FitCategory(title: "Saved")
                        FitCategory(title: "Fall")
                        FitCategory(title: "Work")
                        FitCategory(title: "Going Out")
                    }
                    .padding(.horizontal)
                }

            }
        }
    }
}

// Custom View for Each Fit Category Section
struct FitCategory: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 100, height: 100)
                    }
                }
            }
        }
    }
}


#Preview {
    FitsView()
}
