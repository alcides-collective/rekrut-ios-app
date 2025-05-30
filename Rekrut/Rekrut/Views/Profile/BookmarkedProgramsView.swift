//
//  BookmarkedProgramsView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct BookmarkedProgramsView: View {
    @StateObject private var firebaseService = FirebaseService.shared
    @State private var savedPrograms: [StudyProgram] = []
    @State private var isLoading = true
    @State private var loadError: Error?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Ładowanie zapisanych kierunków...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
            } else if savedPrograms.isEmpty {
                EmptyBookmarksView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(savedPrograms) { program in
                            if let university = MockDataService.shared.mockUniversities.first(where: { $0.id == program.universityId }) {
                                BookmarkedProgramRow(
                                    program: program,
                                    university: university,
                                    onRemove: {
                                        removeBookmark(programId: program.id)
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle("Zapisane kierunki")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadSavedPrograms()
        }
    }
    
    private func loadSavedPrograms() {
        Task {
            guard let user = firebaseService.currentUser else {
                savedPrograms = []
                isLoading = false
                return
            }
            
            // In a real app, this would fetch from Firebase
            // For now, we'll use mock data
            let allPrograms = MockDataService.shared.mockPrograms
            savedPrograms = allPrograms.filter { program in
                user.savedPrograms.contains(program.id)
            }
            
            isLoading = false
        }
    }
    
    private func removeBookmark(programId: String) {
        Task {
            do {
                try await firebaseService.unsaveProgram(programId: programId)
                withAnimation {
                    savedPrograms.removeAll { $0.id == programId }
                }
            } catch {
                print("Error removing bookmark: \(error)")
            }
        }
    }
}

struct EmptyBookmarksView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "bookmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("Brak zapisanych kierunków")
                    .font(.headline)
                
                Text("Zapisuj interesujące Cię kierunki studiów,\naby mieć do nich szybki dostęp")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            NavigationLink(destination: ExploreFeedView()) {
                Text("Przeglądaj kierunki")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

struct BookmarkedProgramRow: View {
    let program: StudyProgram
    let university: University
    let onRemove: () -> Void
    @State private var showingDetail = false
    @State private var showingRemoveAlert = false
    @StateObject private var firebaseService = FirebaseService.shared
    @StateObject private var localStorage = LocalStorageService.shared
    
    // Calculate user's progress based on their matura scores
    private var userProgress: Double? {
        guard program.lastYearThreshold != nil else { return nil }
        
        // Get matura scores from Firebase or local storage
        var maturaScores: MaturaScores? = nil
        
        if let user = firebaseService.currentUser,
           let userScores = user.maturaScores {
            maturaScores = userScores
        } else {
            // Try local storage if not logged in - now reactive!
            maturaScores = localStorage.maturaScores
        }
        
        guard let scores = maturaScores,
              hasEnteredScores(scores) else {
            return nil
        }
        
        return program.calculateProgress(maturaScores: scores)
    }
    
    private func hasEnteredScores(_ maturaScores: MaturaScores) -> Bool {
        // Check if user has entered any matura scores
        return maturaScores.polishBasic != nil ||
               maturaScores.mathematicsBasic != nil ||
               maturaScores.polish != nil ||
               maturaScores.mathematics != nil ||
               maturaScores.foreignLanguageBasic != nil ||
               maturaScores.foreignLanguage != nil ||
               maturaScores.physics != nil ||
               maturaScores.computerScience != nil ||
               maturaScores.chemistry != nil ||
               maturaScores.biology != nil
    }
    
    private func getProgressColor() -> Color {
        if let progress = userProgress {
            if progress >= 1.0 {
                return .green
            } else if progress >= 0.8 {
                return .yellow
            } else {
                return .red
            }
        }
        // Gray color if no user data entered
        return .gray
    }
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            HStack(spacing: 16) {
                // University logo or icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Text(university.shortName ?? String(university.name.prefix(2)))
                        .font(.caption)
                        .bold()
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(program.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(university.displayName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        if let threshold = program.lastYearThreshold {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(getProgressColor())
                                    .frame(width: 6, height: 6)
                                
                                if let progress = userProgress, progress > 1.0 {
                                    Text("+\(Int((progress - 1.0) * 100))%")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                } else if userProgress == nil {
                                    Text("Wprowadź maturę")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("\(Int(threshold)) pkt")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        Label(program.degree.rawValue, systemImage: "graduationcap")
                            .font(.caption)
                            .foregroundColor(.orange)
                        
                        Label(program.mode.rawValue, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                // Remove button
                Button(action: {
                    showingRemoveAlert = true
                }) {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                ProgramDetailView(program: program, university: university)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Zamknij") {
                                showingDetail = false
                            }
                        }
                    }
            }
        }
        .alert("Usuń z zapisanych?", isPresented: $showingRemoveAlert) {
            Button("Anuluj", role: .cancel) { }
            Button("Usuń", role: .destructive) {
                onRemove()
            }
        } message: {
            Text("Czy na pewno chcesz usunąć \"\(program.name)\" z zapisanych kierunków?")
        }
    }
}

#Preview {
    NavigationView {
        BookmarkedProgramsView()
    }
}
