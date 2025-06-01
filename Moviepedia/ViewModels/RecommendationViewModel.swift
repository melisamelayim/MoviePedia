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

    func fetchRecommendations() async {
        guard let userId = AuthService.shared.currentUserId() else {
            print("Kullanıcı yok, öneriler çekilemedi")
            return
        }

        let ref = db.collection("users").document(userId).collection("recommendations")

        do {
            let snapshot = try await ref.getDocuments()
            let movies: [DisplayMovie] = snapshot.documents.compactMap { doc in
                let data = doc.data()
                guard
                    let title = data["title"] as? String,
                    let posterPath = data["posterPath"] as? String
                else { return nil }

                return DisplayMovie(
                    id: Int(doc.documentID) ?? -1,
                    title: title,
                    posterPath: posterPath
                )
            }
            self.recommendedMovies = movies
        } catch {
            print("Firestore öneri çekme hatası: \(error.localizedDescription)")
        }
    }
}

