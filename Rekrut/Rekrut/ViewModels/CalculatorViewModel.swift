//
//  CalculatorViewModel.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation
import SwiftUI

@MainActor
class CalculatorViewModel: ObservableObject {
    @Published var maturaScores = MaturaScores()
    
    private let firebaseService = FirebaseService.shared
    
    func loadSavedScores() {
        if let savedScores = firebaseService.currentUser?.maturaScores {
            maturaScores = savedScores
        }
    }
}