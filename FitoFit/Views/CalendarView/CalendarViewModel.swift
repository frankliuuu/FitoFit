//
//  CalendarViewModel.swift
//  FitoFit
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var plannedOutfits: [Date: [Outfit]] = [:]

    func addOutfit(_ outfit: Outfit, to date: Date) {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        if plannedOutfits[normalizedDate] == nil {
            plannedOutfits[normalizedDate] = []
        }
        plannedOutfits[normalizedDate]?.append(outfit)
    }
    
    func removeOutfit(_ outfit: Outfit, from date: Date) {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        if var outfits = plannedOutfits[normalizedDate] {
            outfits.removeAll { $0.id == outfit.id }
            plannedOutfits[normalizedDate] = outfits.isEmpty ? nil : outfits
        }
    }


    func outfits(for date: Date) -> [Outfit] {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        return plannedOutfits[normalizedDate] ?? []
    }
}
