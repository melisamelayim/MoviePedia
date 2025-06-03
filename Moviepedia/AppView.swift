//
//  AppView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import SwiftUI
import Firebase

struct AppView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var recommendationVM: RecommendationViewModel
    
    var body: some View {
        Group {
            if authVM.isLoggedIn {
                MainTabView()
                    .onAppear {
                        favoritesVM.fetchAll()
                    }
            } else {
                LoginView()
            }
        }
    }
    
}
                
                
#Preview {
    AppView()
}
