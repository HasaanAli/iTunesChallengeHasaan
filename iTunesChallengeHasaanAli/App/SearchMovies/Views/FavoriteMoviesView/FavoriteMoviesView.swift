//
//  FavoriteMoviesView.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 15/03/2025.
//

import SwiftUI

/// A view to show horizontal scroll view of favorite movies like Instagram stories view.
struct FavoriteMoviesView: View {
    @StateObject private var vm = FavoriteMoviesViewModel()

    var body: some View {
        HStack {
            if vm.favoriteMovies.isEmpty {
                Text("Favorites appear here")
            } else {
                favoritesScrollView(movies: vm.favoriteMovies)
            }
        }
        .animation(.default, value: vm.favoriteMovies.isEmpty)
    }

    func favoritesScrollView(movies: [Movie]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                // spacer surrouding the favorite views to center them if they are few
                Spacer()
                ForEach(movies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        SingleFavoriteMovieView(movie: movie)
                            .frame(width: 100)
                            .padding(8)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 150)
    }
}

struct SingleFavoriteMovieView: View {
    let movie: Movie

    var body: some View {
        VStack(spacing: 0) {
            movieIconView
            Text(movie.name)
                .foregroundStyle(Color.black.opacity(0.8))
                .lineLimit(1)
        }
    }

    var movieIconView: some View {
        singleCircle
            .overlay {
                innerCircle
                    .padding(6)
            }
    }

    /// With pink red orange gradient
    @ViewBuilder
    var singleCircle: some View {
        let gradientWidth: CGFloat = 3
        let whiteAreaWidth: CGFloat = gradientWidth + 3

        Circle()
            .strokeBorder(Color.white, lineWidth: whiteAreaWidth)
            .strokeBorder(Gradient(colors: [ .purple, .pink, .orange]), lineWidth: gradientWidth)
            .rotationEffect(Angle(degrees: 45.0))
    }

    /// The movie icon circle
    var innerCircle: some View {
        MovieImageView(imageUrl: movie.localArtURL)
            .clipShape(Circle())
            .foregroundStyle(Color.purple) // if image is not available
            .overlay { // give circular border using overlay
                Circle()
                    .strokeBorder(Color.white.opacity(0.5), lineWidth: 0.5)
            }
    }
}

#Preview {
    let movie = Movie.first
    SingleFavoriteMovieView(movie: movie)
}
