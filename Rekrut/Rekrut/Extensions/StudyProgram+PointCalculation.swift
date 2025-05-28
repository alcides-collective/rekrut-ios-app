//
//  StudyProgram+PointCalculation.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation
import SwiftUI

extension StudyProgram {
    /// Calculate user's admission points based on the program's formula and user's matura scores
    func calculateUserPoints(maturaScores: MaturaScores) -> Double {
        // Use the program's specific formula to calculate points
        let formula = requirements.formula
        if !formula.isEmpty {
            return FormulaCalculator.calculatePoints(formula: formula, maturaScores: maturaScores)
        }
        
        // Fallback to simple average if no formula specified
        var total = 0.0
        var count = 0.0
        
        // Try to use extended level scores first, then basic
        if let math = maturaScores.mathematics ?? maturaScores.mathematicsBasic {
            total += Double(math)
            count += 1
        }
        if let polish = maturaScores.polish ?? maturaScores.polishBasic {
            total += Double(polish)
            count += 1
        }
        if let foreign = maturaScores.foreignLanguage ?? maturaScores.foreignLanguageBasic {
            total += Double(foreign)
            count += 1
        }
        
        return count > 0 ? total / count : 0
    }
    
    /// Calculate user's progress (0.0 to >1.0) based on last year's threshold
    func calculateProgress(maturaScores: MaturaScores) -> Double? {
        guard let threshold = lastYearThreshold, threshold > 0 else { return nil }
        let userPoints = calculateUserPoints(maturaScores: maturaScores)
        return userPoints / threshold
    }
    
    /// Get formatted progress text (e.g., "+7%" for 107% progress)
    func getProgressText(maturaScores: MaturaScores) -> String? {
        guard let progress = calculateProgress(maturaScores: maturaScores) else { return nil }
        
        if progress > 1.0 {
            return "+\(Int((progress - 1.0) * 100))%"
        } else if progress < 1.0 {
            return "\(Int(progress * 100))%"
        } else {
            return "100%"
        }
    }
    
    /// Get progress color based on user's chances
    func getProgressColor(maturaScores: MaturaScores) -> Color {
        guard let progress = calculateProgress(maturaScores: maturaScores) else {
            return .gray
        }
        
        if progress >= 1.0 {
            return .green
        } else if progress >= 0.8 {
            return .yellow
        } else {
            return .red
        }
    }
}