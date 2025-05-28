//
//  FormulaCalculator.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

/// A sophisticated formula parser and calculator for Polish university admission formulas
class FormulaCalculator {
    
    // MARK: - Formula Components
    
    enum Subject: String, CaseIterable {
        // Core subjects
        case mathematics = "matematyka"
        case polish = "polski"
        case foreignLanguage = "język obcy"
        
        // Sciences
        case physics = "fizyka"
        case chemistry = "chemia"
        case biology = "biologia"
        case computerScience = "informatyka"
        case geography = "geografia"
        
        // Humanities
        case history = "historia"
        case wos = "wos" // Wiedza o społeczeństwie
        case philosophy = "filozofia"
        
        // Additional
        case additionalSubject = "przedmiot dodatkowy"
        
        var aliases: [String] {
            switch self {
            case .mathematics: return ["mat", "matematyka", "m"]
            case .polish: return ["pol", "polski", "język polski", "j.polski", "jp"]
            case .foreignLanguage: return ["język obcy", "obcy", "angielski", "ang", "jo"]
            case .physics: return ["fiz", "fizyka", "f"]
            case .chemistry: return ["chem", "chemia", "ch"]
            case .biology: return ["bio", "biologia", "b"]
            case .computerScience: return ["inf", "informatyka", "it"]
            case .geography: return ["geo", "geografia", "geog"]
            case .history: return ["hist", "historia", "h"]
            case .wos: return ["wos", "wiedza o społeczeństwie"]
            case .philosophy: return ["fil", "filozofia"]
            case .additionalSubject: return ["dodatkowy", "przedmiot dodatkowy", "dod"]
            }
        }
    }
    
    enum Level: String {
        case basic = "podstawowy"
        case extended = "rozszerzony"
        
        var aliases: [String] {
            switch self {
            case .basic: return ["p", "podst", "podstawowy", "podstawa"]
            case .extended: return ["r", "rozsz", "rozszerzony", "rozszerzenie"]
            }
        }
    }
    
    // MARK: - Formula Parsing
    
    struct FormulaComponent {
        let subject: Subject
        let level: Level
        let multiplier: Double
        let isMax: Bool // for formulas like max(math, physics)
        let alternatives: [FormulaComponent]? // for max/min operations
    }
    
    struct ParsedFormula {
        let components: [FormulaComponent]
        let constant: Double // some formulas add a constant
        let divider: Double // some formulas divide the final result
    }
    
    // MARK: - Main Calculation Method
    
    static func calculatePoints(formula: String, maturaScores: MaturaScores) -> Double {
        let parsed = parseFormula(formula)
        var totalPoints = parsed.constant
        
        for component in parsed.components {
            if component.isMax, let alternatives = component.alternatives {
                // Handle max(subject1, subject2) cases
                let maxScore = alternatives.compactMap { alt in
                    getScore(for: alt.subject, level: alt.level, from: maturaScores)
                }.max() ?? 0
                totalPoints += maxScore * component.multiplier
            } else {
                // Regular subject calculation
                if let score = getScore(for: component.subject, level: component.level, from: maturaScores) {
                    totalPoints += score * component.multiplier
                }
            }
        }
        
        return totalPoints / parsed.divider
    }
    
    // MARK: - Formula Parser
    
    private static func parseFormula(_ formula: String) -> ParsedFormula {
        let cleanedFormula = formula.lowercased()
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "w = ", with: "")
            .replacingOccurrences(of: "w=", with: "")
        
        var components: [FormulaComponent] = []
        var constant: Double = 0
        var divider: Double = 1
        
        // Handle shorthand format like MAT_R, POL_P, etc.
        let expandedFormula = cleanedFormula
            .replacingOccurrences(of: "mat_r", with: "matematyka(R)")
            .replacingOccurrences(of: "mat_p", with: "matematyka(P)")
            .replacingOccurrences(of: "pol_r", with: "polski(R)")
            .replacingOccurrences(of: "pol_p", with: "polski(P)")
            .replacingOccurrences(of: "inf_r", with: "informatyka(R)")
            .replacingOccurrences(of: "fiz_r", with: "fizyka(R)")
            .replacingOccurrences(of: "fiz_p", with: "fizyka(P)")
            .replacingOccurrences(of: "chem_r", with: "chemia(R)")
            .replacingOccurrences(of: "bio_r", with: "biologia(R)")
            .replacingOccurrences(of: "his_r", with: "historia(R)")
            .replacingOccurrences(of: "wos_r", with: "wos(R)")
            .replacingOccurrences(of: "ang_r", with: "angielski(R)")
            .replacingOccurrences(of: "ang_p", with: "angielski(P)")
            .replacingOccurrences(of: "geo_r", with: "geografia(R)")
        
        // Common formula patterns in Polish universities
        let patterns: [(pattern: String, handler: (String) -> FormulaComponent?)] = [
            // Pattern: 0.5*matematyka(R) + 0.3*fizyka(R)
            (pattern: #"([\d.]+)\s*\*\s*([a-ząćęłńóśźż\s]+)\s*\(([PR])\)"#, handler: parseWeightedSubject),
            // Pattern: matematyka(P)*0.5
            (pattern: #"([a-ząćęłńóśźż\s]+)\s*\(([PR])\)\s*\*\s*([\d.]+)"#, handler: parseSubjectWeighted),
            // Pattern: max(matematyka, fizyka)
            (pattern: #"max\s*\(([^)]+)\)"#, handler: parseMaxFunction),
            // Pattern: matematyka P
            (pattern: #"([a-ząćęłńóśźż\s]+)\s+([PR])"#, handler: parseSimpleSubject),
        ]
        
        // Extract divider if formula contains division
        if let dividerMatch = cleanedFormula.range(of: #"/\s*([\d.]+)"#, options: .regularExpression) {
            let dividerString = cleanedFormula[dividerMatch].replacingOccurrences(of: "/", with: "").trimmingCharacters(in: .whitespaces)
            divider = Double(dividerString) ?? 1
        }
        
        // Parse formula components
        var remainingFormula = expandedFormula
        
        for (pattern, handler) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let matches = regex.matches(in: remainingFormula, range: NSRange(remainingFormula.startIndex..., in: remainingFormula))
                
                for match in matches.reversed() {
                    if let range = Range(match.range, in: remainingFormula),
                       let component = handler(String(remainingFormula[range])) {
                        components.append(component)
                        remainingFormula.removeSubrange(range)
                    }
                }
            }
        }
        
        // Extract any remaining constant
        if let constantMatch = remainingFormula.range(of: #"\+\s*([\d.]+)"#, options: .regularExpression) {
            let constantString = remainingFormula[constantMatch].replacingOccurrences(of: "+", with: "").trimmingCharacters(in: .whitespaces)
            constant = Double(constantString) ?? 0
        }
        
        return ParsedFormula(components: components, constant: constant, divider: divider)
    }
    
    // MARK: - Pattern Handlers
    
    private static func parseWeightedSubject(_ match: String) -> FormulaComponent? {
        let parts = match.components(separatedBy: "*")
        guard parts.count == 2,
              let multiplier = Double(parts[0].trimmingCharacters(in: .whitespaces)) else { return nil }
        
        let subjectPart = parts[1]
        if let subject = extractSubject(from: subjectPart),
           let level = extractLevel(from: subjectPart) {
            return FormulaComponent(subject: subject, level: level, multiplier: multiplier, isMax: false, alternatives: nil)
        }
        return nil
    }
    
    private static func parseSubjectWeighted(_ match: String) -> FormulaComponent? {
        let parts = match.components(separatedBy: "*")
        guard parts.count == 2,
              let multiplier = Double(parts[1].trimmingCharacters(in: .whitespaces)) else { return nil }
        
        let subjectPart = parts[0]
        if let subject = extractSubject(from: subjectPart),
           let level = extractLevel(from: subjectPart) {
            return FormulaComponent(subject: subject, level: level, multiplier: multiplier, isMax: false, alternatives: nil)
        }
        return nil
    }
    
    private static func parseMaxFunction(_ match: String) -> FormulaComponent? {
        // Extract subjects from max() function
        let content = match
            .replacingOccurrences(of: "max", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        let subjects = content.components(separatedBy: ",")
        var alternatives: [FormulaComponent] = []
        
        for subjectString in subjects {
            if let subject = extractSubject(from: subjectString),
               let level = extractLevel(from: subjectString) {
                alternatives.append(FormulaComponent(subject: subject, level: level, multiplier: 1.0, isMax: false, alternatives: nil))
            }
        }
        
        if !alternatives.isEmpty {
            return FormulaComponent(subject: alternatives[0].subject, level: alternatives[0].level, multiplier: 1.0, isMax: true, alternatives: alternatives)
        }
        return nil
    }
    
    private static func parseSimpleSubject(_ match: String) -> FormulaComponent? {
        if let subject = extractSubject(from: match),
           let level = extractLevel(from: match) {
            return FormulaComponent(subject: subject, level: level, multiplier: 1.0, isMax: false, alternatives: nil)
        }
        return nil
    }
    
    // MARK: - Helper Methods
    
    private static func extractSubject(from text: String) -> Subject? {
        let lowercased = text.lowercased()
        for subject in Subject.allCases {
            for alias in subject.aliases {
                if lowercased.contains(alias) {
                    return subject
                }
            }
        }
        return nil
    }
    
    private static func extractLevel(from text: String) -> Level? {
        let lowercased = text.lowercased()
        
        // Check for explicit level indicators
        if lowercased.contains("(r)") || lowercased.contains("(rozsz)") || lowercased.contains("rozszerzony") {
            return .extended
        } else if lowercased.contains("(p)") || lowercased.contains("(podst)") || lowercased.contains("podstawowy") {
            return .basic
        }
        
        // Check for single letter indicators
        for level in [Level.extended, Level.basic] {
            for alias in level.aliases {
                if lowercased.contains(alias) {
                    return level
                }
            }
        }
        
        // Default to extended if not specified (common in formulas)
        return .extended
    }
    
    private static func getScore(for subject: Subject, level: Level, from scores: MaturaScores) -> Double? {
        switch subject {
        case .mathematics:
            return level == .basic ? scores.mathematicsBasic.map(Double.init) : scores.mathematics.map(Double.init)
        case .polish:
            return level == .basic ? scores.polishBasic.map(Double.init) : scores.polish.map(Double.init)
        case .foreignLanguage:
            return level == .basic ? scores.foreignLanguageBasic.map(Double.init) : scores.foreignLanguage.map(Double.init)
        case .physics:
            return scores.physics.map(Double.init)
        case .chemistry:
            return scores.chemistry.map(Double.init)
        case .biology:
            return scores.biology.map(Double.init)
        case .computerScience:
            return scores.computerScience.map(Double.init)
        case .geography:
            return scores.geography.map(Double.init)
        case .history:
            return scores.history.map(Double.init)
        case .wos:
            return scores.socialStudies.map(Double.init)
        case .additionalSubject:
            // Return the highest additional subject score
            return [scores.physics, scores.chemistry, scores.biology, scores.computerScience, 
                    scores.geography, scores.history, scores.socialStudies]
                .compactMap { $0.map(Double.init) }
                .max()
        default:
            return nil
        }
    }
}

// MARK: - Example Formulas
/*
 Common Polish university formulas:
 
 1. "0.5 × matematyka (R) + 0.3 × fizyka (R) + 0.2 × język obcy (R)"
 2. "matematyka P + max(fizyka, chemia, informatyka)"
 3. "0.4 × polski (P) + 0.6 × matematyka (R)"
 4. "(matematyka R + fizyka R + język obcy R) / 3"
 5. "matematyka R × 0.5 + (fizyka R lub chemia R) × 0.5"
 6. "0.3 × język polski P + 0.7 × max(matematyka R, fizyka R)"
 */