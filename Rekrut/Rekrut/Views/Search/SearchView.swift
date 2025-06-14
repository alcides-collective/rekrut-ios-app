//
//  SearchView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct SearchView: View {
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
                            Text("Szukaj")
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
                        
                        SearchContentView()
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
                            Text("Szukaj")
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

struct SearchContentView: View {
    @State private var searchText = ""
    @State private var programs: [StudyProgram] = MockDataService.shared.mockPrograms
    @State private var universities: [University] = MockDataService.shared.mockUniversities
    @State private var recentSearches: [String] = []
    @State private var popularSearches = ["Informatyka", "Medycyna", "Warszawa", "Kraków", "Psychologia", "Prawo"]
    
    private let mockData = MockDataService.shared
    
    var searchResults: [SearchResult] {
        if searchText.isEmpty {
            return []
        }
        
        var results: [SearchResult] = []
        let query = searchText.lowercased()
        
        print("DEBUG: Searching for '\(query)' in \(programs.count) programs and \(universities.count) universities")
        
        // Smart search - search across multiple fields
        // Universities
        let matchingUniversities = universities.filter { university in
            university.name.lowercased().contains(query) ||
            university.shortName?.lowercased().contains(query) ?? false ||
            university.city.lowercased().contains(query) ||
            university.type.rawValue.lowercased().contains(query) ||
            university.programIds.contains { programId in
                programs.first { $0.id == programId }?.name.lowercased().contains(query) ?? false
            }
        }
        
        // Programs
        let matchingPrograms = programs.filter { program in
            program.name.lowercased().contains(query) ||
            program.field.lowercased().contains(query) ||
            program.degree.rawValue.lowercased().contains(query) ||
            program.tags.contains { $0.lowercased().contains(query) } ||
            universities.first { $0.id == program.universityId }?.name.lowercased().contains(query) ?? false ||
            universities.first { $0.id == program.universityId }?.city.lowercased().contains(query) ?? false
        }
        
        print("DEBUG: Found \(matchingPrograms.count) matching programs and \(matchingUniversities.count) matching universities")
        
        // Sort by relevance (exact matches first)
        let sortedUniversities = matchingUniversities.sorted { uni1, uni2 in
            let exact1 = uni1.name.lowercased().hasPrefix(query) || uni1.shortName?.lowercased().hasPrefix(query) ?? false
            let exact2 = uni2.name.lowercased().hasPrefix(query) || uni2.shortName?.lowercased().hasPrefix(query) ?? false
            return exact1 && !exact2
        }
        
        let sortedPrograms = matchingPrograms.sorted { prog1, prog2 in
            let exact1 = prog1.name.lowercased().hasPrefix(query)
            let exact2 = prog2.name.lowercased().hasPrefix(query)
            return exact1 && !exact2
        }
        
        // Mix results - alternating when both have results
        if !sortedPrograms.isEmpty && !sortedUniversities.isEmpty {
            // Show top programs first, then universities
            results.append(contentsOf: sortedPrograms.prefix(3).map { SearchResult.program($0) })
            results.append(contentsOf: sortedUniversities.prefix(2).map { SearchResult.university($0) })
            results.append(contentsOf: sortedPrograms.dropFirst(3).map { SearchResult.program($0) })
            results.append(contentsOf: sortedUniversities.dropFirst(2).map { SearchResult.university($0) })
        } else {
            results.append(contentsOf: sortedUniversities.map { SearchResult.university($0) })
            results.append(contentsOf: sortedPrograms.map { SearchResult.program($0) })
        }
        
        return results
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Szukaj kierunków, uczelni, miast...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onSubmit {
                        addToRecentSearches()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 4)
            
            // Results or suggestions
            if searchText.isEmpty {
                SearchSuggestionsView(
                    recentSearches: $recentSearches,
                    popularSearches: popularSearches,
                    onSelect: { searchText = $0 }
                )
            } else if searchResults.isEmpty {
                NoResultsView(searchText: searchText)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if searchResults.count > 20 {
                            Text("Pokazuję \(min(searchResults.count, 50)) z \(searchResults.count) wyników")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                        }
                        
                        ForEach(searchResults.prefix(50)) { result in
                            SearchResultRow(result: result)
                                .padding(.horizontal, 16)
                            
                            if result.id != searchResults.prefix(50).last?.id {
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        programs = mockData.mockPrograms
        universities = mockData.mockUniversities
        
        print("DEBUG: Loaded \(programs.count) programs and \(universities.count) universities")
        
        // Load recent searches from UserDefaults
        if let saved = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
            recentSearches = saved
        }
    }
    
    private func addToRecentSearches() {
        guard !searchText.isEmpty else { return }
        
        // Remove if already exists
        recentSearches.removeAll { $0 == searchText }
        
        // Add to beginning
        recentSearches.insert(searchText, at: 0)
        
        // Keep only last 5
        if recentSearches.count > 5 {
            recentSearches = Array(recentSearches.prefix(5))
        }
        
        // Save to UserDefaults
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
}

enum SearchResult: Identifiable {
    case university(University)
    case program(StudyProgram)
    
    var id: String {
        switch self {
        case .university(let uni):
            return "uni_\(uni.id)"
        case .program(let prog):
            return "prog_\(prog.id)"
        }
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    @State private var showingDetail = false
    
    var body: some View {
        switch result {
        case .university(let university):
            Button(action: {
                showingDetail = true
            }) {
                UniversitySearchRow(university: university)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingDetail) {
                NavigationView {
                    UniversityDetailView(university: university)
                        .navigationBarItems(trailing: Button("Zamknij") {
                            showingDetail = false
                        })
                }
            }
        case .program(let program):
            Button(action: {
                showingDetail = true
            }) {
                ProgramSearchRow(program: program)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingDetail) {
                NavigationView {
                    ProgramDetailView(
                        program: program,
                        university: MockDataService.shared.mockUniversities.first { $0.id == program.universityId }!
                    )
                    .navigationBarItems(trailing: Button("Zamknij") {
                        showingDetail = false
                    })
                }
            }
        }
    }
}

struct UniversitySearchRow: View {
    let university: University
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(university.name)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(1)
            
            HStack(spacing: 4) {
                Text(university.city)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("•")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(university.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 10)
    }
}

struct ProgramSearchRow: View {
    let program: StudyProgram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(program.name)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(1)
            
            Text(program.degree.rawValue)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 10)
    }
}

struct SearchPlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary.opacity(0.5))
            
            Text("Wyszukaj kierunki i uczelnie")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Znajdź idealny kierunek studiów dla siebie")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 16) {
                Label("Szukaj po nazwie kierunku", systemImage: "book")
                Label("Filtruj po mieście", systemImage: "mappin")
                Label("Znajdź uczelnie według typu", systemImage: "building.2")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct NoResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary.opacity(0.4))
            
            VStack(spacing: 8) {
                Text("Brak wyników")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text("Nie znaleziono wyników dla \"\(searchText)\"")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Spróbuj użyć innych słów kluczowych")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    SearchView()
}