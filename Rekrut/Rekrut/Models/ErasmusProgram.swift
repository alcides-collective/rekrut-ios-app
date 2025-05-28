//
//  ErasmusProgram.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

struct ErasmusProgram: Codable, Identifiable {
    let id: String
    var universityId: String
    var partnerUniversity: String
    var country: String
    var city: String
    var field: String
    var availableForDegrees: [Degree]
    var duration: String // e.g., "1 semester", "2 semesters"
    var language: String
    var requirements: ErasmusRequirements
    var deadline: Date
    var availableSlots: Int
    var monthlyGrant: Int // in EUR
    var description: String?
    var benefits: [String]
}

struct ErasmusRequirements: Codable {
    var minimumYear: Int // minimum year of study
    var minimumGPA: Double?
    var languageRequirement: String?
    var languageCertificate: String?
    var additionalDocuments: [String]
}