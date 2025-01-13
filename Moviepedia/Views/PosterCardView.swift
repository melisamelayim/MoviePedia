//
//  PosterCardView.swift
//  Moviepedia
//
//  Created by Max on 26.12.2024.
//

import SwiftUI

struct PosterCardView: View {
    let movie: Movie
    var showTitle: Bool = true
    
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {        
        ZStack {
            Color.gray.opacity(0.3)
                .cornerRadius(8)
                
            if let image = imageLoader.image { // create an "image" constant that takes it's value from imageLoader.image, which returns an UIImage (belongs to UIKit), if let bcz it could be nil
                Image(uiImage: image) // translate that UIImage into Image() which belongs to SwiftUI, the translator is written as uiImage bcz that's how it works in SwiftUI, it's trying to differentiate UIImage and uiImage(belongs to SwiftUI)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(8)
                    .shadow(radius: 8)
            } else {
                if showTitle {
                    Text(movie.title)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .lineLimit(4)
                        .font(.headline)
                }
            }
        }
        .onAppear {
            if let posterURL = movie.posterURL {
                imageLoader.loadImage(with: posterURL)
            } else {
                print("Poster URL'si mevcut değil.")
            }
        }
    }
}

struct PosterCardView_Previews: PreviewProvider {
    static var previews: some View {
        PosterCardView(movie: Movie.stubbedMovie)
            .frame(height: 160)
            .padding()
    }
}
