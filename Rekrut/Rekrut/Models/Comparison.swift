//
//  Comparison.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

struct Comparison: Codable, Identifiable {
    let id: String
    var userId: String
    var programIds: [String] // Usually 2-3 programs
    var createdAt: Date
    var title: String?
    var notes: String?
    var aiInsights: AIComparisonInsights?
}

struct AIComparisonInsights: Codable {
    var summary: String
    var strengths: [String: [String]] // programId: [strengths]
    var considerations: [String: [String]] // programId: [considerations]
    var recommendation: String?
    var careerProspects: [String: String] // programId: description
    var generatedAt: Date
}