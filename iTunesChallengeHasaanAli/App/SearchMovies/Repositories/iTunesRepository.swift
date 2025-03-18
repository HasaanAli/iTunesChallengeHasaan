//
//  iTunesRepository.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 11/03/2025.
//

import Foundation
import Combine


// MARK: - Protocol

protocol iTunesRepositoryProtocol {
    /// CurrentValueSubject for getting offline movies. Subscribe to this subject to get notified about current offline-available movies items.
    var offlineMoviesSubject: CurrentValueSubject<[Movie], Never> { get }

    /// Subscribe this subject to get Movie object when it is updated, like its Movie.localArtUrl is set, or isFavorite is changed.
    var movieUpdatedSubject: PassthroughSubject<Movie, Never> { get }

    /// Get movies matching search query.
    /// It returns no results when the search is empty.
    func getMovies(search: String) async -> [Movie]

    /// Download thumbnails for given movies. To get updated movie objects, subscribe to updatedMovieSubject.
    /// This method does not return any value.
    func downloadMoviesArt(movies: [Movie])

    /// Add movie to offline-available items.
    func saveOffline(movie: Movie)

    /// Remove movie from offline-available items.
    func removeOffline(movie: Movie)
}

// MARK: - Protocol implementation

class iTunesRepository: iTunesRepositoryProtocol {
    /// CurrentValueSubject for getting offline movies. Subscribe to this subject to get notified about current offline-available movies items.
    let offlineMoviesSubject: CurrentValueSubject<[Movie], Never>

    /// Subscribe this subject to get Movie object when it is updated, like its Movie.localArtUrl is set, or isFavorite is changed.
    let movieUpdatedSubject = PassthroughSubject<Movie, Never>()

    // Dependencies
    private let itunesRemoteAPI: iTunesRemoteAPIProtocol
    private let itunesLocalStorage: iTunesLocalStorageProtocol

    /// Initialize iTunesRepository with default or given dependencies.
    ///
    /// - Parameters:
    ///
    /// - Parameter itunesRemoteAPI: Instances of iTunesRemoteAPIProtocol. Optional.
    /// - Parameter itunesLocalStorage: Instances of iTunesLocalStorageProtocol. Optional.
    /// 
    /// - Throws: iTunesLocalStorage initialization error if itunesLocalStorage parameter value is not given.
    init(itunesRemoteAPI: iTunesRemoteAPIProtocol? = nil,
         itunesLocalStorage: iTunesLocalStorageProtocol? = nil) throws {

        // assign given itunesLocalStorage, or create default
        self.itunesRemoteAPI = itunesRemoteAPI ?? iTunesRemoteAPI()

        // assign given itunesLocalStorage, or create default
        if let itunesLocalStorage {
            self.itunesLocalStorage = itunesLocalStorage
        } else {
            self.itunesLocalStorage = try iTunesLocalStorage()
        }

        // Initialize offlineMoviesSubject.
        // Assign iTunesLocalStorage.allMoviesSubject to self.offlineMoviesSubject. This way when someone
        // subscribes to repository's offlineMoviesSubject, he is actually subscribing to localStorage.allMoviesSubject
        offlineMoviesSubject = self.itunesLocalStorage.allMoviesSubject
    }

    /**
     There are several possibilities.
     - A movie is present in remote results but not in local
     - A movie is present in local results but not in remote
     - Possibility: Remote results might be empty due to network failure.
     - A movie is present in both remote and local results
     */
    func getMovies(search: String) async -> [Movie] {
        // Validation of input query:

        // Trim whitespaces
        let search = search.trimmingCharacters(in: .whitespaces)

        // Check empty search string
        guard !search.isEmpty else {
            return []
        }

        // Perform search
        // Search online, if success, update result with locally stored info (e.g favorite), return the result
        // if fails, search in locally stored info, return result

        // get matching movies from remote API
        let remoteMovies: [Movie]
        do {
            remoteMovies = try await itunesRemoteAPI.getMovies(search: search)
        } catch {
            // API threw some error, log that error
            NSLog("iTunesRepository: RemoteAPI has thrown error: \(error)")
            //and assign empty value to remoteMovies
            remoteMovies = []
        }

        // Check basic case: if no remote matches are empty, then perform search on localStorage
        if remoteMovies.isEmpty { // can use guard but if is more readable
            // get matching movies from local storage
            let localMovies = await itunesLocalStorage.getMovies(search: search)
            return localMovies
        }

        // Now we are sure remote results are not empty, so for each remote movie, we'll just
        // 1. update isFavorite property of remote results
        // 2. then update whole object in local storage. This covers scenario if some properties are updated on remote.

        let remoteMoviesIds = remoteMovies.map { $0.id }
        let localMovies = await itunesLocalStorage.getMovies(ids: remoteMoviesIds)

        // create local movies dictionary for quick operations (insert, find, remove)
        let localMoviesMap = Dictionary(uniqueKeysWithValues: localMovies.map{ ($0.id, $0) })

        var resultMovies = [Movie]()    // to return
        var moviesToUpdateInLocalStorage = [Movie]() // to pass to localStorage to update in single write transaction

        // Iterate over remote movies
        for remoteMovie in remoteMovies {
            // if local result exists, update its isFavorite and localArt from local object
            if let localMovie = localMoviesMap[remoteMovie.id] {
                let updatedRemoteMovie = remoteMovie
                                            .marking(favorite: localMovie.isFavorite)
                                            .setting(localArtURL: localMovie.localArtURL)
                // collect it in result
                resultMovies.append(updatedRemoteMovie)
                // collect it in array to be passed to db
                moviesToUpdateInLocalStorage.append(updatedRemoteMovie)
            } else {
                // if local result is not present for this movie, add it to the result
                resultMovies.append(remoteMovie)
            }
        }

        // pass to db the remote objects to update in db
        try? itunesLocalStorage.save(movies: moviesToUpdateInLocalStorage)
        // return result
        return resultMovies
    }

    /// Download movie art for the given movies whose `localArtURL` is nil.
    func downloadMoviesArt(movies: [Movie]) {
        let moviesWithoutArt = movies.filter({$0.localArtURL == nil})

        for movie in moviesWithoutArt {
            guard let remoteArtURL = movie.remoteArtURL else {
                continue
            }
            // separate task for each movie art
            Task {
                do {
                    let movieArtTmpURL = try await itunesRemoteAPI.downloadMovieArt(movieArtURL: remoteArtURL)
                    let updatedURL = try itunesLocalStorage.saveDownloadedFile(downloadedFileURL: movieArtTmpURL, for: movie)
                    // update movie's localArtURL and send via movieUpdatedSubject to subscribers
                    let updatedMovie = movie.setting(localArtURL: updatedURL)
                    movieUpdatedSubject.send(updatedMovie)
                } catch {
                    NSLog("iTunesRepository: Error while downloading movie art: \(error)")
                }
            }
        }
    }

    /// Save the movie to local storage. It sends an update through the `movieUpdatedSubject`.
    func saveOffline(movie: Movie) {
        try? itunesLocalStorage.save(movies: [movie])
        movieUpdatedSubject.send(movie)
    }

    /// Removes the movie from local storage. It sends an update through the `movieUpdatedSubject`.
    func removeOffline(movie: Movie) {
        try? itunesLocalStorage.delete(movies: [movie])
        movieUpdatedSubject.send(movie)
    }
}
