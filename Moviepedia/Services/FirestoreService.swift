//
//  FirestoreService.swift
//  Moviepedia
//
//  Created by Max on 22.02.2025.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    func addTestData() {
        let testCollection = db.collection("testData")
        
        testCollection.document("testDoc").setData([
            "name": "Hello Firebase!",
            "timestamp": Timestamp()
        ]) { error in
            if let error = error {
                print("Firestore'a veri eklenirken hata oluştu: \(error)")
            } else {
                print("Firestore bağlantısı başarılı!")
            }
        }
    }
}

