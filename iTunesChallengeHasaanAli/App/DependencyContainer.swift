//
//  File.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

/// Singleton class containing the shared dependencies to be used across the app.
/// Alternatively, we can use Resolver for advanced cases.
class DependencyContainer {

    /// Shared instance.
    static let shared = DependencyContainer()

    let moviesRepository: iTunesRepositoryProtocol?
    let moviesManager: MoviesManager?
    let appCommonsLocalStorage: AppCommonsLocalStorage?

    private init() {
        moviesRepository = try? iTunesRepository()
        moviesManager = try? MoviesManager(repository: moviesRepository)
        appCommonsLocalStorage = try? AppCommonsLocalStorage()
    }
}
