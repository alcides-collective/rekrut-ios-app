//
//  FormulaCalculator.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation

/// Advanced calculator for complex Polish university admission formulas
class FormulaCalculator {
    
    // MARK: - Data Models
    
    struct ExtendedScores {
        let maturaScores: MaturaScores
        let practicalExams: [String: Double]? // exam_id -> score
        let interviewScore: Double?
        let portfolioScore: Double?
        let previousDegreeGPA: Double?
        let olympiadResults: [OlympiadResult]?
        let certificates: [Certificate]?
        let isBilingual: Bool // For bilingual matura bonus
        let examSystem: ExamSystem // Polish, IB, EB, etc.
    }
    
    struct OlympiadResult {
        let name: String
        let level: OlympiadLevel
        let subject: String
        
        enum OlympiadLevel: String {
            case centralWinner = "central_winner"
            case centralFinalist = "central_finalist"
            case regionalWinner = "regional_winner"
            case regionalFinalist = "regional_finalist"
        }
    }
    
    struct Certificate {
        let type: String
        let level: String?
        let score: Double?
    }
    
    enum ExamSystem: String {
        case polish = "polish"
        case ib = "ib" // International Baccalaureate
        case eb = "eb" // European Baccalaureate
        case foreign = "foreign"
    }
    
    struct CalculationResult {
        let totalScore: Double
        let stageResults: [StageResult]
        let bonusPoints: Double
        let meetsRequirements: Bool
        let disqualificationReason: String?
        let breakdown: [String: Double] // Component ID -> points
    }
    
    struct StageResult {
        let stageId: String
        let stageName: String
        let score: Double
        let maxScore: Double
        let passed: Bool
        let componentScores: [String: Double]
    }
    
    // MARK: - Main Calculation Method
    
    static func calculate(formula: Formula, scores: ExtendedScores) -> CalculationResult {
        var stageResults: [StageResult] = []
        var totalScore: Double = 0
        var breakdown: [String: Double] = [:]
        var bonusPoints: Double = 0
        
        // Check requirements first
        let (meetsReqs, reason) = checkRequirements(formula: formula, scores: scores)
        if !meetsReqs {
            return CalculationResult(
                totalScore: 0,
                stageResults: [],
                bonusPoints: 0,
                meetsRequirements: false,
                disqualificationReason: reason,
                breakdown: [:]
            )
        }
        
        // Calculate each stage
        for (index, stage) in formula.stages.enumerated() {
            let stageResult = calculateStage(stage: stage, scores: scores, formula: formula)
            stageResults.append(stageResult)
            
            // Check if passed this stage
            if let threshold = stage.threshold, !checkThreshold(score: stageResult.score, threshold: threshold, maxScore: stage.maxPoints) {
                // Failed to meet threshold, stop here
                break
            }
            
            // Add to total with stage coefficient
            let coefficient = stage.coefficient ?? 1.0
            totalScore += stageResult.score * coefficient
            
            // Merge breakdowns
            for (key, value) in stageResult.componentScores {
                breakdown["\(stage.id)_\(key)"] = value
            }
        }
        
        // Calculate bonuses
        if let bonuses = formula.bonuses {
            bonusPoints = calculateBonuses(bonuses: bonuses, scores: scores)
            totalScore += bonusPoints
        }
        
        return CalculationResult(
            totalScore: min(totalScore, formula.metadata.maxPossibleScore),
            stageResults: stageResults,
            bonusPoints: bonusPoints,
            meetsRequirements: true,
            disqualificationReason: nil,
            breakdown: breakdown
        )
    }
    
    // MARK: - Stage Calculation
    
    private static func calculateStage(stage: FormulaStage, scores: ExtendedScores, formula: Formula) -> StageResult {
        var componentScores: [String: Double] = [:]
        var stageScore: Double = 0
        
        // Calculate each component
        for component in stage.components {
            let score = calculateComponent(component: component, scores: scores, stage: stage)
            componentScores[component.id] = score
            stageScore += score
        }
        
        // Apply operations
        if let operations = stage.operations {
            for operation in operations {
                let result = applyOperation(operation: operation, componentScores: &componentScores)
                if let resultId = operation.resultId {
                    componentScores[resultId] = result
                    stageScore = componentScores.values.reduce(0, +) // Recalculate total
                }
            }
        }
        
        // Check if passed
        let passed = stage.threshold == nil || checkThreshold(
            score: stageScore,
            threshold: stage.threshold!,
            maxScore: stage.maxPoints
        )
        
        return StageResult(
            stageId: stage.id,
            stageName: stage.name,
            score: stageScore,
            maxScore: stage.maxPoints,
            passed: passed,
            componentScores: componentScores
        )
    }
    
    // MARK: - Component Calculation
    
    private static func calculateComponent(component: FormulaComponent, scores: ExtendedScores, stage: FormulaStage) -> Double {
        var baseScore: Double = 0
        
        switch component.type {
        case .maturaExam:
            baseScore = getMaturaScore(
                subject: component.subject ?? "",
                level: component.level ?? "R",
                scores: scores.maturaScores,
                levelCoefficients: component.levelCoefficients,
                isBilingual: scores.isBilingual
            )
            
        case .practicalExam:
            if let practicalScores = scores.practicalExams,
               let score = practicalScores[component.id] {
                baseScore = score
            }
            
        case .interview:
            baseScore = scores.interviewScore ?? 0
            
        case .portfolio:
            baseScore = scores.portfolioScore ?? 0
            
        case .previousDegree:
            if let gpa = scores.previousDegreeGPA {
                baseScore = gpa * 10 // Convert to points (assuming 0-10 scale)
            }
            
        case .olympiad, .certificate:
            // Handled in bonus calculation
            baseScore = 0
        }
        
        // Apply weight
        let weightedScore = baseScore * component.weight
        
        // Apply min/max constraints
        if let minScore = component.minScore, weightedScore < minScore {
            return 0 // Failed minimum requirement
        }
        
        if let maxScore = component.maxScore {
            return min(weightedScore, maxScore * component.weight)
        }
        
        return weightedScore
    }
    
    // MARK: - Matura Score Extraction
    
    private static func getMaturaScore(
        subject: String,
        level: String,
        scores: MaturaScores,
        levelCoefficients: LevelCoefficients?,
        isBilingual: Bool
    ) -> Double {
        // Get base score
        let baseScore = getBaseMaturaScore(subject: subject, level: level, scores: scores)
        
        // Apply level coefficient
        if let coefficients = levelCoefficients {
            let coefficient: Double
            if isBilingual, let bilingualCoeff = coefficients.bilingual {
                coefficient = bilingualCoeff
            } else if level == "R", let extendedCoeff = coefficients.extended {
                coefficient = extendedCoeff
            } else if level == "P", let basicCoeff = coefficients.basic {
                coefficient = basicCoeff
            } else {
                coefficient = 1.0
            }
            return baseScore * coefficient
        }
        
        return baseScore
    }
    
    private static func getBaseMaturaScore(subject: String, level: String, scores: MaturaScores) -> Double {
        // Handle subject groups
        if subject.hasPrefix("GROUP") {
            return 0 // Should be handled by alternatives
        }
        
        // Map subject codes to scores
        switch subject {
        case "MAT", "matematyka":
            return level == "P" ? 
                Double(scores.mathematicsBasic ?? 0) :
                Double(scores.mathematics ?? 0)
            
        case "POL", "J.POL", "polski":
            return level == "P" ?
                Double(scores.polishBasic ?? 0) :
                Double(scores.polish ?? 0)
            
        case "ANG", "J.OBC", "angielski", "język obcy":
            return level == "P" ?
                Double(scores.foreignLanguageBasic ?? 0) :
                Double(scores.foreignLanguage ?? 0)
            
        case "FIZ", "fizyka":
            return Double(scores.physics ?? 0)
            
        case "CHEM", "CHE", "chemia":
            return Double(scores.chemistry ?? 0)
            
        case "BIO", "biologia":
            return Double(scores.biology ?? 0)
            
        case "INF", "informatyka":
            return Double(scores.computerScience ?? 0)
            
        case "GEO", "geografia":
            return Double(scores.geography ?? 0)
            
        case "HIS", "HIST", "historia":
            return Double(scores.history ?? 0)
            
        case "WOS", "wiedza o społeczeństwie":
            return Double(scores.socialStudies ?? 0)
            
        default:
            return 0
        }
    }
    
    // MARK: - Operations
    
    private static func applyOperation(operation: Operation, componentScores: inout [String: Double]) -> Double {
        let values = operation.componentIds.compactMap { componentScores[$0] }
        
        switch operation.type {
        case .max:
            return values.max() ?? 0
            
        case .min:
            return values.min() ?? 0
            
        case .sum:
            return values.reduce(0, +)
            
        case .average:
            return values.isEmpty ? 0 : values.reduce(0, +) / Double(values.count)
            
        case .multiply:
            let product = values.reduce(1, *)
            return product * (operation.value ?? 1.0)
            
        case .divide:
            let sum = values.reduce(0, +)
            return sum / (operation.value ?? 1.0)
            
        case .conditional:
            // Simplified conditional logic
            return values.first ?? 0
            
        case .threshold:
            let value = values.first ?? 0
            let threshold = operation.value ?? 0
            return value >= threshold ? value : 0
        }
    }
    
    // MARK: - Bonus Calculation
    
    private static func calculateBonuses(bonuses: [BonusRule], scores: ExtendedScores) -> Double {
        var totalBonus: Double = 0
        
        for bonus in bonuses {
            var bonusPoints: Double = 0
            
            switch bonus.type {
            case .olympiad:
                if let olympiads = scores.olympiadResults {
                    for olympiad in olympiads {
                        bonusPoints += getOlympiadBonus(olympiad: olympiad, rule: bonus)
                    }
                }
                
            case .certificate:
                if let certificates = scores.certificates {
                    for certificate in certificates {
                        bonusPoints += getCertificateBonus(certificate: certificate, rule: bonus)
                    }
                }
                
            default:
                bonusPoints = bonus.points
            }
            
            // Apply max bonus cap
            if let maxBonus = bonus.maxBonus {
                bonusPoints = min(bonusPoints, maxBonus)
            }
            
            totalBonus += bonusPoints
        }
        
        return totalBonus
    }
    
    private static func getOlympiadBonus(olympiad: OlympiadResult, rule: BonusRule) -> Double {
        // Example implementation based on typical Polish university rules
        switch olympiad.level {
        case .centralWinner:
            return 200
        case .centralFinalist:
            return 100
        case .regionalWinner:
            return 50
        case .regionalFinalist:
            return 25
        }
    }
    
    private static func getCertificateBonus(certificate: Certificate, rule: BonusRule) -> Double {
        // Simplified certificate bonus calculation
        return rule.points
    }
    
    // MARK: - Requirements Checking
    
    private static func checkRequirements(formula: Formula, scores: ExtendedScores) -> (Bool, String?) {
        guard let requirements = formula.requirements else { return (true, nil) }
        
        // Check mandatory subjects
        if let mandatorySubjects = requirements.mandatorySubjects {
            for subject in mandatorySubjects {
                let score = getBaseMaturaScore(subject: subject, level: "R", scores: scores.maturaScores)
                if score == 0 {
                    let extendedScore = getBaseMaturaScore(subject: subject, level: "P", scores: scores.maturaScores)
                    if extendedScore == 0 {
                        return (false, "Brak wymaganego przedmiotu: \(subject)")
                    }
                }
            }
        }
        
        // Check minimum scores
        if let minimumScores = requirements.minimumScores {
            for (subject, minScore) in minimumScores {
                let score = getBaseMaturaScore(subject: subject, level: "R", scores: scores.maturaScores)
                if score < minScore {
                    return (false, "Zbyt niski wynik z \(subject): \(score) < \(minScore)")
                }
            }
        }
        
        // Check practical test requirement
        if requirements.practicalTestRequired && scores.practicalExams == nil {
            return (false, "Wymagany egzamin praktyczny")
        }
        
        return (true, nil)
    }
    
    // MARK: - Threshold Checking
    
    private static func checkThreshold(score: Double, threshold: Threshold, maxScore: Double) -> Bool {
        switch threshold.type {
        case .minimum:
            return score >= threshold.value
            
        case .percentage:
            return score >= (maxScore * threshold.value / 100)
            
        case .ranking, .multiplier:
            // These require comparing with other candidates
            return true // Assume passed for now
        }
    }
    
    // MARK: - Conversion Support
    
    static func convertIBScore(grade: Int) -> Double {
        // IB grades are 1-7, convert to Polish 0-100 scale
        return Double(grade) * 100.0 / 7.0
    }
    
    static func convertEBScore(grade: Double) -> Double {
        // EB grades are 1-10, convert to Polish 0-100 scale
        return grade * 10.0
    }
}