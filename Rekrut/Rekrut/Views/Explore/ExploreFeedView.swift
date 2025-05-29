//
//  ExploreFeedView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct ExploreFeedView: View {
    @State private var trendingPrograms: [StudyProgram] = []
    @State private var forYouPrograms: [StudyProgram] = []
    @State private var recommendedPrograms: [StudyProgram] = []
    @State private var universities: [University] = []
    @State private var isLoading = true
    @State private var selectedMode: StudyMode? = nil
    @State private var selectedCity: String? = nil
    @State private var selectedDegree: Degree? = nil
    @State private var showingAllUniversities = false
    @State private var showingCityDetail = false
    @State private var selectedCityDetail: CityInfo?
    @StateObject private var firebaseService = FirebaseService.shared
    
    private let mockData = MockDataService.shared
    
    var filteredPrograms: [StudyProgram] {
        trendingPrograms.filter { program in
            let matchesMode = selectedMode == nil || program.mode == selectedMode
            let matchesCity = selectedCity == nil || universities.first { $0.id == program.universityId }?.city == selectedCity
            let matchesDegree = selectedDegree == nil || program.degree == selectedDegree
            
            return matchesMode && matchesCity && matchesDegree
        }
    }
    
    var cities: [String] {
        Array(Set(universities.map { $0.city })).sorted()
    }
    
    var filteredRecommendedPrograms: [StudyProgram] {
        recommendedPrograms.filter { program in
            let matchesMode = selectedMode == nil || program.mode == selectedMode
            let matchesCity = selectedCity == nil || universities.first { $0.id == program.universityId }?.city == selectedCity
            let matchesDegree = selectedDegree == nil || program.degree == selectedDegree
            return matchesMode && matchesCity && matchesDegree
        }
    }
    
    @ViewBuilder
    var trendingSection: some View {
        if !filteredPrograms.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                ExploreSectionHeader(
                    title: "Trending",
                    icon: "flame.fill",
                    actionText: "Zobacz więcej",
                    action: { 
                        // TODO: Navigate to full trending list
                    }
                )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(filteredPrograms.prefix(10)) { program in
                            TrendingProgramCard(
                                program: program,
                                university: universities.first { $0.id == program.universityId }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom, 15)
                }
            }
        } else if !trendingPrograms.isEmpty {
            EmptyFilterResultsView()
                .padding()
        }
    }
    
    @ViewBuilder
    var forYouSection: some View {
        let filteredForYou = forYouPrograms.filter { program in
            let matchesMode = selectedMode == nil || program.mode == selectedMode
            let matchesCity = selectedCity == nil || universities.first { $0.id == program.universityId }?.city == selectedCity
            let matchesDegree = selectedDegree == nil || program.degree == selectedDegree
            return matchesMode && matchesCity && matchesDegree
        }
        
        if !filteredForYou.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                ExploreSectionHeader(
                    title: "Dla Ciebie",
                    icon: "person.fill",
                    actionText: "Zobacz więcej",
                    action: { 
                        // TODO: Navigate to full personalized list
                    }
                )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(filteredForYou.prefix(10)) { program in
                            TrendingProgramCard(
                                program: program,
                                university: universities.first { $0.id == program.universityId }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom, 15)
                }
            }
        }
    }
    
    @ViewBuilder
    var recommendedSection: some View {
        if firebaseService.isAuthenticated && !filteredRecommendedPrograms.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                ExploreSectionHeader(
                    title: "Rekomendowane dla Ciebie",
                    icon: "sparkles",
                    actionText: "Zobacz więcej",
                    action: { 
                        // TODO: Navigate to full recommendations
                    }
                )
                
                VStack(spacing: 16) {
                    ForEach(filteredRecommendedPrograms.prefix(3)) { program in
                        RecommendedProgramCard(
                            program: program,
                            university: universities.first { $0.id == program.universityId }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ExploreSectionHeader(
                title: "Przeglądaj kategorie",
                icon: "square.grid.2x2.fill",
                actionText: "Zobacz wszystkie",
                action: { 
                    // TODO: Navigate to full categories list
                }
            )
            
            CategoryGridView()
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    var topUniversitiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            ExploreSectionHeader(
                title: "Top uczelnie",
                icon: "building.columns.fill",
                actionText: "Zobacz ranking",
                action: { 
                    showingAllUniversities = true
                }
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Show top 10 universities sorted by ranking
                    ForEach(universities.filter { $0.ranking != nil }.sorted { ($0.ranking ?? 0) < ($1.ranking ?? 0) }.prefix(10)) { university in
                        MinimalistUniversityCardWithSheet(university: university)
                    }
                    
                    // "See all universities" card
                    NavigationLink(destination: UniversityListView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 140, height: 140)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                                
                                Text("Zobacz wszystkie")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Text("uczelnie")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
        }
    }
    
    @ViewBuilder
    var citiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ExploreSectionHeader(
                title: "Miasta",
                icon: "mappin.circle.fill",
                actionText: "Zobacz wszystkie",
                action: { 
                    // TODO: Navigate to all cities view
                }
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(getCityData()) { city in
                        Button(action: {
                            selectedCityDetail = city
                            showingCityDetail = true
                        }) {
                            ExploreCityCard(city: city)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FilterSectionView(
                    selectedMode: $selectedMode,
                    selectedCity: $selectedCity,
                    selectedDegree: $selectedDegree,
                    cities: cities
                )
                
                trendingSection
                
                forYouSection
                
                topUniversitiesSection
                
                recommendedSection
                
                citiesSection
                
                categoriesSection
                
                .padding(.bottom, 24)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .navigationTitle("Eksploruj")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
        .onAppear {
            loadData()
        }
        .sheet(isPresented: $showingAllUniversities) {
            NavigationView {
                UniversityListView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Zamknij") {
                                showingAllUniversities = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $showingCityDetail) {
            if let city = selectedCityDetail {
                NavigationView {
                    CityDetailView(city: city)
                }
            }
        }
    }
    
    private func loadData() {
        // In real app, this would fetch from Firebase
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.universities = mockData.mockUniversities
            
            // Get all available programs
            let allPrograms = mockData.mockPrograms + createAdditionalPrograms()
            
            // Shuffle and distribute programs randomly
            let shuffledPrograms = allPrograms.shuffled()
            
            // Trending: Random selection of programs
            self.trendingPrograms = Array(shuffledPrograms.shuffled().prefix(12))
            
            // For You: Different random selection
            self.forYouPrograms = Array(shuffledPrograms.shuffled().prefix(8))
            
            // Recommended: Another random selection
            self.recommendedPrograms = Array(shuffledPrograms.shuffled().prefix(10))
            
            self.isLoading = false
        }
    }
    
    private func createAdditionalPrograms() -> [StudyProgram] {
        // Additional diverse programs to increase variety
        return [
            StudyProgram(
                id: "uw-cognitive-science",
                universityId: "uw",
                name: "Cognitive Science",
                faculty: "Wydział Psychologii",
                field: "Nauki kognitywne",
                degree: .bachelor,
                mode: .stationary,
                duration: 6,
                language: "Angielski",
                description: "Interdyscyplinarne studia łączące psychologię, neuronaukę i AI",
                requirements: mockData.mockPrograms[0].requirements,
                tuitionFee: 0,
                availableSlots: 60,
                lastYearThreshold: 89.5,
                tags: ["AI", "Neurobiologia", "Psychologia kognitywna"],
                imageURL: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800",
                thumbnailURL: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400",
                applicationURL: "https://irk.uw.edu.pl/kierunki/cognitive-science"
            ),
            StudyProgram(
                id: "pw-cybersecurity",
                universityId: "pw",
                name: "Cyberbezpieczeństwo",
                faculty: "Wydział Elektroniki i Technik Informacyjnych",
                field: "Informatyka",
                degree: .engineer,
                mode: .stationary,
                duration: 7,
                language: "Polski",
                description: "Specjalistyczne studia z zakresu bezpieczeństwa cyfrowego",
                requirements: mockData.mockPrograms[2].requirements,
                tuitionFee: 0,
                availableSlots: 80,
                lastYearThreshold: 91.2,
                tags: ["Ethical Hacking", "Kryptografia", "Security"],
                imageURL: "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800",
                thumbnailURL: "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=400"
            ),
            StudyProgram(
                id: "sgh-data-science",
                universityId: "sgh",
                name: "Data Science & Business Analytics",
                faculty: "Kolegium Analiz Ekonomicznych",
                field: "Analityka danych",
                degree: .bachelor,
                mode: .stationary,
                duration: 6,
                language: "Angielski",
                description: "Nowoczesne studia łączące analizę danych z biznesem",
                requirements: mockData.mockPrograms[0].requirements,
                tuitionFee: 15000,
                availableSlots: 100,
                lastYearThreshold: 87.8,
                tags: ["Big Data", "Machine Learning", "Business Intelligence"],
                imageURL: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800",
                thumbnailURL: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400"
            ),
            StudyProgram(
                id: "uj-sustainable-development",
                universityId: "uj",
                name: "Zrównoważony rozwój",
                faculty: "Wydział Biologii i Nauk o Ziemi",
                field: "Nauki o środowisku",
                degree: .bachelor,
                mode: .stationary,
                duration: 6,
                language: "Polski",
                description: "Studia odpowiadające na wyzwania klimatyczne",
                requirements: mockData.mockPrograms[0].requirements,
                tuitionFee: 0,
                availableSlots: 50,
                lastYearThreshold: 82.3,
                tags: ["Ekologia", "ESG", "Zielona energia"]
            ),
            StudyProgram(
                id: "agh-space-technology",
                universityId: "agh",
                name: "Technologie kosmiczne i satelitarne",
                faculty: "Wydział Inżynierii Mechanicznej i Robotyki",
                field: "Inżynieria kosmiczna",
                degree: .engineer,
                mode: .stationary,
                duration: 7,
                language: "Polski",
                description: "Unikalne studia z zakresu technologii kosmicznych",
                requirements: mockData.mockPrograms[2].requirements,
                tuitionFee: 0,
                availableSlots: 40,
                lastYearThreshold: 90.5,
                tags: ["SpaceX", "Satelity", "Astrofizyka"]
            )
        ] + createForYouPrograms() // Combine all additional programs
    }
    
    private func getCityData() -> [CityInfo] {
        return [
            CityInfo(name: "Warszawa", universityCount: 76, imageURL: "https://images.pexels.com/photos/2613438/pexels-photo-2613438.jpeg", color: .red),
            CityInfo(name: "Kraków", universityCount: 31, imageURL: "https://images.pexels.com/photos/46273/pexels-photo-46273.jpeg", color: .purple),
            CityInfo(name: "Wrocław", universityCount: 27, imageURL: "https://images.unsplash.com/photo-1590479773265-7464e5d48118?w=800", color: .blue),
            CityInfo(name: "Poznań", universityCount: 25, imageURL: "https://images.unsplash.com/photo-1566139971529-b5a7ed5eb07e?w=800", color: .green),
            CityInfo(name: "Gdańsk", universityCount: 21, imageURL: "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800", color: .cyan),
            CityInfo(name: "Łódź", universityCount: 18, imageURL: "https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=800", color: .orange),
            CityInfo(name: "Katowice", universityCount: 15, imageURL: "https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=800", color: .indigo),
            CityInfo(name: "Lublin", universityCount: 13, imageURL: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800", color: .pink),
            CityInfo(name: "Szczecin", universityCount: 11, imageURL: "https://images.unsplash.com/photo-1580979913832-64b9eace7fe7?w=800", color: .teal)
        ]
    }
    
    private func createForYouPrograms() -> [StudyProgram] {
        return [
            StudyProgram(
                id: "uw-psychology",
                universityId: "uw",
                name: "Psychologia",
                faculty: "Wydział Psychologii",
                field: "Psychologia",
                degree: .unified,
                mode: .stationary,
                duration: 10,
                language: "Polski",
                description: "Jednolite studia magisterskie z psychologii",
                requirements: mockData.mockPrograms[1].requirements,
                tuitionFee: 0,
                availableSlots: 120,
                lastYearThreshold: 85.7,
                tags: ["Psychologia kliniczna", "Neuropsychologia", "Terapia"],
                imageURL: "https://images.unsplash.com/photo-1573497620053-ea5300f94f21?w=800",
                thumbnailURL: "https://images.unsplash.com/photo-1573497620053-ea5300f94f21?w=400"
            ),
            StudyProgram(
                id: "uj-psychology-law",
                universityId: "uj",
                name: "Psychologia sądowa",
                faculty: "Wydział Prawa i Administracji",
                field: "Psychologia",
                degree: .bachelor,
                mode: .stationary,
                duration: 6,
                language: "Polski",
                description: "Unikalne połączenie psychologii z prawem",
                requirements: mockData.mockPrograms[1].requirements,
                tuitionFee: 0,
                availableSlots: 45,
                lastYearThreshold: 83.2,
                tags: ["Kryminologia", "Profilowanie", "Mediacje"],
                imageURL: "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800",
                thumbnailURL: "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400"
            ),
            StudyProgram(
                id: "uw-criminology",
                universityId: "uw",
                name: "Kryminologia",
                faculty: "Wydział Stosowanych Nauk Społecznych i Resocjalizacji",
                field: "Nauki społeczne",
                degree: .bachelor,
                mode: .stationary,
                duration: 6,
                language: "Polski",
                description: "Interdyscyplinarne studia o przestępczości",
                requirements: mockData.mockPrograms[1].requirements,
                tuitionFee: 0,
                availableSlots: 60,
                lastYearThreshold: 79.8,
                tags: ["Prawo karne", "Psychologia", "Socjologia"]
            ),
            StudyProgram(
                id: "sgh-psychology-business",
                universityId: "sgh",
                name: "Psychologia w biznesie",
                faculty: "Kolegium Ekonomiczno-Społeczne",
                field: "Psychologia",
                degree: .bachelor,
                mode: .stationary,
                duration: 6,
                language: "Polski",
                description: "Psychologia stosowana w zarządzaniu i marketingu",
                requirements: mockData.mockPrograms[1].requirements,
                tuitionFee: 12000,
                availableSlots: 80,
                lastYearThreshold: 81.5,
                tags: ["HR", "Marketing", "Coaching"]
            )
        ] + mockData.mockPrograms.filter { 
            $0.name.contains("Prawo") || $0.field.contains("Prawo")
        }
    }
}

// MARK: - Filter Section
struct FilterSectionView: View {
    @Binding var selectedMode: StudyMode?
    @Binding var selectedCity: String?
    @Binding var selectedDegree: Degree?
    let cities: [String]
    
    var activeFiltersCount: Int {
        var count = 0
        if selectedMode != nil { count += 1 }
        if selectedCity != nil { count += 1 }
        if selectedDegree != nil { count += 1 }
        return count
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Study Mode Dropdown
                Menu {
                    Button(action: { selectedMode = nil }) {
                        Label("Wszystkie tryby", systemImage: selectedMode == nil ? "checkmark" : "")
                    }
                    Divider()
                    ForEach(StudyMode.allCases, id: \.self) { mode in
                        Button(action: { selectedMode = mode }) {
                            Label(mode.rawValue, systemImage: selectedMode == mode ? "checkmark" : "")
                        }
                    }
                } label: {
                    FilterDropdownLabel(
                        title: selectedMode?.rawValue ?? "Tryb studiów",
                        isActive: selectedMode != nil,
                        icon: "clock"
                    )
                }
                
                // City Dropdown
                Menu {
                    Button(action: { selectedCity = nil }) {
                        Label("Wszystkie miasta", systemImage: selectedCity == nil ? "checkmark" : "")
                    }
                    Divider()
                    ForEach(cities, id: \.self) { city in
                        Button(action: { selectedCity = city }) {
                            Label(city, systemImage: selectedCity == city ? "checkmark" : "")
                        }
                    }
                } label: {
                    FilterDropdownLabel(
                        title: selectedCity ?? "Miasto",
                        isActive: selectedCity != nil,
                        icon: "mappin"
                    )
                }
                
                // Degree Dropdown
                Menu {
                    Button(action: { selectedDegree = nil }) {
                        Label("Wszystkie stopnie", systemImage: selectedDegree == nil ? "checkmark" : "")
                    }
                    Divider()
                    ForEach(Degree.allCases, id: \.self) { degree in
                        Button(action: { selectedDegree = degree }) {
                            Label(degree.rawValue, systemImage: selectedDegree == degree ? "checkmark" : "")
                        }
                    }
                } label: {
                    FilterDropdownLabel(
                        title: selectedDegree?.rawValue ?? "Stopień",
                        isActive: selectedDegree != nil,
                        icon: "graduationcap"
                    )
                }
                
                // Clear filters button
                if activeFiltersCount > 0 {
                    Button(action: {
                        selectedMode = nil
                        selectedCity = nil
                        selectedDegree = nil
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                            Text("Wyczyść (\(activeFiltersCount))")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct FilterDropdownLabel: View {
    let title: String
    let isActive: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(title)
                .font(.subheadline)
            Image(systemName: "chevron.down")
                .font(.caption2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isActive ? Color.blue.opacity(0.1) : Color(.systemGray6))
        .foregroundColor(isActive ? .blue : .primary)
        .cornerRadius(20)
    }
}

#Preview {
    NavigationView {
        ExploreFeedView()
    }
}
