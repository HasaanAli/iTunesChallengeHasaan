//
//  MoviesManager.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 13/03/2025.
//

import Foundation

/// Class to mark/unmark favorite movies.
class MoviesManager {

    // Dependencies
    private let repository: iTunesRepositoryProtocol

    /// Initialize MoviesManager with default or given dependencies.
    /// - Parameters:
    /// - Parameter repository: Instance of iTunesRepositoryProtocol. Optional.
    /// - Throws:iTunesRepository initialization error if repository parameter value is not given.
    init(repository: iTunesRepositoryProtocol? = nil) throws {
        if let repository {
            self.repository = repository
        } else {
            self.repository = try iTunesRepository()
        }
    }

    /// Mark a movie as favorite.
    func markFavorite(movie: Movie) {
        let movie = movie.marking(favorite: true)
        repository.saveOffline(movie: movie)
    }

    /// Mark a movie as not favorite.
    func unmarkFavorite(movie: Movie) {
        let movie = movie.marking(favorite: false)
        repository.removeOffline(movie: movie)
    }
}
