//
//  ClosetViewModel.swift
//  FitoFit
//

import SwiftUI

class ClosetViewModel: ObservableObject {
    @Published var uploadedItems: [ClothingItem] = []
    
    func removeItem(at index: Int) {
            guard index >= 0 && index < uploadedItems.count else { return }
            uploadedItems.remove(at: index)
        }
}

