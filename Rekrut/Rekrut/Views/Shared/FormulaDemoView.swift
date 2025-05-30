//
//  FormulaDemoView.swift
//  Rekrut
//
//  Demo view showing LaTeX-like formula rendering
//

import SwiftUI

struct FormulaDemoView: View {
    let sampleFormulas = [
        "0.5 × matematyka (R) + 0.3 × fizyka (R) + 0.2 × język obcy (R)",
        "W = 0.4 * MAT_R + 0.3 * FIZ_R + 0.3 * INF_R",
        "0.6 × matematyka (R) + 0.4 × max(fizyka, chemia, informatyka) (R)",
        "matematyka (R) + 0.5 × język polski (P) + 0.3 × język obcy (R)",
        "0.25 × polski (R) + 0.25 × matematyka (R) + 0.25 × biologia (R) + 0.25 × chemia (R)",
        "max(matematyka, fizyka, informatyka) (R) + 0.5 × język obcy (R)"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Wzory rekrutacyjne")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Przykłady formatowania wzorów w stylu LaTeX")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Sample formulas
                    ForEach(sampleFormulas, id: \.self) { formula in
                        VStack(alignment: .leading, spacing: 12) {
                            // Original format
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Oryginalny format:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(formula)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            // LaTeX-like format
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Format matematyczny:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                FormulaCard(formula: formula)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                    }
                    
                    // Features explanation
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Funkcje formatowania")
                            .font(.headline)
                        
                        FeatureRow(
                            icon: "textformat.subscript",
                            title: "Poziomy przedmiotów",
                            description: "Automatyczne wykrywanie i formatowanie poziomów (R) i (P)"
                        )
                        
                        FeatureRow(
                            icon: "multiply.circle",
                            title: "Współczynniki",
                            description: "Wyświetlanie współczynników z odpowiednim formatowaniem"
                        )
                        
                        FeatureRow(
                            icon: "function",
                            title: "Funkcje matematyczne",
                            description: "Obsługa funkcji max() z wieloma argumentami"
                        )
                        
                        FeatureRow(
                            icon: "textformat",
                            title: "Formatowanie nazw",
                            description: "Automatyczne rozwijanie skrótów przedmiotów"
                        )
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    FormulaDemoView()
}