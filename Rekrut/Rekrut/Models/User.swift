//
//  User.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var email: String
    var displayName: String?
    var profilePhotoURL: String?
    var preferences: UserPreferences
    var maturaScores: MaturaScores?
    var savedPrograms: [String] // Program IDs
    var savedComparisons: [String] // Comparison IDs
    var createdAt: Date
    var updatedAt: Date
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
        self.preferences = UserPreferences()
        self.savedPrograms = []
        self.savedComparisons = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct UserPreferences: Codable {
    var preferredFields: [String] = []
    var preferredCities: [String] = []
    var studyMode: StudyMode = .stationary
    var languageOfInstruction: [String] = ["Polski"]
    var notificationsEnabled: Bool = true
}

enum StudyMode: String, Codable, CaseIterable {
    case stationary = "Stacjonarne"
    case nonStationary = "Niestacjonarne"
    case both = "Oba"
}