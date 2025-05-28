//
//  UniversityListView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct UniversityListView: View {
    @State private var universities: [University] = []
    @State private var searchText = ""
    @State private var selectedType: UniversityType? = nil
    @State private var selectedCity: String? = nil
    @State private var isLoading = true
    @State private var showingFilters = false
    
    private let mockData = MockDataService.shared
    
    var cities: [String] {
        Array(Set(universities.map { $0.city })).sorted()
    }
    
    var filteredUniversities: [University] {
        universities.filter { university in
            let matchesSearch = searchText.isEmpty ||
                university.name.localizedCaseInsensitiveContains(searchText) ||
                university.city.localizedCaseInsensitiveContains(searchText)
            
            let matchesType = selectedType == nil || university.type == selectedType
            let matchesCity = selectedCity == nil || university.city == selectedCity
            
            return matchesSearch && matchesType && matchesCity
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                // Search and filter bar
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Szukaj uczelni...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterButton(
                                title: "Filtry",
                                systemImage: "line.3.horizontal.decrease.circle",
                                isActive: selectedType != nil || selectedCity != nil,
                                action: { showingFilters = true }
                            )
                            
                            if selectedType != nil {
                                ActiveFilterChip(
                                    title: selectedType!.rawValue,
                                    onRemove: { selectedType = nil }
                                )
                            }
                            
                            if let city = selectedCity {
                                ActiveFilterChip(
                                    title: city,
                                    onRemove: { selectedCity = nil }
                                )
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Universities list
                if isLoading {
                    Spacer()
                    ProgressView("Ładowanie uczelni...")
                    Spacer()
                } else if filteredUniversities.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "building.columns")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("Nie znaleziono uczelni")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Spróbuj zmienić kryteria wyszukiwania")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(filteredUniversities) { university in
                            NavigationLink(destination: UniversityDetailView(university: university)) {
                                UniversityRowView(university: university)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Uczelnie")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    selectedType: $selectedType,
                    selectedCity: $selectedCity,
                    availableCities: cities
                )
            }
        .onAppear {
            loadUniversities()
        }
    }
    
    private func loadUniversities() {
        // In real app, this would fetch from Firebase
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.universities = mockData.mockUniversities
            self.isLoading = false
        }
    }
}

struct UniversityRowView: View {
    let university: University
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // University logo placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(university.shortName ?? String(university.name.prefix(2)))
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(university.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label(university.type.rawValue, systemImage: "building.2")
                        .font(.caption)
                    
                    Label(university.city, systemImage: "mappin")
                        .font(.caption)
                    
                    if let ranking = university.ranking {
                        Label("#\(ranking)", systemImage: "trophy")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .foregroundColor(.secondary)
                
                if let studentCount = university.studentCount {
                    Text("\(studentCount / 1000)k studentów")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct FilterButton: View {
    let title: String
    let systemImage: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isActive ? Color.blue : Color(.systemGray5))
                .foregroundColor(isActive ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ActiveFilterChip: View {
    let title: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.1))
        .foregroundColor(.blue)
        .cornerRadius(15)
    }
}

struct FilterView: View {
    @Binding var selectedType: UniversityType?
    @Binding var selectedCity: String?
    let availableCities: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Typ uczelni")) {
                    ForEach(UniversityType.allCases, id: \.self) { type in
                        HStack {
                            Text(type.rawValue)
                            Spacer()
                            if selectedType == type {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedType = selectedType == type ? nil : type
                        }
                    }
                }
                
                Section(header: Text("Miasto")) {
                    ForEach(availableCities, id: \.self) { city in
                        HStack {
                            Text(city)
                            Spacer()
                            if selectedCity == city {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCity = selectedCity == city ? nil : city
                        }
                    }
                }
                
                Section {
                    Button("Wyczyść filtry") {
                        selectedType = nil
                        selectedCity = nil
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Gotowe") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    UniversityListView()
}