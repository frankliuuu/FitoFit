//
//  ProfileViewModel.swift
//  FitoFit
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profileImage: UIImage? {
        didSet {
            if let profileImage = profileImage {
                saveProfileImage(profileImage)
            }
        }
    }

    init() {
        self.profileImage = loadProfileImage()
    }

    private func saveProfileImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "profileImage")
        }
    }

    private func loadProfileImage() -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: "profileImage") {
            return UIImage(data: data)
        }
        return nil
    }
}

