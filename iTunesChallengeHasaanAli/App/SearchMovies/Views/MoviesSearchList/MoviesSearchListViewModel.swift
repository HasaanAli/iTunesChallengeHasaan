//
//  MoviesSearchListViewModel.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 11/03/2025.
//

import Foundation
import Combine

enum SearchState {
    case startSearch
    case searching
    case showResults
    case noResults
}

@MainActor
class MoviesSearchListViewModel: ObservableObject {
    @Published var searchString: String = ""
    @Published var searchState: SearchState = .startSearch // because searchString is empty
    @Published var movies: [Movie] = []
    @Published private var favoriteMovies: [Movie] = []

    // Cancellables
    private var cancellables = Set<AnyCancellable>()

    // Dependencies
    private let moviesRepo: iTunesRepositoryProtocol? = DependencyContainer.shared.moviesRepository
    private let moviesManager: MoviesManager? = DependencyContainer.shared.moviesManager

    init() {
        setupBindings()
    }

    private func setupBindings() {
        whenSearchStringChangesPerformSearch()
        whenMovieIsUpdatedInRepoUpdateItHere()
    }

    private func whenSearchStringChangesPerformSearch() {
        $searchString
        // receive on bg queue so that further processing happens there
            .receive(on: DispatchQueue.global(qos: .userInitiated))
        // don't perform search while input is still changing
            .debounce(for: .seconds(0.5), scheduler: RunLoop.current)
        // now process search input
            .sink { [weak self] searchString in
                guard let self, let moviesRepo else {
                    NSLog("Error: Cannot search movies, moviesManager is not available")
                    return
                }
                if searchString.isEmpty {
                    searchState = .startSearch
                    return
                }
                searchState = .searching
                Task {
                    let movies = await moviesRepo.getMovies(search: searchString)
                    self.movies = movies
                    moviesRepo.downloadMoviesArt(movies: movies)
                    self.searchState = movies.isEmpty ? .noResults : .showResults
                }
            }
            .store(in: &cancellables)
    }

    private func whenMovieIsUpdatedInRepoUpdateItHere() {
        moviesRepo?.movieUpdatedSubject
        // receive on main thread
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieWithArt in
                guard let self else { return }
                // find matching movie by id and replace the object
                if let existingIndex = self.movies.firstIndex(where: {$0.id == movieWithArt.id}) {
                    self.movies[existingIndex] = movieWithArt
                }
            }
            .store(in: &cancellables)
    }

    func tappedFavorite(movie: Movie) {
        if movie.isFavorite {
            moviesManager?.unmarkFavorite(movie: movie)
        } else {
            moviesManager?.markFavorite(movie: movie)
        }
    }
}
