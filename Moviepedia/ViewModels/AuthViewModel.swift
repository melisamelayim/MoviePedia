//
//  AuthViewModel.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false

    func login() async {
        do {
            let user = try await AuthService.shared.signIn(email: email, password: password)
            print("login successful: \(user.uid)")
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func register() async {
        do {
            let user = try await AuthService.shared.signUp(email: email, password: password)
            print("register successful: \(user.uid)")
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        do {
            try AuthService.shared.signOut()
            isLoggedIn = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resetPassword() async {
        do {
            try await AuthService.shared.sendPasswordReset(email: email)
            errorMessage = "Şifre sıfırlama e-postası gönderildi."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

}

