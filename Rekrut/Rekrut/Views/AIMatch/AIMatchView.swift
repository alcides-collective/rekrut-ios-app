//
//  AIMatchView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI
import UIKit

struct AIMatchView: View {
    @State private var showingProfile = false
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var showNavBar = false
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        // Custom inline header
                        HStack {
                            Text("AI Match")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                showingProfile = true
                            }) {
                                Image(systemName: firebaseService.isAuthenticated ? "person.crop.circle.fill" : "person.crop.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .global).minY) { value in
                                        withAnimation(.easeInOut(duration: 0.1)) {
                                            showNavBar = value < 50
                                        }
                                    }
                            }
                        )
                        
                        AIMatchContentView()
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .top) {
                // Navigation bar that appears on scroll
                if showNavBar {
                    VStack(spacing: 0) {
                        Color.clear
                            .frame(height: 50)
                        
                        HStack {
                            Text("AI Match")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 56)
                        .background(.regularMaterial)
                        .overlay(alignment: .bottom) {
                            Divider()
                        }
                    }
                    .ignoresSafeArea()
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

struct AIMatchContentView: View {
    @State private var hasStarted = false
    @State private var currentStep = 0
    @State private var answers: [String: Any] = [:]
    @State private var showingResults = false
    @StateObject private var firebaseService = FirebaseService.shared
    
    var body: some View {
        Group {
            if !hasStarted {
                AIMatchStartView(hasStarted: $hasStarted)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if showingResults {
                AIMatchResultsView(answers: answers)
            } else {
                AIMatchQuestionnaireView(
                    currentStep: $currentStep,
                    answers: $answers,
                    showingResults: $showingResults
                )
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if showingResults {
                    Button("Zacznij od nowa") {
                        withAnimation {
                            currentStep = 0
                            answers = [:]
                            showingResults = false
                            hasStarted = false
                        }
                    }
                } else if hasStarted && currentStep > 0 {
                    Button(action: {
                        withAnimation {
                            currentStep -= 1
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Wstecz")
                        }
                    }
                }
            }
        }
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
    @State private var currentFeatureIndex = 0
    
    let features = [
        "Inteligentna analiza Twoich odpowiedzi",
        "Spersonalizowane rekomendacje kierunków",
        "11 prostych pytań o Twoje preferencje",
        "Wyniki dopasowane do Twoich umiejętności"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated icon
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 16) {
                Text("Dopasowanie AI")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("Znajdź idealny kierunek studiów")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Animated feature display
            VStack(spacing: 20) {
                Text(features[currentFeatureIndex])
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .animation(.easeInOut(duration: 0.3), value: currentFeatureIndex)
                    .transition(.opacity)
                    .id(currentFeatureIndex)
                
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<features.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentFeatureIndex ? Color.blue : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentFeatureIndex)
                    }
                }
            }
            .onAppear {
                startFeatureAnimation()
            }
            
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
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 60)
        .background(Color(.systemBackground))
    }
    
    private func startFeatureAnimation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            withAnimation {
                currentFeatureIndex = (currentFeatureIndex + 1) % features.count
            }
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
                        Color.blue,
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

// Answer option model
struct AnswerOption: Identifiable {
    let id = UUID().uuidString
    let text: String
    let icon: String
    let isEmpty: Bool
    
    init(text: String, icon: String = "", isEmpty: Bool = false) {
        self.text = text
        self.icon = icon
        self.isEmpty = isEmpty
    }
}

// Grid answer panel component
struct AnswerPanel: View {
    let option: AnswerOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            if !option.isEmpty {
                onTap()
            }
        }) {
            HStack(spacing: 12) {
                if !option.icon.isEmpty {
                    Text(option.icon)
                        .font(.system(size: 24))
                }
                
                Text(option.text)
                    .font(.system(size: 13))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .white : (option.isEmpty ? .clear : .primary))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : (option.isEmpty ? Color.clear : Color(.systemGray6)))
            )
            .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.black.opacity(0.1), 
                    radius: isSelected ? 8 : 4, 
                    x: 0, 
                    y: isSelected ? 4 : 2)
        }
        .disabled(option.isEmpty)
    }
}

// Skill rating panel component
struct SkillRatingPanel: View {
    let skill: String
    let rating: Int
    let onSelect: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Text(skill)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { value in
                    Image(systemName: value <= rating ? "star.fill" : "star")
                        .font(.system(size: 22))
                        .foregroundColor(value <= rating ? .yellow : .secondary.opacity(0.3))
                        .onTapGesture {
                            onSelect(value)
                        }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(rating > 0 ? Color.blue : Color.clear, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), 
                radius: 4, 
                x: 0, 
                y: 2)
    }
}

// Grid skills question component
struct GridSkillsQuestionView: View {
    let question: String
    let subtitle: String?
    let skills: [(name: String, key: String)]
    @Binding var ratings: [String: Double]
    let onComplete: (() -> Void)?
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: 0) {
                // Fixed 200pt hero section
                VStack(spacing: 0) {
                    Spacer(minLength: 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        // Progress fill
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * (Double(currentStep + 1) / Double(totalSteps)), height: 6)
                            .cornerRadius(3)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                
                // Skills in single column
                VStack(spacing: 12) {
                ForEach(skills, id: \.key) { skill in
                    SkillRatingPanel(
                        skill: skill.name,
                        rating: Int(ratings[skill.key] ?? 0),
                        onSelect: { value in
                            ratings[skill.key] = Double(value)
                            
                            // Check if all skills have been rated
                            let allRated = skills.allSatisfy { ratings[$0.key] != nil && ratings[$0.key]! > 0 }
                            if allRated {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    onComplete?()
                                }
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 24)
            
            Spacer()
        }
    }
}

// Unified grid question component
struct GridQuestionView: View {
    let question: String
    let subtitle: String?
    let options: [AnswerOption]
    @Binding var selection: Set<String>
    let allowsMultiple: Bool
    let onSelect: ((String) -> Void)?
    let currentStep: Int
    let totalSteps: Int
    
    private var paddedOptions: [AnswerOption] {
        var result = options
        // Ensure even number of options
        if result.count % 2 != 0 {
            result.append(AnswerOption(text: "", isEmpty: true))
        }
        return result
    }
    
    var body: some View {
        VStack(spacing: 0) {
                // Fixed 200pt hero section
                VStack(spacing: 0) {
                    Spacer(minLength: 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Multiple selection hint
                        if allowsMultiple {
                            Text("Możesz wybrać kilka odpowiedzi")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        // Progress fill
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * (Double(currentStep + 1) / Double(totalSteps)), height: 6)
                            .cornerRadius(3)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                
                // Grid with normal flow
                LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(paddedOptions) { option in
                    AnswerPanel(
                        option: option,
                        isSelected: selection.contains(option.text),
                        onTap: {
                            if allowsMultiple {
                                if selection.contains(option.text) {
                                    selection.remove(option.text)
                                } else {
                                    selection.insert(option.text)
                                }
                            } else {
                                selection.removeAll()
                                selection.insert(option.text)
                                onSelect?(option.text)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, allowsMultiple ? 12 : 24)
            
            // Next button for multiple selection
            if allowsMultiple && !selection.isEmpty {
                HStack {
                    Spacer()
                    Button(action: {
                        onSelect?("")
                    }) {
                        Text("Dalej")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .transition(.opacity)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            
            Spacer()
        }
    }
}

struct AIMatchQuestionnaireView: View {
    @Binding var currentStep: Int
    @Binding var answers: [String: Any]
    @Binding var showingResults: Bool
    
    let totalSteps = 6 // Updated: 4 regular steps + 1 skill step + 1 open question
    
    @State private var showingCityPicker = false
    @State private var selectedCity: String = ""
    
    // Add progress component
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                // Progress fill
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * (Double(currentStep + 1) / Double(totalSteps)), height: 4)
                    .cornerRadius(2)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)
            }
        }
        .frame(height: 4)
        .padding(.horizontal, 24)
    }
    
    let polishUniversityCities = [
        "Warszawa", "Kraków", "Wrocław", "Poznań", "Gdańsk", 
        "Łódź", "Katowice", "Lublin", "Białystok", "Szczecin",
        "Bydgoszcz", "Toruń", "Olsztyn", "Rzeszów", "Opole",
        "Częstochowa", "Gliwice", "Kielce", "Radom", "Sosnowiec",
        "Zielona Góra", "Siedlce", "Nowy Sącz", "Koszalin", "Słupsk"
    ].sorted()
    
    private func triggerHapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()
        impact.impactOccurred()
    }
    
    private func triggerResultsHaptic() {
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        notification.notificationOccurred(.success)
    }
    
    var body: some View {
        ZStack {
            // Main content area with swipe gestures
            VStack(spacing: 0) {
                    
                    // Questions based on step
                    switch currentStep {
                        case 0:
                            GridQuestionView(
                                question: "Które przedmioty w szkole sprawiają Ci największą przyjemność?",
                                subtitle: nil,
                                options: [
                                    AnswerOption(text: "Matematyka i fizyka", icon: "🔢"),
                                    AnswerOption(text: "Biologia i chemia", icon: "🧬"),
                                    AnswerOption(text: "Polski i historia", icon: "📚"),
                                    AnswerOption(text: "Języki obce", icon: "🌍"),
                                    AnswerOption(text: "Informatyka", icon: "💻"),
                                    AnswerOption(text: "WOS i geografia", icon: "🗺️"),
                                    AnswerOption(text: "Przedmioty artystyczne", icon: "🎨"),
                                    AnswerOption(text: "Wychowanie fizyczne", icon: "⚽") // Added to make even
                                ],
                                selection: Binding(
                                    get: { 
                                        let subjects = answers["subjects"] as? Set<String> ?? []
                                        return subjects
                                    },
                                    set: { answers["subjects"] = $0 }
                                ),
                                allowsMultiple: true,
                                onSelect: { _ in
                                    triggerHapticFeedback()
                                    withAnimation {
                                        currentStep += 1
                                    }
                                },
                                currentStep: currentStep,
                                totalSteps: totalSteps
                            )
                        case 1:
                            GridQuestionView(
                                question: "Jaki tryb studiów Cię interesuje?",
                                subtitle: nil,
                                options: [
                                    AnswerOption(text: "Studia dzienne", icon: "🌞"),
                                    AnswerOption(text: "Studia zaoczne", icon: "🌙"),
                                    AnswerOption(text: "Studia online", icon: "💻"),
                                    AnswerOption(text: "Jeszcze nie wiem", icon: "❓")
                                ],
                                selection: Binding(
                                    get: { 
                                        if let mode = answers["studyMode"] as? String {
                                            return Set([mode])
                                        }
                                        return Set()
                                    },
                                    set: { 
                                        answers["studyMode"] = $0.first
                                    }
                                ),
                                allowsMultiple: false,
                                onSelect: { _ in
                                    triggerHapticFeedback()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                },
                                currentStep: currentStep,
                                totalSteps: totalSteps
                            )
                        case 2:
                            GridQuestionView(
                                question: "Gdzie chciałbyś/chciałabyś studiować?",
                                subtitle: nil,
                                options: [
                                    AnswerOption(text: "Duże miasto", icon: "🏙️"),
                                    AnswerOption(text: "Średnie miasto", icon: "🏘️"),
                                    AnswerOption(text: "Małe miasto", icon: "🏡"),
                                    AnswerOption(text: "Blisko domu", icon: "🏠"),
                                    AnswerOption(text: "Miasto akademickie", icon: "🎓"),
                                    AnswerOption(text: "Bez znaczenia", icon: "🤷")
                                ],
                                selection: Binding(
                                    get: { 
                                        if let location = answers["location"] as? String {
                                            return Set([location])
                                        }
                                        return Set()
                                    },
                                    set: { 
                                        answers["location"] = $0.first
                                    }
                                ),
                                allowsMultiple: false,
                                onSelect: { location in
                                    if location == "Blisko domu" {
                                        showingCityPicker = true
                                    } else {
                                        triggerHapticFeedback()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            withAnimation {
                                                currentStep += 1
                                            }
                                        }
                                    }
                                },
                                currentStep: currentStep,
                                totalSteps: totalSteps
                            )
                        case 3:
                            GridQuestionView(
                                question: "Co jest dla Ciebie ważne przy wyborze kierunku?",
                                subtitle: nil,
                                options: [
                                    AnswerOption(text: "Perspektywy", icon: "📈"),
                                    AnswerOption(text: "Zarobki", icon: "💰"),
                                    AnswerOption(text: "Pasja", icon: "❤️"),
                                    AnswerOption(text: "Prestiż", icon: "👑"),
                                    AnswerOption(text: "Łatwość", icon: "😌"),
                                    AnswerOption(text: "Praca zdalna", icon: "🏠"),
                                    AnswerOption(text: "Stabilność", icon: "🛡️"),
                                    AnswerOption(text: "Rozwój", icon: "🚀") // Added to make even
                                ],
                                selection: Binding(
                                    get: { 
                                        let priorities = answers["priorities"] as? Set<String> ?? []
                                        return priorities
                                    },
                                    set: { answers["priorities"] = $0 }
                                ),
                                allowsMultiple: true,
                                onSelect: { _ in
                                    triggerHapticFeedback()
                                    withAnimation {
                                        currentStep += 1
                                    }
                                },
                                currentStep: currentStep,
                                totalSteps: totalSteps
                            )
                        case 4:
                            GridSkillsQuestionView(
                                question: "Oceń swoje umiejętności",
                                subtitle: "Kliknij gwiazdki, aby ocenić każdą umiejętność od 1 do 5",
                                skills: [
                                    (name: "Myślenie analityczne", key: "Myślenie analityczne"),
                                    (name: "Kreatywność", key: "Kreatywność"),
                                    (name: "Praca z ludźmi", key: "Praca z ludźmi"),
                                    (name: "Umiejętności techniczne", key: "Umiejętności techniczne"),
                                    (name: "Komunikacja", key: "Komunikacja")
                                ],
                                ratings: Binding(
                                    get: { answers["skills"] as? [String: Double] ?? [:] },
                                    set: { answers["skills"] = $0 }
                                ),
                                onComplete: {
                                    triggerHapticFeedback()
                                    withAnimation {
                                        currentStep += 1
                                    }
                                },
                                currentStep: currentStep,
                                totalSteps: totalSteps
                            )
                        case 5:
                            OpenQuestion(
                                question: "Opisz swoją wymarzoną pracę",
                                prompt: "Opowiedz nam, jak wyobrażasz sobie swoją przyszłą karierę. Co chciałbyś/chciałabyś robić? W jakim środowisku pracować? Jakie wyzwania podejmować?",
                                answer: Binding(
                                    get: { answers["dreamJob"] as? String ?? "" },
                                    set: { answers["dreamJob"] = $0 }
                                ),
                                onComplete: {
                                    triggerResultsHaptic()
                                    withAnimation {
                                        showingResults = true
                                    }
                                },
                                currentStep: currentStep,
                                totalSteps: totalSteps
                            )
                        default:
                            EmptyView()
                        }
                    }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let horizontalAmount = value.translation.width
                            let verticalAmount = value.translation.height
                            
                            // Horizontal swipe detection
                            if abs(horizontalAmount) > abs(verticalAmount) {
                                if horizontalAmount < -50 {
                                    // Swipe left - go to next step if possible
                                    if currentStep < totalSteps - 1 && isStepComplete() {
                                        triggerHapticFeedback()
                                        withAnimation {
                                            currentStep += 1
                                        }
                                    }
                                } else if horizontalAmount > 50 && currentStep > 0 {
                                    // Swipe right - go to previous step
                                    withAnimation {
                                        currentStep -= 1
                                    }
                                }
                            }
                        }
                )
            .sheet(isPresented: $showingCityPicker) {
                NavigationView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Wybierz swoje miasto")
                                .font(.title2)
                                .bold()
                            
                            Text("Pomożemy znaleźć uczelnie w Twojej okolicy")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        
                        Divider()
                        
                        // City list
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(polishUniversityCities, id: \.self) { city in
                                    Button(action: {
                                        selectedCity = city
                                        answers["homeCity"] = city
                                        showingCityPicker = false
                                        triggerHapticFeedback()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            withAnimation {
                                                currentStep += 1
                                            }
                                        }
                                    }) {
                                        HStack {
                                            Text(city)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            if selectedCity == city {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding()
                                        .background(Color(.systemBackground))
                                    }
                                    
                                    Divider()
                                        .padding(.leading)
                                }
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Anuluj") {
                                showingCityPicker = false
                                // Reset the location selection
                                answers["location"] = nil
                            }
                        }
                    }
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
        case 4: // Skill question - auto-progress when all 5 rated
            let skills = answers["skills"] as? [String: Double] ?? [:]
            return skills["Myślenie analityczne"] != nil && skills["Kreatywność"] != nil &&
                   skills["Praca z ludźmi"] != nil && skills["Umiejętności techniczne"] != nil &&
                   skills["Komunikacja"] != nil
        case 5:
            let dreamJob = answers["dreamJob"] as? String ?? ""
            return dreamJob.count >= 50
        default:
            return true
        }
    }
}

struct OpenQuestion: View {
    let question: String
    let prompt: String
    @Binding var answer: String
    let onComplete: (() -> Void)?
    let currentStep: Int
    let totalSteps: Int
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
                // Fixed 200pt hero section
                VStack(spacing: 0) {
                    Spacer(minLength: 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(prompt)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        // Progress fill
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * (Double(currentStep + 1) / Double(totalSteps)), height: 6)
                            .cornerRadius(3)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                
                // Text editor section
                VStack(alignment: .trailing, spacing: 12) {
                    TextEditor(text: $answer)
                        .focused($isFocused)
                        .padding(16)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .frame(minHeight: 200)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                        )
                    
                    Text("\(answer.count)/50 znaków minimum")
                        .font(.caption)
                        .foregroundColor(answer.count < 50 ? .red : Color.secondary)
                        .padding(.horizontal, 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 20)
                
                // Show results button when requirement is met
                if answer.count >= 50 {
                    HStack {
                        Spacer()
                        Button(action: {
                            onComplete?()
                        }) {
                            Text("Zobacz wyniki")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .transition(.opacity)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                Spacer()
            }
        .onAppear {
            // Automatically focus and show keyboard
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
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