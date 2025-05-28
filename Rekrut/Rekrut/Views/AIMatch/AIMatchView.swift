//
//  AIMatchView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI
import UIKit

struct AIMatchView: View {
    @State private var hasStarted = false
    @State private var currentStep = 0
    @State private var answers: [String: Any] = [:]
    @State private var showingResults = false
    @StateObject private var firebaseService = FirebaseService.shared
    
    var body: some View {
        VStack {
            if !hasStarted {
                AIMatchStartView(hasStarted: $hasStarted)
            } else if showingResults {
                AIMatchResultsView(answers: answers)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Zacznij od nowa") {
                                withAnimation {
                                    currentStep = 0
                                    answers = [:]
                                    showingResults = false
                                    hasStarted = false
                                }
                            }
                        }
                    }
            } else {
                AIMatchQuestionnaireView(
                    currentStep: $currentStep,
                    answers: $answers,
                    showingResults: $showingResults
                )
            }
        }
        .background(Color.white)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var navigationTitle: String {
        if !hasStarted {
            return "AI Match"
        } else if showingResults {
            return "Twoje wyniki"
        } else {
            return "AI Match"
        }
    }
}

struct AIMatchStartView: View {
    @Binding var hasStarted: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated icon
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 16) {
                Text("Dopasowanie AI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Znajdź idealny kierunek studiów")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 20) {
                FeatureRow(
                    icon: "brain",
                    title: "Inteligentna analiza",
                    description: "AI analizuje Twoje odpowiedzi i preferencje"
                )
                
                FeatureRow(
                    icon: "target",
                    title: "Spersonalizowane wyniki",
                    description: "Otrzymasz kierunki dopasowane do Ciebie"
                )
                
                FeatureRow(
                    icon: "clock",
                    title: "11 prostych kroków",
                    description: "Krótki quiz, który może zmienić Twoją przyszłość"
                )
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    hasStarted = true
                }
            }) {
                HStack {
                    Text("Rozpocznij dopasowanie")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.blue)
                .font(.headline)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.white)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct AnimatedBackgroundShape: View {
    let progress: Double
    @State private var animationProgress: Double = 0
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/60)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate * 0.5 // Slower animation
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                
                // Apply blur to entire canvas first
                context.addFilter(.blur(radius: 80))
                
                // Create multiple organic shapes
                for i in 0..<3 {
                    let offset = Double(i) * 2.0
                    let scale = (0.3 + animationProgress * 0.7) * (1.0 + sin(time + offset) * 0.05)
                    let rotation = time * 0.2 + offset
                    
                    context.opacity = 0.6 - Double(i) * 0.1
                    
                    // Draw organic blob
                    var path = Path()
                    let points = 6
                    let baseRadius = min(size.width, size.height) * 0.4 * scale
                    
                    for j in 0..<points {
                        let angle = (Double(j) / Double(points)) * 2 * .pi + rotation
                        let radiusVariation = sin(time + Double(j) + offset) * 0.15 + 1
                        let radius = baseRadius * radiusVariation
                        
                        let x = center.x + cos(angle) * radius
                        let y = center.y + sin(angle) * radius
                        
                        if j == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            let controlAngle1 = ((Double(j - 1) + 0.33) / Double(points)) * 2 * .pi + rotation
                            let controlAngle2 = ((Double(j - 1) + 0.66) / Double(points)) * 2 * .pi + rotation
                            
                            let control1Radius = baseRadius * (sin(time + Double(j) - 0.33 + offset) * 0.15 + 1) * 1.1
                            let control2Radius = baseRadius * (sin(time + Double(j) - 0.66 + offset) * 0.15 + 1) * 1.1
                            
                            let control1X = center.x + cos(controlAngle1) * control1Radius
                            let control1Y = center.y + sin(controlAngle1) * control1Radius
                            let control2X = center.x + cos(controlAngle2) * control2Radius
                            let control2Y = center.y + sin(controlAngle2) * control2Radius
                            
                            path.addCurve(
                                to: CGPoint(x: x, y: y),
                                control1: CGPoint(x: control1X, y: control1Y),
                                control2: CGPoint(x: control2X, y: control2Y)
                            )
                        }
                    }
                    path.closeSubpath()
                    
                    // Apply gradient
                    let gradient = Gradient(colors: [
                        Color.purple,
                        Color.pink,
                        Color.blue
                    ])
                    
                    context.fill(
                        path,
                        with: .linearGradient(
                            gradient,
                            startPoint: CGPoint(x: 0, y: 0),
                            endPoint: CGPoint(x: size.width, y: size.height)
                        )
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animationProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeInOut(duration: 0.8)) {
                animationProgress = newValue
            }
        }
    }
}

struct AIMatchQuestionnaireView: View {
    @Binding var currentStep: Int
    @Binding var answers: [String: Any]
    @Binding var showingResults: Bool
    
    let totalSteps = 11 // Updated: 4 regular steps + 6 skill steps + 1 open question
    
    private func triggerHapticFeedback() {
        let intensity = min(Double(currentStep + 1) / Double(totalSteps), 1.0)
        
        if currentStep < 4 {
            // Light feedback for early questions
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.prepare()
            impact.impactOccurred()
        } else if currentStep < 8 {
            // Medium feedback for middle questions
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.prepare()
            impact.impactOccurred()
        } else if currentStep < 10 {
            // Heavy feedback for late questions
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.prepare()
            impact.impactOccurred()
        } else {
            // Climax effect for final question - multiple haptics
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.prepare()
            
            // Create crescendo effect
            for i in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                    impact.impactOccurred()
                }
            }
        }
    }
    
    private func triggerResultsHaptic() {
        // Special haptic pattern for results reveal
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        
        // Build anticipation
        let light = UIImpactFeedbackGenerator(style: .light)
        let medium = UIImpactFeedbackGenerator(style: .medium)
        let heavy = UIImpactFeedbackGenerator(style: .heavy)
        
        light.prepare()
        medium.prepare()
        heavy.prepare()
        
        // Crescendo pattern
        DispatchQueue.main.async {
            light.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            light.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            medium.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            medium.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            heavy.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            notification.notificationOccurred(.success)
        }
    }
    
    var body: some View {
        ZStack {
            // Animated background
            AnimatedBackgroundShape(progress: Double(currentStep) / Double(totalSteps - 1))
                .ignoresSafeArea()
                .opacity(0.4)
            
            VStack(spacing: 0) {
            // Navigation at the top
            ZStack {
                // Step counter - truly centered
                Text("Krok \(currentStep + 1) z \(totalSteps)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Navigation buttons on edges
                HStack {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation {
                                currentStep -= 1
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Wstecz")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep == totalSteps - 1 {
                        Button(action: {
                            triggerResultsHaptic()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                withAnimation {
                                    showingResults = true
                                }
                            }
                        }) {
                            Text("Zobacz wyniki")
                                .foregroundColor(isStepComplete() ? .blue : .gray)
                        }
                        .disabled(!isStepComplete())
                    } else {
                        // Always show Continue button
                        let isMultiSelect = (currentStep == 0 || currentStep == 3)
                        let canContinue = isMultiSelect && isStepComplete()
                        
                        Button(action: {
                            if canContinue {
                                triggerHapticFeedback()
                                withAnimation {
                                    currentStep += 1
                                }
                            }
                        }) {
                            Text("Dalej")
                                .foregroundColor(canContinue ? .blue : .gray)
                        }
                        .disabled(!canContinue)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Questions based on step
                    Group {
                        switch currentStep {
                        case 0:
                            MultipleChoiceQuestion(
                                question: "Które przedmioty w szkole sprawiają Ci największą przyjemność?",
                                options: [
                                    "Matematyka i fizyka",
                                    "Biologia i chemia",
                                    "Polski i historia",
                                    "Języki obce",
                                    "Informatyka",
                                    "WOS i geografia",
                                    "Przedmioty artystyczne"
                                ],
                                allowsMultipleSelection: true,
                                selectedAnswers: Binding(
                                    get: { answers["subjects"] as? Set<String> ?? [] },
                                    set: { 
                                        answers["subjects"] = $0
                                    }
                                )
                            )
                        case 1:
                            SingleChoiceQuestion(
                                question: "Jaki tryb studiów Cię interesuje?",
                                options: [
                                    "Studia stacjonarne (dzienne)",
                                    "Studia niestacjonarne (zaoczne)",
                                    "Studia online",
                                    "Jeszcze nie wiem"
                                ],
                                selectedAnswer: Binding(
                                    get: { answers["studyMode"] as? String },
                                    set: { 
                                        answers["studyMode"] = $0
                                        triggerHapticFeedback()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            withAnimation {
                                                currentStep += 1
                                            }
                                        }
                                    }
                                )
                            )
                        case 2:
                            SingleChoiceQuestion(
                                question: "Gdzie chciałbyś/chciałabyś studiować?",
                                options: [
                                    "W dużym mieście (Warszawa, Kraków, Wrocław)",
                                    "W średnim mieście",
                                    "W małym mieście akademickim",
                                    "Blisko domu",
                                    "Za granicą",
                                    "Nie ma to dla mnie znaczenia"
                                ],
                                selectedAnswer: Binding(
                                    get: { answers["location"] as? String },
                                    set: { 
                                        answers["location"] = $0
                                        triggerHapticFeedback()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            withAnimation {
                                                currentStep += 1
                                            }
                                        }
                                    }
                                )
                            )
                        case 3:
                            MultipleChoiceQuestion(
                                question: "Co jest dla Ciebie ważne przy wyborze kierunku?",
                                options: [
                                    "Perspektywy zawodowe",
                                    "Wysokie zarobki",
                                    "Pasja i zainteresowania",
                                    "Prestiż kierunku",
                                    "Łatwość studiowania",
                                    "Możliwość pracy zdalnej",
                                    "Stabilność zatrudnienia"
                                ],
                                allowsMultipleSelection: true,
                                selectedAnswers: Binding(
                                    get: { answers["priorities"] as? Set<String> ?? [] },
                                    set: { 
                                        answers["priorities"] = $0
                                    }
                                )
                            )
                        case 4:
                            SingleSkillQuestion(
                                skill: "Myślenie analityczne",
                                rating: Binding(
                                    get: { 
                                        let skills = answers["skills"] as? [String: Double] ?? [:]
                                        return skills["Myślenie analityczne"] ?? 0
                                    },
                                    set: { value in
                                        var skills = answers["skills"] as? [String: Double] ?? [:]
                                        skills["Myślenie analityczne"] = value
                                        answers["skills"] = skills
                                    }
                                ),
                                onComplete: {
                                    triggerHapticFeedback()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                }
                            )
                        case 5:
                            SingleSkillQuestion(
                                skill: "Kreatywność",
                                rating: Binding(
                                    get: { 
                                        let skills = answers["skills"] as? [String: Double] ?? [:]
                                        return skills["Kreatywność"] ?? 0
                                    },
                                    set: { value in
                                        var skills = answers["skills"] as? [String: Double] ?? [:]
                                        skills["Kreatywność"] = value
                                        answers["skills"] = skills
                                    }
                                ),
                                onComplete: {
                                    triggerHapticFeedback()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                }
                            )
                        case 6:
                            SingleSkillQuestion(
                                skill: "Praca z ludźmi",
                                rating: Binding(
                                    get: { 
                                        let skills = answers["skills"] as? [String: Double] ?? [:]
                                        return skills["Praca z ludźmi"] ?? 0
                                    },
                                    set: { value in
                                        var skills = answers["skills"] as? [String: Double] ?? [:]
                                        skills["Praca z ludźmi"] = value
                                        answers["skills"] = skills
                                    }
                                ),
                                onComplete: {
                                    triggerHapticFeedback()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                }
                            )
                        case 7:
                            SingleSkillQuestion(
                                skill: "Umiejętności techniczne",
                                rating: Binding(
                                    get: { 
                                        let skills = answers["skills"] as? [String: Double] ?? [:]
                                        return skills["Umiejętności techniczne"] ?? 0
                                    },
                                    set: { value in
                                        var skills = answers["skills"] as? [String: Double] ?? [:]
                                        skills["Umiejętności techniczne"] = value
                                        answers["skills"] = skills
                                    }
                                ),
                                onComplete: {
                                    triggerHapticFeedback()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                }
                            )
                        case 8:
                            SingleSkillQuestion(
                                skill: "Komunikacja",
                                rating: Binding(
                                    get: { 
                                        let skills = answers["skills"] as? [String: Double] ?? [:]
                                        return skills["Komunikacja"] ?? 0
                                    },
                                    set: { value in
                                        var skills = answers["skills"] as? [String: Double] ?? [:]
                                        skills["Komunikacja"] = value
                                        answers["skills"] = skills
                                    }
                                ),
                                onComplete: {
                                    triggerHapticFeedback()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                }
                            )
                        case 9:
                            SingleSkillQuestion(
                                skill: "Organizacja",
                                rating: Binding(
                                    get: { 
                                        let skills = answers["skills"] as? [String: Double] ?? [:]
                                        return skills["Organizacja"] ?? 0
                                    },
                                    set: { value in
                                        var skills = answers["skills"] as? [String: Double] ?? [:]
                                        skills["Organizacja"] = value
                                        answers["skills"] = skills
                                    }
                                ),
                                onComplete: {
                                    triggerHapticFeedback()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                }
                            )
                        case 10:
                            OpenQuestion(
                                question: "Opisz swoją wymarzoną pracę",
                                prompt: "Opowiedz nam, jak wyobrażasz sobie swoją przyszłą karierę. Co chciałbyś/chciałabyś robić? W jakim środowisku pracować? Jakie wyzwania podejmować?",
                                answer: Binding(
                                    get: { answers["dreamJob"] as? String ?? "" },
                                    set: { answers["dreamJob"] = $0 }
                                )
                            )
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding()
            }
        }
        }
    }
    
    private func isStepComplete() -> Bool {
        switch currentStep {
        case 0:
            return !(answers["subjects"] as? Set<String> ?? []).isEmpty
        case 1:
            return answers["studyMode"] != nil
        case 2:
            return answers["location"] != nil
        case 3:
            return !(answers["priorities"] as? Set<String> ?? []).isEmpty
        case 4...9: // Skill questions
            return true // Skills have default values
        case 10:
            let dreamJob = answers["dreamJob"] as? String ?? ""
            return dreamJob.count >= 50
        default:
            return true
        }
    }
}

struct SingleChoiceQuestion: View {
    let question: String
    let options: [String]
    @Binding var selectedAnswer: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedAnswer = option
                        }
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Image(systemName: selectedAnswer == option ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedAnswer == option ? .purple : .gray)
                                .font(.title3)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedAnswer == option ? Color.purple.opacity(0.1) : Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedAnswer == option ? Color.purple : Color.clear, lineWidth: 2)
                        )
                    }
                }
            }
        }
    }
}

struct MultipleChoiceQuestion: View {
    let question: String
    let options: [String]
    let allowsMultipleSelection: Bool
    @Binding var selectedAnswers: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(question)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("Możesz wybrać kilka odpowiedzi")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring()) {
                            if selectedAnswers.contains(option) {
                                selectedAnswers.remove(option)
                            } else {
                                selectedAnswers.insert(option)
                            }
                        }
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Image(systemName: selectedAnswers.contains(option) ? "checkmark.square.fill" : "square")
                                .foregroundColor(selectedAnswers.contains(option) ? .purple : .gray)
                                .font(.title3)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedAnswers.contains(option) ? Color.purple.opacity(0.1) : Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedAnswers.contains(option) ? Color.purple : Color.clear, lineWidth: 2)
                        )
                    }
                }
            }
        }
    }
}

struct SingleSkillQuestion: View {
    let skill: String
    @Binding var rating: Double
    let onComplete: () -> Void
    @State private var hasCompleted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Oceń swoje umiejętności")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(skill)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                VStack(spacing: 16) {
                    ForEach(1...5, id: \.self) { value in
                        Button(action: {
                            withAnimation(.spring()) {
                                rating = Double(value)
                                if !hasCompleted {
                                    hasCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        onComplete()
                                    }
                                }
                            }
                        }) {
                            HStack {
                                // Number circle
                                ZStack {
                                    Circle()
                                        .fill(Int(rating) == value ? Color.purple : Color(.systemGray5))
                                        .frame(width: 50, height: 50)
                                    
                                    Text("\(value)")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Int(rating) == value ? .white : .secondary)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(skillLevelText(for: value))
                                        .font(.headline)
                                        .foregroundColor(Int(rating) == value ? .purple : .primary)
                                    
                                    Text(skillDescription(for: value))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                                
                                if Int(rating) == value {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.purple)
                                }
                            }
                            .padding()
                            .frame(height: 80) // Fixed height for all buttons
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Int(rating) == value ? Color.purple.opacity(0.1) : Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Int(rating) == value ? Color.purple : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
            }
        }
    }
    
    private func skillLevelText(for value: Int) -> String {
        switch value {
        case 1: return "Podstawowy"
        case 2: return "Początkujący"
        case 3: return "Średni"
        case 4: return "Zaawansowany"
        case 5: return "Ekspert"
        default: return ""
        }
    }
    
    private func skillDescription(for value: Int) -> String {
        switch value {
        case 1: return "Mam podstawową wiedzę, potrzebuję wsparcia"
        case 2: return "Znam podstawy, mogę wykonywać proste zadania"
        case 3: return "Radzę sobie w typowych sytuacjach"
        case 4: return "Mam duże doświadczenie i pewność siebie"
        case 5: return "To moja mocna strona, uczę innych"
        default: return ""
        }
    }
}

struct SliderQuestion: View {
    let question: String
    let skills: [String]
    @Binding var ratings: [String: Double]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            VStack(spacing: 20) {
                ForEach(skills, id: \.self) { skill in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(skill)
                                .font(.headline)
                            Spacer()
                            Text(ratingText(for: ratings[skill] ?? 3))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 8) {
                            Text("1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Slider(
                                value: Binding(
                                    get: { ratings[skill] ?? 3 },
                                    set: { ratings[skill] = $0 }
                                ),
                                in: 1...5,
                                step: 1
                            )
                            .accentColor(.purple)
                            
                            Text("5")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private func ratingText(for value: Double) -> String {
        switch Int(value) {
        case 1: return "Bardzo słabo"
        case 2: return "Słabo"
        case 3: return "Średnio"
        case 4: return "Dobrze"
        case 5: return "Bardzo dobrze"
        default: return "Średnio"
        }
    }
}

struct OpenQuestion: View {
    let question: String
    let prompt: String
    @Binding var answer: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(question)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text(prompt)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            VStack(alignment: .trailing, spacing: 8) {
                TextEditor(text: $answer)
                    .focused($isFocused)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .frame(minHeight: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.purple : Color.clear, lineWidth: 2)
                    )
                
                Text("\(answer.count)/50 znaków minimum")
                    .font(.caption)
                    .foregroundColor(answer.count < 50 ? .red : .secondary)
            }
        }
    }
}

// Results view moved to AIMatchResultsView.swift

#Preview {
    NavigationView {
        AIMatchView()
    }
}