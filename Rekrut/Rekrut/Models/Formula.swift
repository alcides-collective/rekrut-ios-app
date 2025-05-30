//
//  Formula.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

// MARK: - Advanced Cross-Platform Formula Model
// Supports complex Polish university admission systems

struct Formula: Codable {
    let version: String // "2.0" for advanced features
    let universityId: String
    let programId: String
    let type: FormulaType
    let stages: [FormulaStage] // Support multi-stage recruitment
    let bonuses: [BonusRule]? // Olympic bonuses, certificates, etc.
    let requirements: FormulaRequirements?
    let metadata: FormulaMetadata
    
    enum FormulaType: String, Codable {
        case simple = "simple" // Single-stage weighted sum
        case multiStage = "multi_stage" // Multiple stages with thresholds
        case conditional = "conditional" // Different paths based on conditions
        case mixed = "mixed" // Combines exam scores with practical tests
    }
}

// MARK: - Formula Stages

struct FormulaStage: Codable {
    let id: String
    let name: String // e.g., "Etap I", "Rozmowa kwalifikacyjna"
    let components: [FormulaComponent]
    let operations: [Operation]?
    let practicalExams: [PracticalExam]?
    let threshold: Threshold? // Minimum to advance to next stage
    let coefficient: Double? // Stage weight in final calculation
    let maxPoints: Double
}

// MARK: - Enhanced Components

struct FormulaComponent: Codable {
    let id: String
    let type: ComponentType
    let subject: String? // For exam components
    let level: String? // "R", "P", "bilingual"
    let weight: Double
    let levelCoefficients: LevelCoefficients? // Different multipliers per level
    let required: Bool
    let alternatives: [String]? // IDs of alternative components
    let minScore: Double? // Minimum required score
    let maxScore: Double? // Maximum possible score (default 100)
}

enum ComponentType: String, Codable {
    case maturaExam = "matura_exam"
    case practicalExam = "practical_exam"
    case interview = "interview"
    case portfolio = "portfolio"
    case previousDegree = "previous_degree"
    case olympiad = "olympiad"
    case certificate = "certificate"
}

// MARK: - Level Coefficients

struct LevelCoefficients: Codable {
    let basic: Double? // e.g., 0.4
    let extended: Double? // e.g., 1.0
    let bilingual: Double? // e.g., 1.3
    let international: Double? // For IB/EB conversions
}

// MARK: - Practical Exams

struct PracticalExam: Codable {
    let id: String
    let name: String // e.g., "Test sprawności plastycznej"
    let type: ExamType
    let weight: Double
    let tasks: [ExamTask]?
    let minScore: Double? // Minimum to pass (e.g., 30%)
    let maxPoints: Double
    let description: String?
    
    enum ExamType: String, Codable {
        case drawing = "drawing"
        case sculpture = "sculpture"
        case aptitude = "aptitude"
        case physical = "physical"
        case musical = "musical"
        case portfolio = "portfolio"
        case interview = "interview"
    }
}

struct ExamTask: Codable {
    let name: String
    let points: Double
    let duration: Int? // in minutes
}

// MARK: - Operations

struct Operation: Codable {
    let id: String
    let type: OperationType
    let componentIds: [String]
    let value: Double?
    let resultId: String? // Where to store the result
    
    enum OperationType: String, Codable {
        case max = "max"
        case min = "min"
        case sum = "sum"
        case average = "average"
        case multiply = "multiply"
        case divide = "divide"
        case conditional = "conditional" // if-then-else
        case threshold = "threshold" // apply minimum threshold
    }
}

// MARK: - Bonus Rules

struct BonusRule: Codable {
    let id: String
    let type: BonusType
    let condition: String // Description of when bonus applies
    let points: Double
    let multiplier: Double? // Alternative to fixed points
    let maxBonus: Double? // Cap on total bonus
    
    enum BonusType: String, Codable {
        case olympiad = "olympiad"
        case competition = "competition"
        case certificate = "certificate"
        case volunteer = "volunteer"
        case sports = "sports"
        case other = "other"
    }
}

// MARK: - Thresholds

struct Threshold: Codable {
    let type: ThresholdType
    let value: Double
    let description: String?
    
    enum ThresholdType: String, Codable {
        case minimum = "minimum" // Must score at least X
        case percentage = "percentage" // Must score at least X% of max
        case ranking = "ranking" // Top X candidates advance
        case multiplier = "multiplier" // Advance 2x number of places
    }
}

// MARK: - Requirements

struct FormulaRequirements: Codable {
    let mandatorySubjects: [String]? // Must have these subjects
    let minimumScores: [String: Double]? // Minimum per subject
    let practicalTestRequired: Bool
    let interviewRequired: Bool
    let portfolioRequired: Bool
    let previousDegreeRequired: Bool
}

// MARK: - Metadata

struct FormulaMetadata: Codable {
    let description: String
    let lastYearThreshold: Double?
    let averageThreshold: Double? // 3-year average
    let maxPossibleScore: Double
    let scoringUnit: String // "points", "percentage"
    let officialCalculatorURL: String?
    let notes: String? // Special conditions
    let lastUpdated: Date
}

// MARK: - Conversion Rules

struct ConversionRule: Codable {
    let fromSystem: String // "IB", "EB", "foreign"
    let toSystem: String // "polish"
    let formula: String // Conversion formula
    let example: String? // Example calculation
}

// MARK: - Complex Formula Examples

extension Formula {
    static let examples = [
        // Warsaw Tech Architecture - Most Complex
        Formula(
            version: "2.0",
            universityId: "pw",
            programId: "pw-architektura",
            type: .mixed,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Rekrutacja główna",
                    components: [
                        FormulaComponent(
                            id: "psp",
                            type: ComponentType.practicalExam,
                            subject: nil,
                            level: nil,
                            weight: 1.0,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: 60, // 30% of 200
                            maxScore: 200
                        ),
                        FormulaComponent(
                            id: "mat",
                            type: ComponentType.maturaExam,
                            subject: "MAT",
                            level: "R",
                            weight: 0.75,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "jo",
                            type: ComponentType.maturaExam,
                            subject: "J.OBC",
                            level: "R",
                            weight: 0.25,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "wyb1",
                            type: ComponentType.maturaExam,
                            subject: "GROUP1",
                            level: "R",
                            weight: 0.5,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: ["FIZ", "INF", "GEO"],
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "wyb2",
                            type: ComponentType.maturaExam,
                            subject: "GROUP2",
                            level: "R",
                            weight: 0.5,
                            levelCoefficients: nil,
                            required: true,
                            alternatives: ["HIS", "WOS", "FIL"],
                            minScore: nil,
                            maxScore: 100
                        )
                    ],
                    operations: [],
                    practicalExams: [
                        PracticalExam(
                            id: "psp",
                            name: "Test sprawności plastycznej",
                            type: .drawing,
                            weight: 1.0,
                            tasks: [
                                ExamTask(name: "Zadanie graficzne 1", points: 100, duration: 120),
                                ExamTask(name: "Zadanie graficzne 2", points: 100, duration: 120)
                            ],
                            minScore: 60,
                            maxPoints: 200,
                            description: "Dwa zadania graficzne sprawdzające wyobraźnię przestrzenną"
                        )
                    ],
                    threshold: Threshold(
                        type: .minimum,
                        value: 60,
                        description: "Minimum 30% z testu praktycznego"
                    ),
                    coefficient: 1.0,
                    maxPoints: 400
                )
            ],
            bonuses: nil,
            requirements: FormulaRequirements(
                mandatorySubjects: ["MAT", "J.OBC"],
                minimumScores: nil,
                practicalTestRequired: true,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: "Architektura - Politechnika Warszawska",
                lastYearThreshold: 325.5,
                averageThreshold: 320.0,
                maxPossibleScore: 400,
                scoringUnit: "points",
                officialCalculatorURL: "https://www.pw.edu.pl/kalkulator",
                notes: "Kandydaci muszą wybrać przedmioty z różnych grup tematycznych",
                lastUpdated: Date()
            )
        ),
        
        // Gdańsk Tech with Bilingual Bonus
        Formula(
            version: "2.0",
            universityId: "pg",
            programId: "pg-informatyka",
            type: .mixed,
            stages: [
                FormulaStage(
                    id: "main",
                    name: "Etap główny",
                    components: [
                        FormulaComponent(
                            id: "mat",
                            type: ComponentType.maturaExam,
                            subject: "MAT",
                            level: "mixed",
                            weight: 1.0,
                            levelCoefficients: LevelCoefficients(
                                basic: 0.4,
                                extended: 1.0,
                                bilingual: 1.3,
                                international: nil
                            ),
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "additional",
                            type: ComponentType.maturaExam,
                            subject: "ADDITIONAL",
                            level: "mixed",
                            weight: 1.0,
                            levelCoefficients: LevelCoefficients(
                                basic: 0.4,
                                extended: 1.0,
                                bilingual: 1.3,
                                international: nil
                            ),
                            required: true,
                            alternatives: ["FIZ", "INF", "CHEM"],
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "pol",
                            type: ComponentType.maturaExam,
                            subject: "POL",
                            level: "mixed",
                            weight: 0.1,
                            levelCoefficients: LevelCoefficients(
                                basic: 0.4,
                                extended: 1.0,
                                bilingual: 1.3,
                                international: nil
                            ),
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "jo",
                            type: ComponentType.maturaExam,
                            subject: "J.OBC",
                            level: "mixed",
                            weight: 0.1,
                            levelCoefficients: LevelCoefficients(
                                basic: 0.4,
                                extended: 1.0,
                                bilingual: 1.3,
                                international: nil
                            ),
                            required: true,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 100
                        ),
                        FormulaComponent(
                            id: "s_test",
                            type: ComponentType.practicalExam,
                            subject: nil,
                            level: nil,
                            weight: 1.0,
                            levelCoefficients: nil,
                            required: false,
                            alternatives: nil,
                            minScore: nil,
                            maxScore: 500
                        )
                    ],
                    operations: [
                        Operation(
                            id: "op1",
                            type: .max,
                            componentIds: ["additional_fiz", "additional_inf", "additional_chem"],
                            value: nil,
                            resultId: "additional_result"
                        )
                    ],
                    practicalExams: [
                        PracticalExam(
                            id: "s_test",
                            name: "Test uzdolnień kierunkowych",
                            type: .aptitude,
                            weight: 1.0,
                            tasks: nil,
                            minScore: nil,
                            maxPoints: 500,
                            description: "Opcjonalny test dla kandydatów bez matury rozszerzonej"
                        )
                    ],
                    threshold: nil as Threshold?,
                    coefficient: 1.0,
                    maxPoints: 720
                )
            ],
            bonuses: [
                BonusRule(
                    id: "qualification_points",
                    type: .certificate,
                    condition: "Punkty kwalifikacyjne za świadectwa i certyfikaty",
                    points: 0,
                    multiplier: nil,
                    maxBonus: 100
                )
            ],
            requirements: FormulaRequirements(
                mandatorySubjects: ["MAT", "POL", "J.OBC"],
                minimumScores: nil,
                practicalTestRequired: false,
                interviewRequired: false,
                portfolioRequired: false,
                previousDegreeRequired: false
            ),
            metadata: FormulaMetadata(
                description: "Informatyka - Politechnika Gdańska",
                lastYearThreshold: 580.5,
                averageThreshold: 575.0,
                maxPossibleScore: 720,
                scoringUnit: "points",
                officialCalculatorURL: "https://pg.edu.pl/kalkulator",
                notes: "Współczynnik 1.3 dla matury dwujęzycznej",
                lastUpdated: Date()
            )
        )
    ]
}

// MARK: - Calculation Support

extension Formula {
    // Convert to Python-compatible dictionary
    func toPythonDict() -> [String: Any] {
        var dict: [String: Any] = [
            "version": version,
            "university_id": universityId,
            "program_id": programId,
            "type": type.rawValue,
            "stages": stages.map { stage in
                [
                    "id": stage.id,
                    "name": stage.name,
                    "components": stage.components.map { $0.toPythonDict() },
                    "max_points": stage.maxPoints
                ]
            }
        ]
        
        if let bonuses = bonuses {
            dict["bonuses"] = bonuses.map { bonus in
                [
                    "id": bonus.id,
                    "type": bonus.type.rawValue,
                    "condition": bonus.condition,
                    "points": bonus.points
                ]
            }
        }
        
        dict["metadata"] = [
            "description": metadata.description,
            "max_possible_score": metadata.maxPossibleScore,
            "scoring_unit": metadata.scoringUnit
        ]
        
        return dict
    }
}

extension FormulaComponent {
    func toPythonDict() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "type": type.rawValue,
            "weight": weight,
            "required": required
        ]
        
        if let subject = subject { dict["subject"] = subject }
        if let level = level { dict["level"] = level }
        if let alternatives = alternatives { dict["alternatives"] = alternatives }
        if let levelCoefficients = levelCoefficients {
            var coeffs: [String: Double] = [:]
            if let basic = levelCoefficients.basic { coeffs["basic"] = basic }
            if let extended = levelCoefficients.extended { coeffs["extended"] = extended }
            if let bilingual = levelCoefficients.bilingual { coeffs["bilingual"] = bilingual }
            dict["level_coefficients"] = coeffs
        }
        
        return dict
    }
}