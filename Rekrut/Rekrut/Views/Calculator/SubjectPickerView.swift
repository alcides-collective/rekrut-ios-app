//
//  SubjectPickerView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct SubjectPickerView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @State private var selectedCategory = "Przedmioty obowiązkowe"
    @State private var selectedSubject: MaturaSubject = .polish
    @State private var selectedLevel: MaturaLevel = .basic
    @State private var scorePercentage: Double = 50
    @Environment(\.dismiss) private var dismiss
    
    let categories = [
        "Przedmioty obowiązkowe",
        "Nauki ścisłe",
        "Nauki humanistyczne",
        "Języki obce",
        "Przedmioty artystyczne"
    ]
    
    var subjectsInCategory: [MaturaSubject] {
        MaturaSubject.allCases.filter { $0.category == selectedCategory }
    }
    
    var isValidSelection: Bool {
        // For mandatory subjects, check if level is appropriate
        if selectedSubject.isMandatory {
            switch selectedSubject {
            case .polish, .mathematics:
                return true // Both levels allowed
            case .foreignLanguage:
                return true // Both levels allowed for primary foreign language
            default:
                return true
            }
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kategoria przedmiotu")) {
                    Picker("Kategoria", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedCategory) { _ in
                        if let firstSubject = subjectsInCategory.first {
                            selectedSubject = firstSubject
                        }
                    }
                }
                
                Section(header: Text("Przedmiot")) {
                    Picker("Przedmiot", selection: $selectedSubject) {
                        ForEach(subjectsInCategory, id: \.self) { subject in
                            Text(subject.rawValue).tag(subject)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Poziom")) {
                    Picker("Poziom", selection: $selectedLevel) {
                        ForEach(MaturaLevel.allCases, id: \.self) { level in
                            HStack {
                                Text(level.rawValue)
                                Text("(\(level.shortName))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedSubject.isMandatory {
                        Text("Przedmiot obowiązkowy na maturze")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Section(header: HStack {
                    Text("Wynik: \(Int(scorePercentage))%")
                    Spacer()
                    if scorePercentage >= 30 {
                        Text("Zdany")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("Niezdany")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }) {
                    VStack(spacing: 12) {
                        Slider(value: $scorePercentage, in: 0...100, step: 1)
                            .accentColor(scorePercentage >= 30 ? .blue : .red)
                        
                        HStack {
                            Text("0%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("30%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("100%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if scorePercentage < 30 && selectedSubject.isMandatory {
                            Label("Minimum 30% wymagane do zdania", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Section(footer: Text("Wyniki matury należy wprowadzić zgodnie ze świadectwem maturalnym")) {
                    Button(action: {
                        viewModel.addScore(
                            subject: selectedSubject,
                            level: selectedLevel,
                            percentage: scorePercentage
                        )
                        dismiss()
                    }) {
                        Text("Dodaj wynik")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .disabled(!isValidSelection)
                }
            }
            .navigationTitle("Dodaj przedmiot maturalny")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let firstSubject = subjectsInCategory.first {
                selectedSubject = firstSubject
            }
        }
    }
}

#Preview {
    SubjectPickerView(viewModel: CalculatorViewModel())
}