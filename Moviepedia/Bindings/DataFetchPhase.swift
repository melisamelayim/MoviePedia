//
//  DataFetchPhase.swift
//  Moviepedia
//
//  Created by Max on 17.01.2025.
//

import Foundation

enum DataFetchPhase<V> { // V is a generic type, a placeholder so you can use either a string, a movie, an int. you decide.
    
    case empty
    case success(V)
    case failure(Error)
    
    var value: V? { // computed property
        if case .success(let value) = self { // basically means, if the case is successful then value is itself, if it failed then it's nil. got it? this is called "pattern matching", a basic vibe check for the value.
            return value
        }
        return nil
    }
    
}
