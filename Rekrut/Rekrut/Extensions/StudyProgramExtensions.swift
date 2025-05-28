//
//  StudyProgramExtensions.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

extension StudyProgram {
    /// Returns a formatted string for the threshold with fallback
    var formattedThreshold: String {
        if let threshold = lastYearThreshold {
            return "\(Int(threshold)) pkt"
        } else {
            return "Brak danych"
        }
    }
    
    /// Returns the color for threshold display
    var thresholdColor: Color {
        if lastYearThreshold != nil {
            return .blue
        } else {
            return .gray
        }
    }
    
    /// Returns appropriate icon for threshold display
    var thresholdIcon: String {
        if lastYearThreshold != nil {
            return "chart.line.uptrend.xyaxis"
        } else {
            return "questionmark.circle"
        }
    }
    
    /// Calculates admission chance color based on threshold
    var admissionChanceColor: Color {
        guard let threshold = lastYearThreshold else {
            return .gray
        }
        
        // Based on Rekrut Score (0-100 proprietary system)
        if threshold >= 85 {
            return .red // Highly competitive (<40% admission chance)
        } else if threshold >= 70 {
            return .yellow // Moderate competition (40-70% admission chance)
        } else {
            return .green // Good chances (>70% admission chance)
        }
    }
    
    /// Returns admission chance description
    func admissionChanceDescription(for userPoints: Double) -> String {
        guard let threshold = lastYearThreshold else {
            return "Brak danych do oceny szans"
        }
        
        let ratio = userPoints / threshold
        
        if ratio >= 1.0 {
            return "Wysokie szanse"
        } else if ratio >= 0.8 {
            return "Umiarkowane szanse"
        } else {
            return "Niskie szanse"
        }
    }
}

// Helper view for consistent threshold display
struct ThresholdInfoView: View {
    let threshold: Double?
    let fontSize: Font = .caption
    let showIcon: Bool = true
    
    var body: some View {
        if let threshold = threshold {
            Label("\(Int(threshold)) pkt", systemImage: showIcon ? "chart.line.uptrend.xyaxis" : "")
                .font(fontSize)
                .foregroundColor(.blue)
        } else {
            Label("Brak danych", systemImage: showIcon ? "questionmark.circle" : "")
                .font(fontSize)
                .foregroundColor(.gray)
        }
    }
}