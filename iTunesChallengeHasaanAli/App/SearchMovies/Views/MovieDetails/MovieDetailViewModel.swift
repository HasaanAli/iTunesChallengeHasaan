//
//  MovieDetailViewModel.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import Foundation
import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie

    // Cancellables
    private var cancellables = Set<AnyCancellable>()

    // Dependencies
    private let moviesRepo: iTunesRepositoryProtocol? = DependencyContainer.shared.moviesRepository
    private let moviesManager: MoviesManager? = DependencyContainer.shared.moviesManager

    init(movie: Movie) {
        self.movie = movie

        // Setup bindings
        setupBindings()
    }

    private func setupBindings() {
        whenMovieIsUpdatedInRepoUpdateItHere()
    }

    private func whenMovieIsUpdatedInRepoUpdateItHere() {
        moviesRepo?.movieUpdatedSubject
            .sink { [weak self] updatedMovie in
                guard let self else { return }
                // find matching movie by id and replace the object
                if self.movie.id == updatedMovie.id {
                    self.movie = updatedMovie
                }
            }
            .store(in: &cancellables)
    }

    func tappedFavorite() {
        if movie.isFavorite {
            moviesManager?.unmarkFavorite(movie: movie)
        } else {
            moviesManager?.markFavorite(movie: movie)
        }
    }
}
