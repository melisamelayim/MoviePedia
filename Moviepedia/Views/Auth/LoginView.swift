//
//  LoginView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Email", text: $authVM.email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Şifre", text: $authVM.password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Giriş Yap") {
                    Task {
                        await authVM.login()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink("Hesabın yok mu? Kayıt ol") {
                    RegisterView()
                        .environmentObject(authVM)
                }
                NavigationLink("Şifremi unuttum") {
                    ForgotPasswordView()
                        .environmentObject(authVM)
                }
                
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }
            }
            .padding()
            .navigationTitle("Giriş")
        }
    }
    
}



#Preview {
    LoginView()
}
