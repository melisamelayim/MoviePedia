//
//  FavoriteButtonView.swift
//  Moviepedia
//
//  Created by Max on 24.02.2025.
//

import SwiftUI

struct FavoriteButtonView: View {
    var isFavorite: Bool
    var onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .shadow(radius: 3)
                
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(isFavorite ? .red.opacity(0.7) : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle()) // soft animation
        
    }
}

#Preview {
    FavoriteButtonView(isFavorite: true, onToggle: {})
}
