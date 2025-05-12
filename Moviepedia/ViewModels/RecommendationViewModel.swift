//
//  RecommendationViewModel.swift
//  Moviepedia
//
//  Created by Missy on 12.05.2025.
//

import SwiftUI
import FirebaseFirestore

class RecommendationViewModel: ObservableObject {
    @Published var recommendedMovies: [RecommendedMovie] = []
    
    private let db = Firestore.firestore()
    
    func fetchRecommendations(for userId: String) {
        let ref = db.collection("users").document(userId).collection("recommendations")
        
        ref.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents, error == nil else {
                print("firestore error")
                return
            }
                
            self.recommendedMovies = docs.compactMap { doc in
                let data = doc.data()
                guard
                    let title = data["title"] as? String,
                    let posterPath = data["posterPath"] as? String,
                    let score = data["score"] as? Double,
                    let id = Int(doc.documentID)
                else { return nil }
                
                return RecommendedMovie(id: id, title: title, posterPath: posterPath, score: score)
            }
            .sorted { $0.score > $1.score }
        }
    }
    
}
