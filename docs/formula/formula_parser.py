#!/usr/bin/env python3
"""
Advanced Formula Parser for Complex Polish University Admissions
Compatible with Formula Swift model
"""

import json
from typing import Dict, List, Optional, Any, Tuple
from dataclasses import dataclass
from enum import Enum
from datetime import datetime


# MARK: - Enums

class FormulaType(Enum):
    SIMPLE = "simple"
    MULTI_STAGE = "multi_stage"
    CONDITIONAL = "conditional"
    MIXED = "mixed"


class ComponentType(Enum):
    MATURA_EXAM = "matura_exam"
    PRACTICAL_EXAM = "practical_exam"
    INTERVIEW = "interview"
    PORTFOLIO = "portfolio"
    PREVIOUS_DEGREE = "previous_degree"
    OLYMPIAD = "olympiad"
    CERTIFICATE = "certificate"


class OperationType(Enum):
    MAX = "max"
    MIN = "min"
    SUM = "sum"
    AVERAGE = "average"
    MULTIPLY = "multiply"
    DIVIDE = "divide"
    CONDITIONAL = "conditional"
    THRESHOLD = "threshold"


class ExamType(Enum):
    DRAWING = "drawing"
    SCULPTURE = "sculpture"
    APTITUDE = "aptitude"
    PHYSICAL = "physical"
    MUSICAL = "musical"
    PORTFOLIO = "portfolio"
    INTERVIEW = "interview"


class ThresholdType(Enum):
    MINIMUM = "minimum"
    PERCENTAGE = "percentage"
    RANKING = "ranking"
    MULTIPLIER = "multiplier"


class BonusType(Enum):
    OLYMPIAD = "olympiad"
    COMPETITION = "competition"
    CERTIFICATE = "certificate"
    VOLUNTEER = "volunteer"
    SPORTS = "sports"
    OTHER = "other"


class OlympiadLevel(Enum):
    CENTRAL_WINNER = "central_winner"
    CENTRAL_FINALIST = "central_finalist"
    REGIONAL_WINNER = "regional_winner"
    REGIONAL_FINALIST = "regional_finalist"


class ExamSystem(Enum):
    POLISH = "polish"
    IB = "ib"
    EB = "eb"
    FOREIGN = "foreign"


# MARK: - Data Classes

@dataclass
class LevelCoefficients:
    basic: Optional[float] = None
    extended: Optional[float] = None
    bilingual: Optional[float] = None
    international: Optional[float] = None


@dataclass
class FormulaComponent:
    id: str
    type: ComponentType
    weight: float
    required: bool
    subject: Optional[str] = None
    level: Optional[str] = None
    level_coefficients: Optional[LevelCoefficients] = None
    alternatives: Optional[List[str]] = None
    min_score: Optional[float] = None
    max_score: Optional[float] = None


@dataclass
class ExamTask:
    name: str
    points: float
    duration: Optional[int] = None


@dataclass
class PracticalExam:
    id: str
    name: str
    type: ExamType
    weight: float
    max_points: float
    tasks: Optional[List[ExamTask]] = None
    min_score: Optional[float] = None
    description: Optional[str] = None


@dataclass
class Operation:
    id: str
    type: OperationType
    component_ids: List[str]
    value: Optional[float] = None
    result_id: Optional[str] = None


@dataclass
class Threshold:
    type: ThresholdType
    value: float
    description: Optional[str] = None


@dataclass
class BonusRule:
    id: str
    type: BonusType
    condition: str
    points: float
    multiplier: Optional[float] = None
    max_bonus: Optional[float] = None


@dataclass
class FormulaRequirements:
    mandatory_subjects: Optional[List[str]] = None
    minimum_scores: Optional[Dict[str, float]] = None
    practical_test_required: bool = False
    interview_required: bool = False
    portfolio_required: bool = False
    previous_degree_required: bool = False


@dataclass
class FormulaMetadata:
    description: str
    max_possible_score: float
    scoring_unit: str
    last_year_threshold: Optional[float] = None
    average_threshold: Optional[float] = None
    official_calculator_url: Optional[str] = None
    notes: Optional[str] = None
    last_updated: Optional[datetime] = None


@dataclass
class FormulaStage:
    id: str
    name: str
    components: List[FormulaComponent]
    max_points: float
    operations: Optional[List[Operation]] = None
    practical_exams: Optional[List[PracticalExam]] = None
    threshold: Optional[Threshold] = None
    coefficient: Optional[float] = None


@dataclass
class Formula:
    version: str
    university_id: str
    program_id: str
    type: FormulaType
    stages: List[FormulaStage]
    metadata: FormulaMetadata
    bonuses: Optional[List[BonusRule]] = None
    requirements: Optional[FormulaRequirements] = None


# MARK: - Extended Scores

@dataclass
class MaturaScores:
    """Polish Matura exam scores"""
    mathematics: Optional[int] = None
    mathematics_basic: Optional[int] = None
    polish: Optional[int] = None
    polish_basic: Optional[int] = None
    foreign_language: Optional[int] = None
    foreign_language_basic: Optional[int] = None
    physics: Optional[int] = None
    chemistry: Optional[int] = None
    biology: Optional[int] = None
    computer_science: Optional[int] = None
    geography: Optional[int] = None
    history: Optional[int] = None
    social_studies: Optional[int] = None


@dataclass
class OlympiadResult:
    name: str
    level: OlympiadLevel
    subject: str


@dataclass
class Certificate:
    type: str
    level: Optional[str] = None
    score: Optional[float] = None


@dataclass
class ExtendedScores:
    matura_scores: MaturaScores
    practical_exams: Optional[Dict[str, float]] = None
    interview_score: Optional[float] = None
    portfolio_score: Optional[float] = None
    previous_degree_gpa: Optional[float] = None
    olympiad_results: Optional[List[OlympiadResult]] = None
    certificates: Optional[List[Certificate]] = None
    is_bilingual: bool = False
    exam_system: ExamSystem = ExamSystem.POLISH


@dataclass
class StageResult:
    stage_id: str
    stage_name: str
    score: float
    max_score: float
    passed: bool
    component_scores: Dict[str, float]


@dataclass
class CalculationResult:
    total_score: float
    stage_results: List[StageResult]
    bonus_points: float
    meets_requirements: bool
    disqualification_reason: Optional[str] = None
    breakdown: Optional[Dict[str, float]] = None


# MARK: - Advanced Calculator

class AdvancedFormulaCalculator:
    """Calculator for complex Polish university admission formulas"""
    
    def __init__(self):
        self.subject_mappings = {
            "MAT": "mathematics",
            "POL": "polish",
            "J.POL": "polish",
            "ANG": "foreign_language",
            "J.OBC": "foreign_language",
            "FIZ": "physics",
            "CHEM": "chemistry",
            "CHE": "chemistry",
            "BIO": "biology",
            "INF": "computer_science",
            "GEO": "geography",
            "HIS": "history",
            "HIST": "history",
            "WOS": "social_studies",
        }
    
    def calculate(self, formula: Formula, scores: ExtendedScores) -> CalculationResult:
        """Calculate admission points using advanced formula"""
        
        # Check requirements first
        meets_reqs, reason = self._check_requirements(formula, scores)
        if not meets_reqs:
            return CalculationResult(
                total_score=0,
                stage_results=[],
                bonus_points=0,
                meets_requirements=False,
                disqualification_reason=reason
            )
        
        stage_results = []
        total_score = 0
        breakdown = {}
        
        # Calculate each stage
        for stage in formula.stages:
            stage_result = self._calculate_stage(stage, scores, formula)
            stage_results.append(stage_result)
            
            # Check if passed this stage
            if stage.threshold and not self._check_threshold(
                stage_result.score, stage.threshold, stage.max_points
            ):
                break  # Failed to meet threshold
            
            # Add to total with coefficient
            coefficient = stage.coefficient or 1.0
            total_score += stage_result.score * coefficient
            
            # Merge breakdowns
            for key, value in stage_result.component_scores.items():
                breakdown[f"{stage.id}_{key}"] = value
        
        # Calculate bonuses
        bonus_points = 0
        if formula.bonuses:
            bonus_points = self._calculate_bonuses(formula.bonuses, scores)
            total_score += bonus_points
        
        # Cap at maximum
        total_score = min(total_score, formula.metadata.max_possible_score)
        
        return CalculationResult(
            total_score=total_score,
            stage_results=stage_results,
            bonus_points=bonus_points,
            meets_requirements=True,
            breakdown=breakdown
        )
    
    def _calculate_stage(
        self, stage: FormulaStage, scores: ExtendedScores, formula: Formula
    ) -> StageResult:
        """Calculate score for a single stage"""
        component_scores = {}
        
        # Calculate each component
        for component in stage.components:
            score = self._calculate_component(component, scores, stage)
            component_scores[component.id] = score
        
        # Apply operations
        if stage.operations:
            for operation in stage.operations:
                result = self._apply_operation(operation, component_scores)
                if operation.result_id:
                    component_scores[operation.result_id] = result
        
        # Calculate total
        stage_score = sum(component_scores.values())
        
        # Check if passed
        passed = True
        if stage.threshold:
            passed = self._check_threshold(stage_score, stage.threshold, stage.max_points)
        
        return StageResult(
            stage_id=stage.id,
            stage_name=stage.name,
            score=stage_score,
            max_score=stage.max_points,
            passed=passed,
            component_scores=component_scores
        )
    
    def _calculate_component(
        self, component: FormulaComponent, scores: ExtendedScores, stage: FormulaStage
    ) -> float:
        """Calculate score for a single component"""
        base_score = 0
        
        if component.type == ComponentType.MATURA_EXAM:
            base_score = self._get_matura_score(
                component.subject or "",
                component.level or "R",
                scores.matura_scores,
                component.level_coefficients,
                scores.is_bilingual
            )
        elif component.type == ComponentType.PRACTICAL_EXAM:
            if scores.practical_exams and component.id in scores.practical_exams:
                base_score = scores.practical_exams[component.id]
        elif component.type == ComponentType.INTERVIEW:
            base_score = scores.interview_score or 0
        elif component.type == ComponentType.PORTFOLIO:
            base_score = scores.portfolio_score or 0
        elif component.type == ComponentType.PREVIOUS_DEGREE:
            if scores.previous_degree_gpa:
                base_score = scores.previous_degree_gpa * 10
        
        # Apply weight
        weighted_score = base_score * component.weight
        
        # Check constraints
        if component.min_score and weighted_score < component.min_score:
            return 0
        
        if component.max_score:
            return min(weighted_score, component.max_score * component.weight)
        
        return weighted_score
    
    def _get_matura_score(
        self,
        subject: str,
        level: str,
        scores: MaturaScores,
        level_coefficients: Optional[LevelCoefficients],
        is_bilingual: bool
    ) -> float:
        """Get Matura exam score with level coefficients"""
        
        # Get base score
        base_score = self._get_base_matura_score(subject, level, scores)
        
        # Apply level coefficient
        if level_coefficients:
            coefficient = 1.0
            if is_bilingual and level_coefficients.bilingual:
                coefficient = level_coefficients.bilingual
            elif level == "R" and level_coefficients.extended:
                coefficient = level_coefficients.extended
            elif level == "P" and level_coefficients.basic:
                coefficient = level_coefficients.basic
            
            return base_score * coefficient
        
        return base_score
    
    def _get_base_matura_score(
        self, subject: str, level: str, scores: MaturaScores
    ) -> float:
        """Get base Matura score for subject"""
        
        # Map subject to score attribute
        attr_name = self.subject_mappings.get(subject, subject.lower())
        
        if level == "P" and hasattr(scores, f"{attr_name}_basic"):
            score = getattr(scores, f"{attr_name}_basic", None)
        else:
            score = getattr(scores, attr_name, None)
        
        return float(score) if score is not None else 0
    
    def _apply_operation(
        self, operation: Operation, component_scores: Dict[str, float]
    ) -> float:
        """Apply operation to component scores"""
        values = [component_scores.get(cid, 0) for cid in operation.component_ids]
        
        if operation.type == OperationType.MAX:
            return max(values) if values else 0
        elif operation.type == OperationType.MIN:
            return min(values) if values else 0
        elif operation.type == OperationType.SUM:
            return sum(values)
        elif operation.type == OperationType.AVERAGE:
            return sum(values) / len(values) if values else 0
        elif operation.type == OperationType.MULTIPLY:
            product = 1
            for v in values:
                product *= v
            return product * (operation.value or 1.0)
        elif operation.type == OperationType.DIVIDE:
            return sum(values) / (operation.value or 1.0)
        elif operation.type == OperationType.THRESHOLD:
            value = values[0] if values else 0
            threshold = operation.value or 0
            return value if value >= threshold else 0
        
        return 0
    
    def _calculate_bonuses(
        self, bonuses: List[BonusRule], scores: ExtendedScores
    ) -> float:
        """Calculate total bonus points"""
        total_bonus = 0
        
        for bonus in bonuses:
            bonus_points = 0
            
            if bonus.type == BonusType.OLYMPIAD and scores.olympiad_results:
                for olympiad in scores.olympiad_results:
                    bonus_points += self._get_olympiad_bonus(olympiad)
            elif bonus.type == BonusType.CERTIFICATE and scores.certificates:
                for cert in scores.certificates:
                    bonus_points += bonus.points
            else:
                bonus_points = bonus.points
            
            # Apply cap
            if bonus.max_bonus:
                bonus_points = min(bonus_points, bonus.max_bonus)
            
            total_bonus += bonus_points
        
        return total_bonus
    
    def _get_olympiad_bonus(self, olympiad: OlympiadResult) -> float:
        """Get bonus points for olympiad result"""
        bonuses = {
            OlympiadLevel.CENTRAL_WINNER: 200,
            OlympiadLevel.CENTRAL_FINALIST: 100,
            OlympiadLevel.REGIONAL_WINNER: 50,
            OlympiadLevel.REGIONAL_FINALIST: 25
        }
        return bonuses.get(olympiad.level, 0)
    
    def _check_requirements(
        self, formula: Formula, scores: ExtendedScores
    ) -> Tuple[bool, Optional[str]]:
        """Check if candidate meets requirements"""
        if not formula.requirements:
            return True, None
        
        reqs = formula.requirements
        
        # Check mandatory subjects
        if reqs.mandatory_subjects:
            for subject in reqs.mandatory_subjects:
                score = self._get_base_matura_score(subject, "R", scores.matura_scores)
                if score == 0:
                    score = self._get_base_matura_score(subject, "P", scores.matura_scores)
                    if score == 0:
                        return False, f"Missing required subject: {subject}"
        
        # Check minimum scores
        if reqs.minimum_scores:
            for subject, min_score in reqs.minimum_scores.items():
                score = self._get_base_matura_score(subject, "R", scores.matura_scores)
                if score < min_score:
                    return False, f"Score too low for {subject}: {score} < {min_score}"
        
        # Check practical test
        if reqs.practical_test_required and not scores.practical_exams:
            return False, "Practical exam required"
        
        return True, None
    
    def _check_threshold(
        self, score: float, threshold: Threshold, max_score: float
    ) -> bool:
        """Check if score meets threshold"""
        if threshold.type == ThresholdType.MINIMUM:
            return score >= threshold.value
        elif threshold.type == ThresholdType.PERCENTAGE:
            return score >= (max_score * threshold.value / 100)
        # For ranking/multiplier, assume passed
        return True
    
    def parse_formula_json(self, json_str: str) -> Formula:
        """Parse FormulaV2 from JSON"""
        data = json.loads(json_str)
        
        # Parse stages
        stages = []
        for stage_data in data['stages']:
            # Parse components
            components = []
            for comp_data in stage_data['components']:
                # Parse level coefficients
                level_coeffs = None
                if 'level_coefficients' in comp_data:
                    lc = comp_data['level_coefficients']
                    level_coeffs = LevelCoefficients(
                        basic=lc.get('basic'),
                        extended=lc.get('extended'),
                        bilingual=lc.get('bilingual'),
                        international=lc.get('international')
                    )
                
                components.append(FormulaComponent(
                    id=comp_data['id'],
                    type=ComponentType(comp_data['type']),
                    weight=comp_data['weight'],
                    required=comp_data['required'],
                    subject=comp_data.get('subject'),
                    level=comp_data.get('level'),
                    level_coefficients=level_coeffs,
                    alternatives=comp_data.get('alternatives'),
                    min_score=comp_data.get('min_score'),
                    max_score=comp_data.get('max_score')
                ))
            
            # Parse operations
            operations = None
            if 'operations' in stage_data:
                operations = []
                for op_data in stage_data['operations']:
                    operations.append(Operation(
                        id=op_data.get('id', ''),
                        type=OperationType(op_data['type']),
                        component_ids=op_data['component_ids'],
                        value=op_data.get('value'),
                        result_id=op_data.get('result_id')
                    ))
            
            # Parse threshold
            threshold = None
            if 'threshold' in stage_data:
                t = stage_data['threshold']
                threshold = Threshold(
                    type=ThresholdType(t['type']),
                    value=t['value'],
                    description=t.get('description')
                )
            
            stages.append(FormulaStage(
                id=stage_data['id'],
                name=stage_data['name'],
                components=components,
                max_points=stage_data['max_points'],
                operations=operations,
                threshold=threshold,
                coefficient=stage_data.get('coefficient')
            ))
        
        # Parse metadata
        meta_data = data['metadata']
        metadata = FormulaMetadata(
            description=meta_data['description'],
            max_possible_score=meta_data['max_possible_score'],
            scoring_unit=meta_data['scoring_unit'],
            last_year_threshold=meta_data.get('last_year_threshold'),
            average_threshold=meta_data.get('average_threshold'),
            official_calculator_url=meta_data.get('official_calculator_url'),
            notes=meta_data.get('notes')
        )
        
        return Formula(
            version=data['version'],
            university_id=data['university_id'],
            program_id=data['program_id'],
            type=FormulaType(data['type']),
            stages=stages,
            metadata=metadata
        )


# Example usage
if __name__ == "__main__":
    # Example: Warsaw Tech Architecture
    calculator = AdvancedFormulaCalculator()
    
    # Student scores
    scores = ExtendedScores(
        matura_scores=MaturaScores(
            mathematics=85,
            foreign_language=75,
            physics=80,
            history=70
        ),
        practical_exams={
            "psp": 140  # 70% of 200 points
        },
        is_bilingual=False
    )
    
    # This would normally be loaded from JSON
    print("Advanced Formula Calculator ready for complex Polish university admissions")