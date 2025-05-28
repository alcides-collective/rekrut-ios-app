//
//  MainTabView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingProfile = false
    @StateObject private var firebaseService = FirebaseService.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationViewWithProfile(showingProfile: $showingProfile) {
                ExploreView()
            }
            .tabItem {
                Label("Eksploruj", systemImage: "square.grid.2x2")
            }
            .tag(0)
            
            NavigationViewWithProfile(showingProfile: $showingProfile) {
                ErasmusView()
            }
            .tabItem {
                Label("Erasmus+", systemImage: "airplane")
            }
            .tag(1)
            
            NavigationViewWithProfile(showingProfile: $showingProfile) {
                AIMatchView()
            }
            .tabItem {
                Label("AI Match", systemImage: "sparkles")
            }
            .tag(2)
            
            NavigationViewWithProfile(showingProfile: $showingProfile) {
                SimplestMaturaCalculatorView()
            }
            .tabItem {
                Label("Matury", systemImage: "graduationcap")
            }
            .tag(3)
            
            NavigationViewWithProfile(showingProfile: $showingProfile) {
                SearchView()
            }
            .tabItem {
                Label("Szukaj", systemImage: "magnifyingglass")
            }
            .tag(4)
        }
        .accentColor(.blue)
        .background(Color.white)
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
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
        .background(Color.white)
    }
}

#Preview {
    MainTabView()
}