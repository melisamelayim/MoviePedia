//
//  FavoritesViewModel.swift
//  Moviepedia
//
//  Created by Max on 22.02.2025.
//

import FirebaseFirestore
import SwiftUI
import FirebaseAuth

class FavoritesViewModel: ObservableObject { // used observableobject so views are automatically triggered when changes happen
    private let db = Firestore.firestore() // created an instance to access the firestore db, which is only accessable from here in this class, not anywhere else. also, this is only the referance, like, the connection variable. therefore, even tho we keep updating the db with data, out connection path is never going to change, that's why we use "let". so "db" is just a short-cut for that path.
    
    @Published var favoriteMovies: [String] {
        didSet{
            UserDefaults.standard.set(favoriteMovies, forKey: "favoriteMovies")
        } // what that means is that, everytime favoriteMovies array gets triggered, this code will execute immediately after the change. in our case, it saves the updated array to userdefaults.
    }
    
    init() {
        self.favoriteMovies = UserDefaults.standard.stringArray(forKey: "favoriteMovies") ?? []
    } // whenever an object (from this class) is created, it wil initially bring the fav movies array from the local memory
    
    
    func toggleFavorite(movieId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userDataRef = db.collection("users").document(userId) // reaching spesific users db collection

        let updateValue: [String: Any] = favoriteMovies.contains(movieId) ? // clean. code.
            ["favorites": FieldValue.arrayRemove([movieId])] :
            ["favorites": FieldValue.arrayUnion([movieId])]

        userDataRef.setData(updateValue, merge: true) { error in
            if error == nil {
                DispatchQueue.main.async {
                    if self.favoriteMovies.contains(movieId) {
                        self.favoriteMovies.removeAll { $0 == movieId }
                    } else {
                        self.favoriteMovies.append(movieId)
                    }
                }
            }
        }
    }


    
    
}
