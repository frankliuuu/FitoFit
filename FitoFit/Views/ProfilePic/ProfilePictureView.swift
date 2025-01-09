//
//  ProfilePictureView.swift
//  FitoFit
//

import SwiftUI
import PhotosUI

struct ProfilePictureView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var showingImagePicker = false

    var body: some View {
        ZStack {
            if let profileImage = profileViewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            showingImagePicker = true
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { profileViewModel.profileImage },
                set: { newImage in
                    profileViewModel.profileImage = newImage
                }
            ))
        }
    }
}

