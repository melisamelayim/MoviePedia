//
//  RegisterView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Kayıt Ol")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $authVM.email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                SecureField("Şifre", text: $authVM.password)
                    .textFieldStyle(.roundedBorder)

                Button("Hesap Oluştur") {
                    Task {
                        await authVM.register()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)

                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Kayıt")
        }
    }
}


#Preview {
    RegisterView()
}
