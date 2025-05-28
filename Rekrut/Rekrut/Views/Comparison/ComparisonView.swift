//
//  ComparisonView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct ComparisonView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "chart.bar.doc.horizontal")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Porównaj Kierunki")
                    .font(.title)
                    .bold()
                
                Text("Analizuj różnice między kierunkami studiów")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Wybierz kierunki do porównania")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.white)
            .navigationTitle("Porównaj")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ComparisonView()
}