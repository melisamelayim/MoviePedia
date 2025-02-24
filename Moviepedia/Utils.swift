//
//  Utils.swift
//  Moviepedia
//
//  Created by Max on 11.12.2024.
//

import Foundation

class Utils {
    static let customJSONDecoder: JSONDecoder = { // use of "static" lets customJSONDecoder be directly reachable without the need to create an instance. like: Utils.customJSONDecoder.
        // also, JSONDecoder is used without () because it's just defining a type. (like a cookbook, if you use it with () it's food)
        
        let decoder = JSONDecoder() // used () at the end of this JSODecoder because an instance is created here, but not at above
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }() // customize customJSONDecoder by using closure format
    // }() means terminate this closure right away, also called "lazy initialization with closure"
    // which also lets us create a JSONDecoder *once* and is customized
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
