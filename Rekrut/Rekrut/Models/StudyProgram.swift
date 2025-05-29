//
//  StudyProgram.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

struct StudyProgram: Codable, Identifiable {
    let id: String
    var universityId: String
    var name: String
    var faculty: String? // Wydział (e.g., "Wydział Matematyki i Informatyki")
    var field: String
    var degree: Degree
    var mode: StudyMode
    var duration: Int // in semesters
    var language: String
    var description: String?
    var requirements: AdmissionRequirements
    var tuitionFee: Int? // per semester in PLN
    var availableSlots: Int?
    var lastYearThreshold: Double? // minimum points from last year
    var tags: [String]
    var imageURL: String? // Program or university image
    var thumbnailURL: String? // Smaller version for cards
    var applicationURL: String? // Direct link to apply for this program
    
    var durationSemesters: Int {
        duration
    }
}

enum Degree: String, Codable, CaseIterable {
    case bachelor = "Licencjat"
    case engineer = "Inżynier"
    case master = "Magister"
    case unified = "Jednolite magisterskie"
}

struct AdmissionRequirements: Codable {
    var description: String? // Polish description of admission criteria
    var formula: String // calculation formula description
    var minimumPoints: Double?
    var additionalExams: [String]
    var documents: [String]
    var deadlineDate: Date?
    var admissionType: AdmissionType
    var entranceExamDetails: EntranceExamDetails?
}

enum AdmissionType: String, Codable {
    case maturaPoints = "Punkty maturalne" // Standard matura points
    case entranceExam = "Egzamin wstępny" // Entrance exam required
    case portfolio = "Portfolio" // Portfolio submission
    case mixed = "Matura + egzamin" // Both matura and exam
    case interview = "Rozmowa kwalifikacyjna" // Interview based
    case unknown = "Brak danych" // No data available
}

struct EntranceExamDetails: Codable {
    var examType: String // e.g., "Egzamin praktyczny", "Test wiedzy", "Przesłuchanie"
    var stages: [String] // e.g., ["Etap I: Portfolio", "Etap II: Egzamin praktyczny", "Etap III: Rozmowa"]
    var description: String // Detailed description of the exam
    var sampleTasksURL: String? // Link to sample exam tasks
    var preparationTips: String? // Tips for preparation
}