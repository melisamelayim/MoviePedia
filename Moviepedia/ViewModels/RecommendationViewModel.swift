//
//  RecommendationViewModel.swift
//  Moviepedia
//
//  Created by Missy on 12.05.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class RecommendationViewModel: ObservableObject {
    @Published var recommendedMovies: [DisplayMovie] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func listenToRecommendations() {
        listener?.remove()
        listener = nil
        
        guard let userId = AuthService.shared.currentUserId() else {
            print("Kullanıcı yok, öneriler dinlenemiyor")
            return
        }

        let ref = db.collection("users").document(userId).collection("recommendations")

        listener = ref.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Listener error: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("Snapshot boş")
                return
            }

            print("🔥 Snapshot changed, documents count: \(documents.count)")
            
            let movies: [DisplayMovie] = documents.compactMap { doc in
                let data = doc.data()
                guard
                    let title = data["title"] as? String,
                    let tagline = data["tagline"] as? String,
                    let backdropPath = data["backdropPath"] as? String
                else {
                    print("Recommendation bulunamadı")
                    return nil
                }

                return DisplayMovie(
                    id: Int(doc.documentID) ?? -1,
                    title: title,
                    tagline: tagline,
                    backdropPath: backdropPath
                )
            }

            DispatchQueue.main.async {
                self?.recommendedMovies = [] // Force change
                self?.recommendedMovies = movies
                print("🔥 Updating recommendedMovies with \(movies.count) items") // 🔥 burada da yazdıralım

            }
        }
    }

    func detachListener() {
        listener?.remove()
        listener = nil
    }

    func sendFavoriteIdsToBackend(favoriteIds: [Int]) async {
        guard let userId = AuthService.shared.currentUserId() else {
            print("Kullanıcı yok, backend'e gönderilemedi")
            return
        }

        guard let url = URL(string: "http://localhost:8000/generate-recommendations") else {
            print("Geçersiz URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = [
            "user_id": userId,
            "favorite_ids": favoriteIds
        ] as [String : Any]

        do {
            print("👉 Sending favorite IDs to backend: \(favoriteIds)")  // 🔥 BURAYA
            
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("✅ POST request status code: \(httpResponse.statusCode)")  // 🔥 BURAYA
                if httpResponse.statusCode != 200 {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("❌ Server error: \(errorMessage)")
                }
            }
            
        } catch {
            print("❌ Error sending favorite IDs to backend: \(error.localizedDescription)")
        }
    }
}
