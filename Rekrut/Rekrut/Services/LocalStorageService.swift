//
//  LocalStorageService.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation
import Combine

class LocalStorageService: ObservableObject {
    static let shared = LocalStorageService()
    private let userDefaults = UserDefaults.standard
    private let maturaScoresKey = "savedMaturaScores"
    
    // Published property to notify views of changes
    @Published var maturaScores: MaturaScores?
    
    private init() {
        // Load initial scores
        self.maturaScores = loadMaturaScoresInternal()
    }
    
    // MARK: - Matura Scores
    
    func saveMaturaScores(_ scores: MaturaScores) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scores)
            userDefaults.set(data, forKey: maturaScoresKey)
            print("DEBUG: Saved Matura scores to local storage")
            
            // Update published property to trigger UI updates
            self.maturaScores = scores
        } catch {
            print("ERROR: Failed to save Matura scores locally: \(error)")
        }
    }
    
    func loadMaturaScores() -> MaturaScores? {
        return maturaScores
    }
    
    private func loadMaturaScoresInternal() -> MaturaScores? {
        guard let data = userDefaults.data(forKey: maturaScoresKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let scores = try decoder.decode(MaturaScores.self, from: data)
            print("DEBUG: Loaded Matura scores from local storage")
            return scores
        } catch {
            print("ERROR: Failed to load Matura scores from local storage: \(error)")
            return nil
        }
    }
    
    func clearMaturaScores() {
        userDefaults.removeObject(forKey: maturaScoresKey)
        self.maturaScores = nil
        print("DEBUG: Cleared Matura scores from local storage")
    }
    
    // MARK: - Sync with Firebase
    
    /// Sync local scores with Firebase when user logs in
    func syncMaturaScoresWithFirebase() async {
        guard let localScores = loadMaturaScores(),
              let user = FirebaseService.shared.currentUser else { return }
        
        // If user doesn't have scores in Firebase but has local scores, upload them
        if user.maturaScores == nil {
            var updatedUser = user
            updatedUser.maturaScores = localScores
            
            do {
                try await FirebaseService.shared.updateUser(updatedUser)
                print("DEBUG: Synced local Matura scores to Firebase")
            } catch {
                print("ERROR: Failed to sync Matura scores to Firebase: \(error)")
            }
        }
    }
}