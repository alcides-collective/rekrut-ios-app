//
//  MaturaScore.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

/// Simplified matura scores structure for formula calculations
struct MaturaScores: Codable {
    // Mandatory subjects - basic level
    var polishBasic: Int?
    var mathematicsBasic: Int?
    var foreignLanguageBasic: Int?
    
    // Mandatory subjects - extended level
    var polish: Int?
    var mathematics: Int?
    var foreignLanguage: Int?
    
    // Science subjects (extended level only)
    var physics: Int?
    var chemistry: Int?
    var biology: Int?
    var computerScience: Int?
    
    // Humanities subjects (extended level only)
    var history: Int?
    var geography: Int?
    var socialStudies: Int? // WOS
    var philosophy: Int?
    
    // Additional subjects
    var additionalSubject: Int?
    var additionalSubjectName: String?
    
    init() {
        // Initialize with nil values
    }
    
    /// Get all entered scores for display
    var allScores: [(subject: String, level: String, score: Int)] {
        var scores: [(String, String, Int)] = []
        
        // Basic level
        if let score = polishBasic { scores.append(("Polski", "podstawowy", score)) }
        if let score = mathematicsBasic { scores.append(("Matematyka", "podstawowy", score)) }
        if let score = foreignLanguageBasic { scores.append(("Język obcy", "podstawowy", score)) }
        
        // Extended level
        if let score = polish { scores.append(("Polski", "rozszerzony", score)) }
        if let score = mathematics { scores.append(("Matematyka", "rozszerzony", score)) }
        if let score = foreignLanguage { scores.append(("Język obcy", "rozszerzony", score)) }
        
        // Sciences
        if let score = physics { scores.append(("Fizyka", "rozszerzony", score)) }
        if let score = chemistry { scores.append(("Chemia", "rozszerzony", score)) }
        if let score = biology { scores.append(("Biologia", "rozszerzony", score)) }
        if let score = computerScience { scores.append(("Informatyka", "rozszerzony", score)) }
        
        // Humanities
        if let score = history { scores.append(("Historia", "rozszerzony", score)) }
        if let score = geography { scores.append(("Geografia", "rozszerzony", score)) }
        if let score = socialStudies { scores.append(("WOS", "rozszerzony", score)) }
        if let score = philosophy { scores.append(("Filozofia", "rozszerzony", score)) }
        
        return scores
    }
    
    /// Check if minimum required scores are entered
    var hasMinimumScores: Bool {
        // At least basic level mandatory subjects should be present
        return polishBasic != nil && mathematicsBasic != nil && foreignLanguageBasic != nil
    }
    
    // MARK: - Backward compatibility with old subjects array
    
    /// Convert to/from array of MaturaSubjectScore for backward compatibility
    var subjects: [MaturaSubjectScore] {
        get {
            var result: [MaturaSubjectScore] = []
            
            // Basic level
            if let score = polishBasic {
                result.append(MaturaSubjectScore(
                    subject: .polish,
                    level: .basic,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = mathematicsBasic {
                result.append(MaturaSubjectScore(
                    subject: .mathematics,
                    level: .basic,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = foreignLanguageBasic {
                result.append(MaturaSubjectScore(
                    subject: .foreignLanguage,
                    level: .basic,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            
            // Extended level
            if let score = polish {
                result.append(MaturaSubjectScore(
                    subject: .polish,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = mathematics {
                result.append(MaturaSubjectScore(
                    subject: .mathematics,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = foreignLanguage {
                result.append(MaturaSubjectScore(
                    subject: .foreignLanguage,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            
            // Sciences
            if let score = physics {
                result.append(MaturaSubjectScore(
                    subject: .physics,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = chemistry {
                result.append(MaturaSubjectScore(
                    subject: .chemistry,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = biology {
                result.append(MaturaSubjectScore(
                    subject: .biology,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = computerScience {
                result.append(MaturaSubjectScore(
                    subject: .computerScience,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            
            // Humanities
            if let score = history {
                result.append(MaturaSubjectScore(
                    subject: .history,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = geography {
                result.append(MaturaSubjectScore(
                    subject: .geography,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = socialStudies {
                result.append(MaturaSubjectScore(
                    subject: .civics,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            if let score = philosophy {
                result.append(MaturaSubjectScore(
                    subject: .philosophy,
                    level: .extended,
                    scorePercentage: Double(score),
                    scorePoints: score
                ))
            }
            
            return result
        }
        set {
            // Reset all scores
            polishBasic = nil
            mathematicsBasic = nil
            foreignLanguageBasic = nil
            polish = nil
            mathematics = nil
            foreignLanguage = nil
            physics = nil
            chemistry = nil
            biology = nil
            computerScience = nil
            history = nil
            geography = nil
            socialStudies = nil
            philosophy = nil
            
            // Set scores from array
            for score in newValue {
                let value = Int(score.scorePercentage)
                
                switch (score.subject, score.level) {
                case (.polish, .basic): polishBasic = value
                case (.polish, .extended): polish = value
                case (.mathematics, .basic): mathematicsBasic = value
                case (.mathematics, .extended): mathematics = value
                case (.foreignLanguage, .basic): foreignLanguageBasic = value
                case (.foreignLanguage, .extended): foreignLanguage = value
                case (.physics, _): physics = value
                case (.chemistry, _): chemistry = value
                case (.biology, _): biology = value
                case (.computerScience, _): computerScience = value
                case (.history, _): history = value
                case (.geography, _): geography = value
                case (.civics, _): socialStudies = value
                case (.philosophy, _): philosophy = value
                default: break
                }
            }
        }
    }
    
    /// Helper to get score for a specific subject and level
    func score(for subject: MaturaSubject, level: MaturaLevel? = nil) -> MaturaSubjectScore? {
        subjects.first { score in
            score.subject == subject && (level == nil || score.level == level)
        }
    }
    
    /// Legacy initializer with year
    init(year: Int = Calendar.current.component(.year, from: Date())) {
        self.init()
    }
}

// Keep the old enums for compatibility if needed elsewhere
enum MaturaSubject: String, Codable, CaseIterable {
    // Obowiązkowe (Mandatory)
    case polish = "Język polski"
    case mathematics = "Matematyka"
    case foreignLanguage = "Język obcy nowożytny"
    
    // Przedmioty dodatkowe (Additional subjects)
    // Sciences
    case biology = "Biologia"
    case chemistry = "Chemia"
    case physics = "Fizyka"
    case computerScience = "Informatyka"
    
    // Humanities
    case history = "Historia"
    case geography = "Geografia"
    case civics = "Wiedza o społeczeństwie"
    case philosophy = "Filozofia"
    case polishCulture = "Wiedza o kulturze"
    case latinAndAncientCulture = "Język łaciński i kultura antyczna"
    
    // Languages
    case english = "Język angielski"
    case german = "Język niemiecki"
    case spanish = "Język hiszpański"
    case french = "Język francuski"
    case russian = "Język rosyjski"
    case italian = "Język włoski"
    
    // Arts
    case artHistory = "Historia sztuki"
    case music = "Historia muzyki"
    
    var isMandatory: Bool {
        switch self {
        case .polish, .mathematics, .foreignLanguage:
            return true
        default:
            return false
        }
    }
    
    var category: String {
        switch self {
        case .polish, .mathematics, .foreignLanguage:
            return "Przedmioty obowiązkowe"
        case .biology, .chemistry, .physics, .computerScience:
            return "Nauki ścisłe"
        case .history, .geography, .civics, .philosophy, .polishCulture, .latinAndAncientCulture:
            return "Nauki humanistyczne"
        case .english, .german, .spanish, .french, .russian, .italian:
            return "Języki obce"
        case .artHistory, .music:
            return "Przedmioty artystyczne"
        }
    }
}

enum MaturaLevel: String, Codable, CaseIterable {
    case basic = "Poziom podstawowy"
    case extended = "Poziom rozszerzony"
    
    var shortName: String {
        switch self {
        case .basic: return "PP"
        case .extended: return "PR"
        }
    }
}

// Legacy support
struct MaturaSubjectScore: Codable, Identifiable {
    var id: String { "\(subject.rawValue)_\(level.rawValue)" }
    var subject: MaturaSubject
    var level: MaturaLevel
    var scorePercentage: Double // 0-100
    var scorePoints: Int? // converted points for recruitment
}