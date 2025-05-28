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
    @Published var selectedPrograms: [StudyProgram] = []
    @Published var calculationResults: [CalculationResult] = []
    @Published var isCalculating = false
    
    private let firebaseService = FirebaseService.shared
    
    struct CalculationResult: Identifiable {
        let id = UUID()
        let program: StudyProgram
        let points: Double
        let formula: String
        let breakdown: [ScoreComponent]
    }
    
    struct ScoreComponent {
        let subject: String
        let weight: Double
        let score: Double
        let points: Double
    }
    
    func addScore(subject: MaturaSubject, level: MaturaLevel, percentage: Double) {
        let score = MaturaSubjectScore(
            subject: subject,
            level: level,
            scorePercentage: percentage
        )
        
        if let index = maturaScores.subjects.firstIndex(where: { $0.id == score.id }) {
            maturaScores.subjects[index] = score
        } else {
            maturaScores.subjects.append(score)
        }
    }
    
    func removeScore(subject: MaturaSubject, level: MaturaLevel) {
        maturaScores.subjects.removeAll { $0.subject == subject && $0.level == level }
    }
    
    func calculatePoints() async {
        isCalculating = true
        calculationResults = []
        
        for program in selectedPrograms {
            let result = calculateForProgram(program)
            calculationResults.append(result)
        }
        
        // Save calculation to user profile if logged in
        if firebaseService.currentUser != nil {
            await saveCalculationToProfile()
        }
        
        isCalculating = false
    }
    
    private func calculateForProgram(_ program: StudyProgram) -> CalculationResult {
        var totalPoints = 0.0
        var components: [ScoreComponent] = []
        
        // This is a simplified calculation - real formulas would be more complex
        // Calculate based on all available matura scores with field-specific weights
        for subjectScore in maturaScores.subjects {
            let weight = getWeight(for: subjectScore.subject, in: program)
            let points = subjectScore.scorePercentage * weight
            
            if weight > 0 {
                components.append(ScoreComponent(
                    subject: subjectScore.subject.rawValue,
                    weight: weight,
                    score: subjectScore.scorePercentage,
                    points: points
                ))
                
                totalPoints += points
            }
        }
        
        return CalculationResult(
            program: program,
            points: totalPoints,
            formula: program.requirements.formula,
            breakdown: components
        )
    }
    
    private func getWeight(for subject: MaturaSubject, in program: StudyProgram) -> Double {
        // This would be determined by the actual recruitment formula
        // For now, using simplified weights
        switch subject {
        case .mathematics:
            return program.field.contains("Informatyka") ? 2.0 : 1.0
        case .physics:
            return program.field.contains("Fizyka") ? 2.0 : 1.0
        case .biology:
            return program.field.contains("Medycyna") ? 2.0 : 1.0
        default:
            return 1.0
        }
    }
    
    private func saveCalculationToProfile() async {
        guard var user = firebaseService.currentUser else { return }
        user.maturaScores = maturaScores
        
        do {
            try await firebaseService.updateUser(user)
        } catch {
            print("Error saving calculation: \(error)")
        }
    }
    
    func loadSavedScores() {
        if let savedScores = firebaseService.currentUser?.maturaScores {
            maturaScores = savedScores
        }
    }
}