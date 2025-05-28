//
//  ProgramDetailView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// Simple iOS 15 compatible wrapping layout
struct WrappingHStack<Content: View>: View {
    let content: Content
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        // For iOS 15, we'll use a simpler approach with multiple HStacks
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
    }
}

struct ProgramDetailView: View {
    let program: StudyProgram
    let university: University
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var isSaved = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                ProgramHeroView(
                    program: program, 
                    university: university, 
                    isSaved: isSaved, 
                    toggleSave: toggleSave
                )
                
                VStack(alignment: .leading, spacing: 32) {
                    // Essential Info Pills
                    ProgramEssentialsView(program: program)
                    
                    // Description
                    if let description = program.description {
                        ProgramDescriptionView(description: description)
                    }
                    
                    // Admission Details
                    ProgramAdmissionView(program: program)
                    
                    // Tags
                    if !program.tags.isEmpty {
                        ProgramTagsView(tags: program.tags)
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .onAppear {
            checkIfSaved()
        }
    }
    
    private func checkIfSaved() {
        if let user = firebaseService.currentUser {
            isSaved = user.savedPrograms.contains(program.id)
        }
    }
    
    private func toggleSave() {
        Task {
            do {
                if isSaved {
                    try await firebaseService.unsaveProgram(programId: program.id)
                } else {
                    try await firebaseService.saveProgram(programId: program.id)
                }
                isSaved.toggle()
            } catch {
                print("Error toggling save: \(error)")
            }
        }
    }
}

struct ProgramHeroView: View {
    let program: StudyProgram
    let university: University
    @State private var imageLoadFailed = false
    @Environment(\.dismiss) private var dismiss
    let isSaved: Bool
    let toggleSave: () -> Void
    
    private var backgroundGradient: LinearGradient {
        let colors: [Color] = [.blue, .purple, .green, .orange, .pink].shuffled()
        return LinearGradient(
            gradient: Gradient(colors: [colors[0].opacity(0.8), colors[1].opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Background - either image or gradient
                if let imageURL = program.thumbnailURL ?? program.imageURL,
                   !imageLoadFailed,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .overlay(
                                    // Enhanced gradient overlay for better text readability
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.black.opacity(0),
                                            Color.black.opacity(0.3),
                                            Color.black.opacity(0.8)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        case .failure(_):
                            backgroundGradient
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .onAppear { imageLoadFailed = true }
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.1)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        @unknown default:
                            backgroundGradient
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                } else {
                    backgroundGradient
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                // Navigation overlay
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Button(action: toggleSave) {
                            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 60) // Account for safe area
                    
                    Spacer()
                    
                    // Content overlay
                    VStack(alignment: .leading, spacing: 8) {
                        if let faculty = program.faculty {
                            Text(faculty)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(1)
                        }
                        
                        Text(program.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Text(university.name)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(height: 400)
    }
}

struct ProgramEssentialsView: View {
    let program: StudyProgram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Essential Info Grid
            HStack(spacing: 0) {
                EssentialInfoCell(
                    label: "Stopień",
                    value: program.degree.rawValue
                )
                
                Divider()
                    .frame(height: 50)
                
                EssentialInfoCell(
                    label: "Tryb",
                    value: program.mode.rawValue
                )
                
                Divider()
                    .frame(height: 50)
                
                EssentialInfoCell(
                    label: "Czas trwania",
                    value: "\(program.durationSemesters) sem."
                )
                
                if let tuition = program.tuitionFee, tuition > 0 {
                    Divider()
                        .frame(height: 50)
                    
                    EssentialInfoCell(
                        label: "Czesne",
                        value: "\(tuition) zł/sem"
                    )
                }
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 24)
            
            // Admission Progress (if threshold available)
            if let threshold = program.lastYearThreshold {
                AdmissionProgressView(threshold: threshold)
            } else {
                // Fallback when no threshold data is available
                NoThresholdInfoView()
            }
        }
    }
}

struct EssentialInfoCell: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

struct AdmissionProgressView: View {
    let threshold: Double
    @State private var userPoints: Double = 0 // This would come from user's profile/calculation
    
    private var progress: Double {
        min(userPoints / threshold, 1.0)
    }
    
    private var progressColor: Color {
        if progress >= 1.0 {
            return .green
        } else if progress >= 0.8 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Twoje szanse")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(userPoints))")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(progressColor)
                + Text(" / \(Int(threshold)) pkt")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Progress Bar
            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        // Progress fill
                        Rectangle()
                            .fill(progressColor)
                            .frame(width: geometry.size.width * progress, height: 4)
                            .cornerRadius(2)
                            .animation(.easeInOut(duration: 0.5), value: progress)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 24)
                
                // Progress text
                HStack {
                    Text(progressText)
                        .font(.caption)
                        .foregroundColor(progressColor)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            // Simulate loading user's calculated points
            // In real app, this would come from user's profile/calculation service
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                userPoints = Double.random(in: 50...threshold * 1.2)
            }
        }
    }
    
    private var progressText: String {
        if progress >= 1.0 {
            return "Wysokie szanse"
        } else if progress >= 0.8 {
            return "Umiarkowane szanse"
        } else {
            return "Niskie szanse"
        }
    }
}

struct ProgramDescriptionView: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(description)
                .font(.body)
                .lineSpacing(4)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)
        }
    }
}

struct ProgramAdmissionView: View {
    let program: StudyProgram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Rekrutacja")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 24)
            
            VStack(spacing: 0) {
                // Description
                if let description = program.requirements.description {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Zasady rekrutacji")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 24)
                }
                
                // Formula
                AdmissionRow(
                    label: "Wzór punktacji",
                    content: AnyView(
                        Text(program.requirements.formula)
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    )
                )
                
                // Additional exams
                if !program.requirements.additionalExams.isEmpty {
                    AdmissionRow(
                        label: "Dodatkowe egzaminy",
                        content: AnyView(
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(program.requirements.additionalExams, id: \.self) { exam in
                                    Text("• \(exam)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                    )
                }
                
                // Deadline
                if let deadline = program.requirements.deadlineDate {
                    AdmissionRow(
                        label: "Termin składania",
                        content: AnyView(
                            Text(deadline, style: .date)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        )
                    )
                }
            }
        }
    }
}

struct AdmissionRow: View {
    let label: String
    let content: AnyView
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(width: 120, alignment: .leading)
                
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }
}

struct ProgramTagsView: View {
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tematyka")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 24)
            
            // Simple wrapping for iOS 15 - split into rows
            VStack(alignment: .leading, spacing: 8) {
                let chunkedTags = tags.chunked(into: 3) // Split into groups of 3
                ForEach(Array(chunkedTags.enumerated()), id: \.offset) { index, tagGroup in
                    HStack(spacing: 8) {
                        ForEach(tagGroup, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.tertiarySystemBackground))
                                .foregroundColor(.secondary)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

struct NoThresholdInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Info header
            HStack {
                Image(systemName: "info.circle")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                Text("Brak danych o progu punktowym")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Explanation
            Text("Próg punktowy dla tego kierunku nie jest jeszcze dostępny. Sprawdź informacje na stronie uczelni lub skontaktuj się z komisją rekrutacyjną.")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
            
            // Alternative helpful info
            VStack(alignment: .leading, spacing: 8) {
                Text("Co możesz zrobić:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Image(systemName: "1.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    Text("Sprawdź wyniki rekrutacji z poprzednich lat na stronie uczelni")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "2.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    Text("Użyj kalkulatora punktów, aby oszacować swoje szanse")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "3.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    Text("Porównaj z podobnymi kierunkami na tej uczelni")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationView {
        ProgramDetailView(
            program: MockDataService.shared.mockPrograms.first!,
            university: MockDataService.shared.mockUniversities.first!
        )
    }
}