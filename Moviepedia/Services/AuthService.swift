//
//  AuthService.swift
//  Moviepedia
//
//  Created by Missy on 22.05.2025.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    func signUp(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = result?.user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: "SignUp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bilinmeyen hata"]))
                }
            }
        }
    }
    
    func signIn(email: String, password: String) async throws -> User {
        print("🔐 Sign-in başlıyor")
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("🚫 Giriş hatası: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let user = result?.user {
                    print("✅ Giriş başarılı, UID: \(user.uid)")
                    continuation.resume(returning: user)
                }
            }
        }
    }

    
    func sendPasswordReset(email: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume() // bu Void döndüğü için sıkıntı çıkmasın diye tipi belirttik
                }
            }
        }
    }


    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func currentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
    
}
