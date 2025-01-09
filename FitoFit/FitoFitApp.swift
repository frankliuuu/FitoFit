//
//  FitoFitApp.swift
//  FitoFit
//

import SwiftUI

@main
struct FitoFitApp: App {
    @StateObject private var profileViewModel = ProfileViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(profileViewModel)
        }
    }
}
