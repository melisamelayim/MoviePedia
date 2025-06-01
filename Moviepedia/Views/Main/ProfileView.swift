//
//  ProfileView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Kullanıcı")) {
                    Text("E-posta: \(authVM.email.isEmpty ? "Giriş yapılmadı" : authVM.email)")
                    Button("Çıkış Yap") {
                        authVM.logout()
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("Ayarlar")) {
                    NavigationLink("Tema", destination: Text("Tema Ayarları"))
                    NavigationLink("Bildirimler", destination: Text("Bildirim Ayarları"))
                }
            }
            .navigationTitle("Profil")
        }
    }
}


#Preview {
    ProfileView()
}
