//
//  MaturaScore.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

struct MaturaScores: Codable {
    var subjects: [MaturaSubjectScore]
    var year: Int
    
    init(year: Int = Calendar.current.component(.year, from: Date())) {
        self.year = year
        self.subjects = []
    }
    
    func score(for subject: MaturaSubject) -> MaturaSubjectScore? {
        subjects.first { $0.subject == subject }
    }
}

struct MaturaSubjectScore: Codable, Identifiable {
    var id: String { "\(subject.rawValue)_\(level.rawValue)" }
    var subject: MaturaSubject
    var level: MaturaLevel
    var scorePercentage: Double // 0-100
    var scorePoints: Int? // converted points for recruitment
}

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