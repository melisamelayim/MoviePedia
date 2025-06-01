//
//  ForgotPasswordView.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Şifremi Unuttum")
                    .font(.largeTitle)
                    .bold()

                TextField("Email adresini gir", text: $authVM.email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                Button("Sıfırlama Maili Gönder") {
                    Task {
                        await authVM.resetPassword()
                    }
                }
                .buttonStyle(.borderedProminent)

                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Şifre Sıfırlama")
        }
    }
}


#Preview {
    ForgotPasswordView()
}
