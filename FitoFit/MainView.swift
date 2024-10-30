//
//  MainView.swift
//  FitoFit
//
//  Created by Frank Liu on 10/30/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ClosetView()
                .tabItem {
                    Label("Closet", systemImage: "hanger")
                }

            FitsView()
                .tabItem {
                    Label("Fits", systemImage: "tshirt")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            AIRecView()
                .tabItem {
                    Label("AI Rec", systemImage: "brain")
                }
        }
    }
}


#Preview {
    MainView()
}


