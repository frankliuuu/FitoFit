//
//  ToastManager.swift
//  FitoFit
//


import SwiftUI

class ToastManager: ObservableObject {
    @Published var message: String?

    func showToast(message: String) {
        self.message = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.message = nil
        }
    }
}

