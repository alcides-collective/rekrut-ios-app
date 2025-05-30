//
//  ExploreView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct ExploreView: View {
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
                            Text("Odkrywaj")
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
                        
                        ExploreFeedView()
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
                            Text("Odkrywaj")
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

struct TitleScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ExploreView()
}