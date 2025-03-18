//
//  FavoriteMoviesViewModel.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 15/03/2025.
//

import Foundation
import Combine

class FavoriteMoviesViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []

    // Cancellables
    private var cancellables = Set<AnyCancellable>()

    // Dependencies
    private let moviesRepo: iTunesRepositoryProtocol? = DependencyContainer.shared.moviesRepository
    private let moviesManager: MoviesManager? = DependencyContainer.shared.moviesManager

    init() {
        setupBindings()
    }

    private func setupBindings() {
        moviesRepo?.offlineMoviesSubject
        // avoid updating views if the movies list is still same
            .removeDuplicates()
        // receive on main queue so that in sink we assign to view
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        // now use published value
            .sink { [weak self] favoriteMovies in
                self?.favoriteMovies = favoriteMovies
            }
            .store(in: &cancellables)
    }
}
