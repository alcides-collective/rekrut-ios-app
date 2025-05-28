//
//  SimpleMaturaCalculatorView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct SimpleMaturaCalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showingProgramSelection = false
    @State private var showingResults = false
    @State private var maturaScores: [String: String] = [:]
    @State private var expandedExtendedScores = false
    @State private var selectedAdditionalSubjects: Set<MaturaSubject> = []
    
    let mandatorySubjects: [(subject: MaturaSubject, levels: [MaturaLevel])] = [
        (.polish, [.basic, .extended]),
        (.mathematics, [.basic, .extended]),
        (.foreignLanguage, [.basic, .extended])
    ]
    
    let additionalSubjects: [(subject: MaturaSubject, levels: [MaturaLevel])] = [
        (.biology, [.extended]),
        (.chemistry, [.extended]),
        (.physics, [.extended]),
        (.computerScience, [.extended]),
        (.history, [.extended]),
        (.geography, [.extended]),
        (.civics, [.extended])
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Compact header
            headerView
            
            // Main content
            ScrollView {
                VStack(spacing: 16) {
                    // Compact instructions
                    instructionView
                    
                    // Mandatory subjects - Basic scores in one row
                    mandatoryBasicScoresView
                    
                    // Extended scores (collapsible)
                    extendedScoresView
                    
                    // Additional subjects
                    additionalSubjectsView
                }
                .padding()
            }
            
            // Calculate button
            calculateButton
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingProgramSelection) {
            ProgramSelectionView(selectedPrograms: $viewModel.selectedPrograms)
        }
        .sheet(isPresented: $showingResults) {
            CalculationResultsView(results: viewModel.calculationResults)
        }
        .onAppear {
            loadExistingScores()
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Kalkulator Maturalny")
                    .font(.title2)
                    .bold()
                
                if viewModel.selectedPrograms.isEmpty {
                    Text("Wybierz kierunki")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("\(viewModel.selectedPrograms.count) \(viewModel.selectedPrograms.count == 1 ? "kierunek" : "kierunki")")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Button(action: { showingProgramSelection = true }) {
                HStack(spacing: 4) {
                    Text(viewModel.selectedPrograms.isEmpty ? "Wybierz" : "Zmień")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private var instructionView: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle.fill")
                .font(.caption2)
                .foregroundColor(.blue)
            
            Text("Wprowadź wyniki procentowe (0-100%)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    private var mandatoryBasicScoresView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
                Text("Przedmioty obowiązkowe - Poziom podstawowy")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            // Horizontal scroll for basic scores
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(mandatorySubjects, id: \.subject) { item in
                        CompactScoreInput(
                            subject: item.subject,
                            level: .basic,
                            scores: $maturaScores
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var extendedScoresView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { withAnimation(.spring(response: 0.3)) { expandedExtendedScores.toggle() } }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Poziom rozszerzony (opcjonalnie)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Wypełnij jeśli zdawałeś")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: expandedExtendedScores ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if expandedExtendedScores {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(mandatorySubjects, id: \.subject) { item in
                            CompactScoreInput(
                                subject: item.subject,
                                level: .extended,
                                scores: $maturaScores,
                                isOptional: true
                            )
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var additionalSubjectsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Przedmioty dodatkowe")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Wybierz i wypełnij tylko te, które zdawałeś")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Subject selection chips
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                ForEach(additionalSubjects, id: \.subject) { item in
                    SubjectChip(
                        subject: item.subject,
                        isSelected: selectedAdditionalSubjects.contains(item.subject),
                        onTap: {
                            withAnimation(.spring(response: 0.3)) {
                                if selectedAdditionalSubjects.contains(item.subject) {
                                    selectedAdditionalSubjects.remove(item.subject)
                                    // Clear score when deselected
                                    let key = "\(item.subject.rawValue)_\(MaturaLevel.extended.rawValue)"
                                    maturaScores[key] = ""
                                } else {
                                    selectedAdditionalSubjects.insert(item.subject)
                                }
                            }
                        }
                    )
                }
            }
            
            // Score inputs for selected subjects
            if !selectedAdditionalSubjects.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(selectedAdditionalSubjects.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { subject in
                            CompactScoreInput(
                                subject: subject,
                                level: .extended,
                                scores: $maturaScores,
                                isOptional: true
                            )
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var calculateButton: some View {
        VStack(spacing: 0) {
            Divider()
            
            Button(action: {
                saveScoresToViewModel()
                Task {
                    await viewModel.calculatePoints()
                    showingResults = true
                }
            }) {
                HStack {
                    if viewModel.isCalculating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Oblicz punkty")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(viewModel.selectedPrograms.isEmpty || !hasAnyScores() ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(viewModel.selectedPrograms.isEmpty || !hasAnyScores() || viewModel.isCalculating)
            .padding()
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Methods
    
    private func hasAnyScores() -> Bool {
        !maturaScores.values.filter { !$0.isEmpty }.isEmpty
    }
    
    private func saveScoresToViewModel() {
        viewModel.maturaScores.subjects.removeAll()
        
        for (key, value) in maturaScores {
            guard !value.isEmpty, let percentage = Double(value) else { continue }
            
            let parts = key.split(separator: "_")
            guard parts.count == 2,
                  let subject = MaturaSubject.allCases.first(where: { $0.rawValue == String(parts[0]) }),
                  let level = MaturaLevel.allCases.first(where: { $0.rawValue == String(parts[1]) }) else { continue }
            
            viewModel.addScore(subject: subject, level: level, percentage: percentage)
        }
    }
    
    private func loadExistingScores() {
        for score in viewModel.maturaScores.subjects {
            let key = "\(score.subject.rawValue)_\(score.level.rawValue)"
            maturaScores[key] = String(Int(score.scorePercentage))
            
            // Also update selected additional subjects
            if !score.subject.isMandatory {
                selectedAdditionalSubjects.insert(score.subject)
            }
        }
    }
}

// MARK: - Component Views

struct CompactScoreInput: View {
    let subject: MaturaSubject
    let level: MaturaLevel
    @Binding var scores: [String: String]
    var isOptional: Bool = false
    @FocusState private var isFocused: Bool
    
    var key: String {
        "\(subject.rawValue)_\(level.rawValue)"
    }
    
    var score: Binding<String> {
        Binding(
            get: { scores[key] ?? "" },
            set: { scores[key] = $0 }
        )
    }
    
    var scoreValue: Double? {
        Double(score.wrappedValue)
    }
    
    var isValid: Bool {
        guard let value = scoreValue else { return true }
        return value >= 0 && value <= 100
    }
    
    var isPassing: Bool {
        guard let value = scoreValue else { return true }
        return value >= 30
    }
    
    var subjectShortName: String {
        switch subject {
        case .polish: return "Polski"
        case .mathematics: return "Matma"
        case .foreignLanguage: return "J. obcy"
        case .biology: return "Biologia"
        case .chemistry: return "Chemia"
        case .physics: return "Fizyka"
        case .computerScience: return "Informatyka"
        case .history: return "Historia"
        case .geography: return "Geografia"
        case .civics: return "WOS"
        default: return String(subject.rawValue.prefix(8))
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 2) {
                Text(subjectShortName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                if isOptional {
                    Text(level.shortName)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 2) {
                TextField("—", text: score)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .focused($isFocused)
                    .onChange(of: score.wrappedValue) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            score.wrappedValue = filtered
                        }
                        
                        if let value = Int(filtered), value > 100 {
                            score.wrappedValue = "100"
                        }
                    }
                
                Text("%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(getBorderColor(), lineWidth: isFocused ? 2 : 1)
            )
            
            // Status indicator
            if !score.wrappedValue.isEmpty {
                statusIndicator
            }
        }
        .frame(width: 85)
    }
    
    private func getBorderColor() -> Color {
        if isFocused { return .blue }
        if !score.wrappedValue.isEmpty {
            if !isValid { return .red }
            if subject.isMandatory && level == .basic && !isPassing { return .orange }
        }
        return Color(.systemGray4)
    }
    
    private var statusIndicator: some View {
        Group {
            if !isValid {
                Label("Błąd", systemImage: "exclamationmark.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.red)
            } else if subject.isMandatory && level == .basic && !isPassing {
                Label("<30%", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
        }
        .labelStyle(.iconOnly)
    }
}

struct SubjectChip: View {
    let subject: MaturaSubject
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption2)
                }
                Text(subject.rawValue)
                    .font(.caption)
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray5))
            .foregroundColor(isSelected ? .blue : .primary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        SimpleMaturaCalculatorView()
    }
}