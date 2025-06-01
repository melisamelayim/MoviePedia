//
//  MainTabView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Anasayfa")
                }

            CollectionView()
                .tag(1)
                .tabItem {
                    Image(systemName: "square.stack.fill")
                    Text("Koleksiyon")
                }

            ProfileView()
                .tag(2)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profil")
                }
        }
    }
}


#Preview {
    MainTabView()
}
