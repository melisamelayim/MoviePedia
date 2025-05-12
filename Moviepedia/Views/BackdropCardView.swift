//
//  BackdropCardView.swift
//  Moviepedia
//
//  Created by Max on 26.12.2024.
//

import SwiftUI

import SwiftUI

struct BackdropCardView: View {
    let movie: Movie
    
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 175)
                    .cornerRadius(12)
                    .clipped()
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 200)
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 200)
                    .cornerRadius(12)
                    .overlay(
                        Text(movie.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    )
            }
        }
        .onAppear {
            if let backdropURL = movie.backdropURL {
                imageLoader.loadImage(with: backdropURL)
            }
        }
    }
}

struct BackdropCardView_Previews: PreviewProvider {
    static var previews: some View {
        BackdropCardView(movie: Movie.stubbedMovie)
            .frame(height: 160)
            .padding()
    }
}
