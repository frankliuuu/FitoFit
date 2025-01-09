//
//  ToastView.swift
//  FitoFit
//

import SwiftUI

struct ToastOverlayView: View {
    @EnvironmentObject var toastManager: ToastManager

    var body: some View {
        ZStack {
            if let message = toastManager.message {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.opacity)
                        .padding(.bottom, 50)
                }
                .animation(.easeInOut, value: toastManager.message)
            }
        }
        .allowsHitTesting(false)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
