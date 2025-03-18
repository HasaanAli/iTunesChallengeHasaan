//
//  iTunesLocalStorage.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 13/03/2025.
//

import Foundation
import Combine
import RealmSwift

// MARK: - Protocol

/// Protocol for talking to iTunes remote API. Protocol abstracts away the internal implementation like Alamofire vs. other networking libraries.
protocol iTunesLocalStorageProtocol {
    /// Subscribe to this CurrentValueSubject for getting all movies stored in the local storage.
    var allMoviesSubject: CurrentValueSubject<[Movie], Never> { get }

    /// Get movies by query string.
    func getMovies(search: String) async -> [Movie]

    /// Get movies by id.
    func getMovies(ids: [String]) async -> [Movie]

    /// Save passed movie objects to the local storage.
    func save(movies: [Movie]) throws

    /// Delete passed movie objects from the local storage.
    func delete(movies: [Movie]) throws

    /// Save file to documents directory.
    func saveDownloadedFile(downloadedFileURL: URL, for movie: Movie) throws -> URL
}

// MARK: - Protocol default implementation.

/// Default implementation of the `iTunesLocalStorageProtocol` based on the `Realm` database.
class iTunesLocalStorage: iTunesLocalStorageProtocol {
    let allMoviesSubject: CurrentValueSubject<[Movie], Never>

    private let realm: Realm
    private var allMoviesCancellabe: AnyCancellable?

    /// Throwing initializer.
    /// - Throws: Realm initialization error.
    init() throws {
        NSLog("init iTunesLocalStorage")
        do {
            self.realm = try Realm()
        } catch {
            throw iTunesLocalStorageError.localStorageNotAvailable
        }

        allMoviesSubject = CurrentValueSubject<[Movie], Never>([])
        startObservingAllMovies()
    }

    deinit {
        NSLog("deinit iTunesLocalStorage")
        unsubscribeToAllMovies()
    }

    private func startObservingAllMovies() {
        allMoviesCancellabe = realm.objects(RealmMovie.self).collectionPublisher
            .sink { failure in
                debugPrint(failure)
            } receiveValue: { [weak self] realmMoviesResult in
                let array = Array(realmMoviesResult)
                let allMovies = array.compactMap { $0.domainModel }
                self?.allMoviesSubject.send(allMovies)
            }
    }

    private func unsubscribeToAllMovies() {
        allMoviesCancellabe = nil
    }

    func getMovies(search: String) async -> [Movie] {
        await MainActor.run {
            // we donot validate the input query 'search' here. It is done on single-place i.e in MoviesManager.

            // get realm movies whose textual properties contain the search, case insensitive

            let realmMovies = realm.objects(RealmMovie.self).filter { realmMovie in
                let nameContains = realmMovie.name.lowercased().contains(search.lowercased())
                let genreContains = realmMovie.genre.lowercased().contains(search.lowercased())
                let longDescription = realmMovie.longDescription ?? ""
                let descContains = longDescription.lowercased().contains(search.lowercased())

                return nameContains || genreContains || descContains
            }

            // Convert RealmMovie to Movie
            return realmMovies.compactMap { $0.domainModel }
        }
    }

    func getMovies(ids: [String]) async -> [Movie] {
        await MainActor.run {
            let realmMovies = realmMovies(byIds: ids)

            // Convert RealmMovie to Movie
            return realmMovies.compactMap { $0.domainModel }
        }
    }

    /// Realm results query for finding movies with given ids.
    private func realmMovies(byIds ids: [String]) -> LazyFilterSequence<Results<RealmMovie>> {//RealmSwift.Results<RealmMovie> {
        // create ids to set for quick O(N) search where N is number of movies stored in the DB.
        let idsSet = Set<String>(ids)
        // get realm movies whose id is present in given ids
        let realmMovies = realm.objects(RealmMovie.self).filter { realmMovie in
            idsSet.contains(realmMovie.id)
        }
        return realmMovies
    }

    func save(movies: [Movie]) throws {
        DispatchQueue.main.async {
            self.realm.writeAsync {
                let realmMovies = movies.map { RealmMovie(movie: $0) }
                // UPSERT is performed by passing update: .modified or .all
                self.realm.add(realmMovies, update: .modified)
            }
        }
    }

    func delete(movies: [Movie]) throws {
        DispatchQueue.main.async {
            self.realm.writeAsync {
                let realmMovies = self.realmMovies(byIds: movies.map({$0.id}))
                self.realm.delete(realmMovies)

            }
        }
    }

    /// Save file to documents directory.
    func saveDownloadedFile(downloadedFileURL: URL, for movie: Movie) throws -> URL {
        let fileManager = FileManager.default
        do {
            // path to documents directory in the app container
            let documentsDirectory = try fileManager.url(for: .documentDirectory,
                                                         in: .userDomainMask,
                                                         appropriateFor: nil, create: false)

            // Create the destination file URL
            let path = movie.id + ".jpg"
            let destinationURL = documentsDirectory.appending(path: path)

            // if file already exists, remove it first before writing it on that path
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }

            // Move the file to the Documents directory
            try fileManager.moveItem(at: downloadedFileURL, to: destinationURL)

            NSLog("File moved to Documents directory successfully at: \(destinationURL.path)")
            return destinationURL

        } catch {
            NSLog("Error moving file: \(error.localizedDescription)")
            // Throw custom error if the code above throws some error.
            throw iTunesLocalStorageError.localFileMoveError
        }
    }
}
