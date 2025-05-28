import SwiftUI

struct SearchSuggestionsView: View {
    @Binding var recentSearches: [String]
    let popularSearches: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !recentSearches.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Ostatnie wyszukiwania")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button("Wyczyść") {
                            recentSearches.removeAll()
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                    }
                    
                    ForEach(recentSearches, id: \.self) { search in
                        Button(action: { onSelect(search) }) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                
                                Text(search)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.left")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                        
                        if search != recentSearches.last {
                            Divider()
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Popularne wyszukiwania")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ForEach(popularSearches, id: \.self) { search in
                    Button(action: { onSelect(search) }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            Text(search)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.left")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                    
                    if search != popularSearches.last {
                        Divider()
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

struct SearchSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSuggestionsView(
            recentSearches: .constant(["Informatyka", "Politechnika Warszawska", "Psychologia"]),
            popularSearches: ["Uniwersytet Warszawski", "Informatyka", "Medycyna", "Prawo", "Ekonomia"],
            onSelect: { _ in }
        )
    }
}