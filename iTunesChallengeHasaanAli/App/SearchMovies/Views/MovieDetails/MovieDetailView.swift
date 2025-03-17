//
//  MovieDetailView.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import SwiftUI

/// View to show movie details.
struct MovieDetailView: View {
    @StateObject private var vm: MovieDetailViewModel

    init(movie: Movie) {
        _vm = .init(wrappedValue: MovieDetailViewModel(movie: movie))
    }

    var body: some View {
        ScrollView {
            VStack {
                MovieImageView(imageUrl: vm.movie.localArtURL)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                    .frame(width: 300, height: 300)
                    .foregroundStyle(Color.purple)

                HStack {
                    VStack(alignment: .leading) {
                        Text(vm.movie.name)
                            .font(.title3)

                        Text(vm.movie.genre).fontWeight(.semibold)
                        Text("\(vm.movie.priceUSD, specifier: "%.2f") $").fontWeight(.semibold)

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Description:").fontWeight(.semibold)
                            Text(vm.movie.longDescription ?? "NA")

                        }
                    }
                    Spacer()
                    // spacer is needed to fully expand the texts container so that its
                    // leading alignment is effective
                }
            }
            .padding()
        }
        .navigationTitle(titleText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                MovieFavoriteButton(isFavorite: vm.movie.isFavorite) {
                    vm.tappedFavorite()
                }
            }
        }
    }

    var titleText: Text {
        Text(vm.movie.name)
    }
}

#Preview {
    MovieDetailView(movie: Movie.first)
}
