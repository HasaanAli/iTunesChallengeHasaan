//
//  Movie.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 13/03/2025.
//

import Foundation

/// Domain model to store necessary movie information. It includes properties that are received from the API and also those that are managed in-app
/// like isFavorite.
struct Movie: Hashable, Identifiable {
    /// The unique id of object.
    let id: String
    /// Movie name.
    let name: String
    /// An artwork URL if it is available for this movie.
    let remoteArtURL: URL?
    /// An artwork local URL available after it is downloaded to device storage.
    private(set) var localArtURL: URL?

    /// Price of the movie on iTunes, in USD.
    let priceUSD: Double

    /// Genre of the movie.
    let genre: String

    /// Long description of the movie.
    let longDescription: String?

    /// Whether it is favorite movie marked by the user. This is in-app property.
    private(set) var isFavorite: Bool

    /// Returns a copy of the current object with `isFavorite` set to given value.
    func marking(favorite: Bool) -> Movie {
        var movie = self
        movie.isFavorite = favorite
        return movie
    }

    /// Returns a copy of the current object with `localArtURL` set to given value.
    func setting(localArtURL: URL?) -> Movie {
        var movie = self
        movie.localArtURL = localArtURL
        return movie
    }

    // MARK: Test data for testing or UI previews.

    static let first = Movie(id: "1", name: "Transformer", remoteArtURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video123/v4/18/98/ce/1898cea4-56a5-0542-c115-f1057ed45fea/pr_source.lsr/100x100bb.jpg")!,
                             localArtURL: nil,
                             priceUSD: 1, genre: "sci-fi", longDescription: "Cars or robots?", isFavorite: false)
    static let second = Movie(id: "2", name: "Transformer 2", remoteArtURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video123/v4/18/98/ce/1898cea4-56a5-0542-c115-f1057ed45fea/pr_source.lsr/100x100bb.jpg")!,
                              localArtURL: nil,
                              priceUSD: 1, genre: "sci-fi", longDescription: "Cars or robots?", isFavorite: true)
}
