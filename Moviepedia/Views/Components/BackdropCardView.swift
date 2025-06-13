//
//  BackdropCardView.swift
//  Moviepedia
//
//  Created by Max on 26.12.2024.
//

import SwiftUI

struct BackdropCardView: View {
    let displayMovie: DisplayMovie
    
    @EnvironmentObject var favoritesVM: FavoritesViewModel
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
                
                Text(displayMovie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 220)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                Text(displayMovie.tagline)
                    .padding(.top, 260)
                    .padding(.horizontal, 20)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .lineLimit(nil) // Çok satıra yayılsın                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 200)
                    .cornerRadius(12)
                    .overlay(
                        Text(displayMovie.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    )
            }
            WatchlistButtonView(movie: displayMovie)
                .environmentObject(favoritesVM)
        }
        .onAppear{
            if let url = displayMovie.backdropURL {
                imageLoader.loadImage(with: url)
            } else {
                print("backdrop url not accesible")
            }
        }
    }
}



/*struct BackdropCardView_Previews: PreviewProvider {
    static var previews: some View {
        BackdropCardView(movie: Movie.stubbedMovie)
            .frame(height: 160)
            .padding()
    }
}
*/
