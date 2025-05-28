//
//  CalculationResultsView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct CalculationResultsView: View {
    let results: [CalculatorViewModel.CalculationResult]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(results) { result in
                        ResultCard(result: result)
                    }
                }
                .padding()
            }
            .navigationTitle("Wyniki obliczeń")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zamknij") {
                        dismiss()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct ResultCard: View {
    let result: CalculatorViewModel.CalculationResult
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(result.program.name)
                    .font(.headline)
                
                Text(result.program.field)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Twoje punkty")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(result.points))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                if let threshold = result.program.lastYearThreshold {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Próg z zeszłego roku")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(Int(threshold))")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        if result.points >= threshold {
                            Label("Szansa", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        } else {
                            Label("Brak szans", systemImage: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Próg punktowy")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Brak danych")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        
                        Label("Sprawdź na stronie uczelni", systemImage: "info.circle")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Szczegóły obliczeń")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Wzór: \(result.formula)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(result.breakdown, id: \.subject) { component in
                        HStack {
                            Text(component.subject)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(Int(component.score))% × \(component.weight, specifier: "%.1f") = \(Int(component.points)) pkt")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
}

#Preview {
    CalculationResultsView(results: [])
}