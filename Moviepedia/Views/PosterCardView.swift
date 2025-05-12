//
//  PosterCardView.swift
//  Moviepedia
//
//  Created by Max on 26.12.2024.
//

import SwiftUI

struct PosterCardView: View {
    let title: String
    let posterURL: URL?
    var showTitle: Bool = true
    
    @ObservedObject var userMovieState: UserMovieState
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {        
        ZStack(alignment: .topTrailing) {
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
                    Text(title)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .lineLimit(4)
                        .font(.headline)
                }
            }
            /*WatchlistButtonView(movie: movie, userMovieState: userMovieState)
                            .padding(8)
                            .frame(alignment: .topLeading)*/
        }
        .onAppear {
            if let url = posterURL {
                imageLoader.loadImage(with: url)
            } else {
                print("Poster URL not accessible.")
            }
        }
    }
}


