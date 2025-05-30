//
//  MainTabView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
            .tabItem {
                Label("Odkrywaj", systemImage: "safari")
            }
            .tag(0)
            
            ErasmusView()
            .tabItem {
                Label("Erasmus+", systemImage: "globe.europe.africa")
            }
            .tag(1)
            
            AIMatchView()
            .tabItem {
                Label("AI Match", systemImage: "sparkles")
            }
            .tag(2)
            
            InteractiveMaturaView()
            .tabItem {
                Label("Matury", systemImage: "sum")
            }
            .tag(3)
            
            SearchView()
            .tabItem {
                Label("Szukaj", systemImage: "magnifyingglass")
            }
            .tag(4)
        }
        .accentColor(.blue)
        .background(Color(.systemBackground))
    }
}

struct NavigationViewWithProfile<Content: View>: View {
    @Binding var showingProfile: Bool
    @StateObject private var firebaseService = FirebaseService.shared
    let content: () -> Content
    
    var body: some View {
        NavigationView {
            content()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingProfile = true
                        }) {
                            Image(systemName: firebaseService.isAuthenticated ? "person.crop.circle.fill" : "person.crop.circle")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color(.systemBackground))
    }
}

#Preview {
    MainTabView()
}