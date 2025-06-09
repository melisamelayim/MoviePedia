//
//  ImageLoader.swift
//  Moviepedia
//
//  Created by Max on 26.12.2024.
//

import SwiftUI
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage? // optional because it could be nil if our url doesn't work
    @Published var isLoading = false
    
    var imageCache = _imageCache

    func loadImage(with url: URL) {
        let urlString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in // dispatch queue puts your code in a global line which is async so your main thread is not effected by it
            guard let self = self else { return } // literally says "are we still friends". to check if self is nil bcz of [weak self] since it weakens the self to prevent "retain cycle" (which means memory is stuck in a loop of selves :D we don't want that)
            do {
                let data = try Data(contentsOf: url) // where magic happens
                guard let image = UIImage(data: data) else {
                    return
                }
                self.imageCache.setObject(image, forKey: urlString as AnyObject) // save it to cache
                DispatchQueue.main.async { [weak self] in // update main thread, asyncly
                    self?.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

final class MovieCache {
    static let shared = MovieCache() // Singleton instance
    
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    
    var isMoviesLoaded = false
    private init() {}
}
