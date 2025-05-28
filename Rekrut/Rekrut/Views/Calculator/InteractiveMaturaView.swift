//
//  InteractiveMaturaView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI
import UIKit

struct InteractiveMaturaView: View {
    @State private var basicScores: [String: Double] = [:]
    @State private var extendedScores: [String: Double] = [:]
    @State private var totalPoints: Double = 0
    
    // Przedmioty obowiązkowe (podstawowy + opcjonalnie rozszerzony)
    let mandatorySubjects = [
        SubjectInfo(name: "Język polski", id: "polish", icon: "📚", color: .blue, 
                   quote: "\"Polacy nie gęsi, iż swój język mają\" — M. Rej"),
        SubjectInfo(name: "Matematyka", id: "math", icon: "🔢", color: .purple,
                   quote: "\"Matematyka jest królową nauk\" — C.F. Gauss"),
        SubjectInfo(name: "Język obcy", id: "foreign", icon: "🌍", color: .green,
                   quote: "\"Granice mojego języka są granicami mojego świata\" — L. Wittgenstein")
    ]
    
    // Przedmioty dodatkowe (tylko rozszerzony)
    let additionalSubjects = [
        SubjectInfo(name: "Biologia", id: "bio", icon: "🌿", color: .green,
                   quote: "\"Nic w biologii nie ma sensu, jeśli nie patrzy się przez pryzmat ewolucji\" — T. Dobzhansky"),
        SubjectInfo(name: "Chemia", id: "chem", icon: "🧪", color: .orange,
                   quote: "\"Chemia jest mostem między fizyką a biologią\" — L. Pauling"),
        SubjectInfo(name: "Fizyka", id: "phys", icon: "⚛️", color: .yellow,
                   quote: "\"Fizyka jest jak seks: może dać praktyczne rezultaty, ale nie dlatego ją uprawiamy\" — R. Feynman"),
        SubjectInfo(name: "Geografia", id: "geo", icon: "🗺️", color: .brown,
                   quote: "\"Geografia jest nauką o miejscach, a nie o nazwach\" — E. Romer"),
        SubjectInfo(name: "Historia", id: "hist", icon: "📜", color: .red,
                   quote: "\"Historia jest nauczycielką życia\" — Cyceron"),
        SubjectInfo(name: "WOS", id: "wos", icon: "🏛️", color: .purple,
                   quote: "\"Człowiek jest istotą społeczną\" — Arystoteles"),
        SubjectInfo(name: "Informatyka", id: "info", icon: "💻", color: .blue,
                   quote: "\"Informatyka nie dotyczy komputerów bardziej niż astronomia teleskopów\" — E. Dijkstra"),
        SubjectInfo(name: "Filozofia", id: "filo", icon: "🤔", color: .indigo,
                   quote: "\"Wiem, że nic nie wiem\" — Sokrates"),
        SubjectInfo(name: "Historia sztuki", id: "art", icon: "🎨", color: .pink,
                   quote: "\"Sztuka jest kłamstwem, które pozwala nam zrozumieć prawdę\" — P. Picasso"),
        SubjectInfo(name: "Historia muzyki", id: "music", icon: "🎵", color: .orange,
                   quote: "\"Muzyka jest arytmetyką dźwięków\" — C. Debussy"),
        SubjectInfo(name: "J. łaciński", id: "latin", icon: "🏛️", color: .brown,
                   quote: "\"Verba volant, scripta manent\""),
        SubjectInfo(name: "J. białoruski", id: "belarus", icon: "🇧🇾", color: .red,
                   quote: nil),
        SubjectInfo(name: "J. litewski", id: "lithuanian", icon: "🇱🇹", color: .green,
                   quote: nil),
        SubjectInfo(name: "J. niemiecki", id: "german_minority", icon: "🇩🇪", color: .gray,
                   quote: nil),
        SubjectInfo(name: "J. ukraiński", id: "ukrainian", icon: "🇺🇦", color: .blue,
                   quote: nil),
        SubjectInfo(name: "J. kaszubski", id: "kashubian", icon: "⚓", color: .indigo,
                   quote: nil),
        SubjectInfo(name: "J. obcy dodatkowy", id: "foreign_additional", icon: "🗣️", color: .cyan,
                   quote: nil)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Simple header with points
                SimpleMaturaHeader(
                    totalPoints: totalPoints
                )
                
                // Basic level section
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Poziom podstawowy")
                            .font(.headline)
                        Text("Obowiązkowe dla wszystkich")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 4)
                    
                    VStack(spacing: 10) {
                        ForEach(mandatorySubjects) { subject in
                            CardStyleSlider(
                                subject: subject,
                                score: Binding(
                                    get: { basicScores[subject.id] ?? 0 },
                                    set: { newValue in
                                        basicScores[subject.id] = newValue
                                        calculateResults()
                                    }
                                ),
                                isExtended: false
                            )
                        }
                    }
                }
                
                // Extended level section - all subjects together
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Poziom rozszerzony")
                            .font(.headline)
                        Text("Minimum 1 przedmiot wymagany")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 4)
                    
                    VStack(spacing: 10) {
                        // Mandatory subjects first
                        ForEach(mandatorySubjects) { subject in
                            CardStyleSlider(
                                subject: subject,
                                score: Binding(
                                    get: { extendedScores[subject.id] ?? 0 },
                                    set: { newValue in
                                        extendedScores[subject.id] = newValue
                                        calculateResults()
                                    }
                                ),
                                isExtended: true
                            )
                        }
                        
                        // Additional subjects
                        ForEach(additionalSubjects) { subject in
                            CardStyleSlider(
                                subject: subject,
                                score: Binding(
                                    get: { extendedScores[subject.id] ?? 0 },
                                    set: { newValue in
                                        extendedScores[subject.id] = newValue
                                        calculateResults()
                                    }
                                ),
                                isExtended: true,
                                isOptional: true
                            )
                        }
                    }
                }
                
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Kalkulator Maturalny")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            initializeScores()
            calculateResults()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Gotowe") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
    
    private func initializeScores() {
        // Initialize with some default values for better UX
        for subject in mandatorySubjects {
            if basicScores[subject.id] == nil {
                basicScores[subject.id] = 0
            }
        }
    }
    
    private func calculateResults() {
        var points = 0.0
        
        // Basic level calculation
        for subject in mandatorySubjects {
            points += (basicScores[subject.id] ?? 0) * 0.1
        }
        
        // Extended level calculation
        for subject in mandatorySubjects {
            let multiplier = subject.id == "math" ? 0.35 : 0.3
            points += (extendedScores[subject.id] ?? 0) * multiplier
        }
        
        // Best additional subject (highest score)
        var bestAdditionalScore = 0.0
        for subject in additionalSubjects {
            bestAdditionalScore = max(bestAdditionalScore, extendedScores[subject.id] ?? 0)
        }
        points += bestAdditionalScore * 0.2
        
        totalPoints = points
    }
}

struct SubjectInfo: Identifiable {
    let name: String
    let id: String
    let icon: String
    let color: Color
    let quote: String?
}


struct CardStyleSlider: View {
    let subject: SubjectInfo
    @Binding var score: Double
    let isExtended: Bool
    var isOptional: Bool = false
    @State private var textValue: String = ""
    
    var body: some View {
        HStack(spacing: 12) {
            // Box with progress
            ZStack {
                // White background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 80)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Colored progress overlay
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(getColor())
                        .frame(width: geo.size.width * (score / 100), height: 80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Text content - we need two layers for the split effect
                ZStack {
                    // Black text and colorful emoji on white background
                    HStack(spacing: 12) {
                        Text(subject.icon)
                            .font(.system(size: 32))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(subject.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            if let quote = getQuote() {
                                Text(quote)
                                    .font(.caption2)
                                    .italic()
                                    .lineLimit(2)
                            } else if isOptional {
                                Text("Przedmiot dodatkowy")
                                    .font(.caption2)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .foregroundColor(.black)
                    
                    // White text and monochrome emoji on colored background
                    HStack(spacing: 12) {
                        Text(subject.icon)
                            .font(.system(size: 32))
                            .grayscale(1)
                            .brightness(0.3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(subject.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            if let quote = getQuote() {
                                Text(quote)
                                    .font(.caption2)
                                    .italic()
                                    .lineLimit(2)
                            } else if isOptional {
                                Text("Przedmiot dodatkowy")
                                    .font(.caption2)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .mask(
                        GeometryReader { geo in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .frame(width: geo.size.width * (score / 100))
                                Spacer()
                            }
                        }
                    )
                }
            }
            .frame(height: 80)
            
            // Text input field with fixed width for 3 digits
            HStack(spacing: 2) {
                ZStack(alignment: .trailing) {
                    // Placeholder when empty
                    if textValue.isEmpty {
                        Text("—")
                            .font(.system(size: 24, weight: .regular, design: .monospaced))
                            .foregroundColor(.gray.opacity(0.5))
                            .frame(width: 55, height: 50)
                    }
                    
                    TextField("", text: $textValue)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                        .frame(width: 55, height: 50)
                        .onChange(of: textValue) { newValue in
                            // Only allow numbers
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue {
                                textValue = filtered
                            }
                            
                            // Convert to Double and clamp to 0-100
                            if let value = Double(filtered) {
                                if value > 100 {
                                    textValue = "100"
                                    score = 100
                                } else {
                                    score = value
                                }
                            } else if filtered.isEmpty {
                                score = 0
                            }
                        }
                }
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                Text("%")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom, 4)
        .onAppear {
            // Initialize text value from score
            if score > 0 {
                textValue = String(Int(score))
            }
        }
        .onChange(of: score) { newValue in
            // Update text when score changes externally
            if newValue == 0 {
                textValue = ""
            } else {
                let intValue = Int(newValue)
                if textValue != String(intValue) {
                    textValue = String(intValue)
                }
            }
        }
    }
    
    func getColor() -> Color {
        if score < 30 {
            return Color(red: 0.9, green: 0.4, blue: 0.4)
        } else if score < 70 {
            let progress = (score - 30) / 40
            return Color(
                red: 0.9 - (progress * 0.4),
                green: 0.8,
                blue: 0.3 - (progress * 0.3)
            )
        } else {
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        }
    }
    
    func getQuote() -> String? {
        if !isExtended {
            return subject.quote
        }
        
        switch subject.id {
        case "polish":
            return "\"Czucie i wiara silniej mówi do mnie niż mędrca szkiełko i oko\" — A. Mickiewicz"
        case "math":
            return "\"Matematyk to taki człowiek, który potrafi znaleźć analogie między twierdzeniami\" — S. Banach"
        case "foreign":
            return "\"Kto zna dwa języki, żyje dwa razy\" — przysłowie czeskie"
        default:
            return subject.quote
        }
    }
}

// Removed SimplifiedAdditionalSubject as subjects are now listed directly

struct SimpleMaturaHeader: View {
    let totalPoints: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(Int(totalPoints))")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.blue)
            
            Text("punktów rekrutacyjnych")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}


#Preview {
    NavigationView {
        InteractiveMaturaView()
    }
}