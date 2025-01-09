//
//  MainView.swift
//  FitoFit
//

import SwiftUI

struct MainView: View {
    @StateObject private var closetViewModel = ClosetViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var fitsViewModel = FitsViewModel()
    @StateObject private var toastManager = ToastManager()
    @StateObject private var calendarViewModel = CalendarViewModel()


    var body: some View {
            ZStack {
                TabView {
                    ClosetView()
                        .environmentObject(closetViewModel)
                        .environmentObject(toastManager)
                        .tabItem {
                            Label("Closet", systemImage: "hanger")
                        }

                    FitsView()
                        .environmentObject(fitsViewModel)
                        .environmentObject(calendarViewModel)
                        .environmentObject(closetViewModel)
                        .environmentObject(toastManager)
                        .tabItem {
                            Label("Fits", systemImage: "tshirt")
                        }

                    MakeFitView()
                        .environmentObject(closetViewModel)
                        .environmentObject(fitsViewModel)
                        .environmentObject(toastManager)
                        .tabItem {
                            Label("Make Fit", systemImage: "plus")
                        }

                    CalendarView()
                        .environmentObject(fitsViewModel)
                        .environmentObject(calendarViewModel)
                        .environmentObject(toastManager)
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }

                    AIRecView()
                        .environmentObject(toastManager)
                        .tabItem {
                            Label("AI Rec", systemImage: "brain")
                        }
                }
                ToastOverlayView()
                    .environmentObject(toastManager)
            }
        }
    }
#Preview {
    MainView()
        .environmentObject(ClosetViewModel())
        .environmentObject(ProfileViewModel())
        .environmentObject(CalendarViewModel())
}


