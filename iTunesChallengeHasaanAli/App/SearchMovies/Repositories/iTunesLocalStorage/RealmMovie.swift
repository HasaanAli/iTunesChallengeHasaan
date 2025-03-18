//
//  RealmMovie.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 13/03/2025.
//

import RealmSwift

/// Persistence model for `Movie`.
class RealmMovie: Object {

    // MARK: - Persistance model properties to map domain model

    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var remoteArtURL: String?
    /// It is relative path in file system, relative to documents directory.
    /// Relative path is preferred instead of absolute path, because the app container changes on app updates making previously stored absolute url invalid.
    @Persisted var localArtURLRelativePath: String?
    @Persisted var priceUSD: Double
    @Persisted var genre: String
    @Persisted var longDescription: String?
    @Persisted var isFavorite: Bool

    private let localArtsDirectory = FileManager.SearchPathDirectory.documentDirectory

    // MARK: - Domain model to persistance model conversion

    convenience init(movie: Movie) {
        self.init()
        self.id = movie.id
        self.name = movie.name
        self.remoteArtURL = movie.remoteArtURL?.absoluteString
        if let localArtURL = movie.localArtURL {
            self.localArtURLRelativePath = convertUrlToRelativePath(localArtUrl: localArtURL)
        } else {
            self.localArtURLRelativePath = nil
        }
        self.priceUSD = movie.priceUSD
        self.genre = movie.genre
        self.longDescription = movie.longDescription
        self.isFavorite = movie.isFavorite
    }

    var domainModel: Movie? {
        let remoteURL: URL?
        if let remoteArtURL = self.remoteArtURL {
            remoteURL = URL(string: remoteArtURL)
        } else {
            remoteURL = nil
        }

        let localUrl: URL?
        if let localRelativePath = self.localArtURLRelativePath {
            localUrl = convertLocalArtRelativePathToUrl(localArtRelativePath: localRelativePath)
        } else {
            localUrl = nil
        }

        return Movie(id: id, name: name,
                     remoteArtURL: remoteURL, localArtURL: localUrl,
                     priceUSD: priceUSD, genre: genre, longDescription: longDescription,
                     isFavorite: isFavorite)
    }

    // - MARK: - Image URL to relative path converters

    /// Convert the path relative to document doc
    private func convertUrlToRelativePath(localArtUrl: URL) -> String {

        let fileManager = FileManager.default
        do {
            // path to documents directory in the app container
            let documentsDirectory = try fileManager.url(for: localArtsDirectory,
                                                         in: .userDomainMask,
                                                         appropriateFor: nil, create: false)
            // remove documents directory path from file path, so that path after documents directory is left.
            // this is called relative path of path, i.e relative to documents directory.
            let relativePath = localArtUrl.absoluteString.replacingOccurrences(of: documentsDirectory.absoluteString, with: "")
            return relativePath
        } catch {
            NSLog("Error in \(#function): \(error.localizedDescription)")
            return ""
        }
    }
    /// Convert the path relative to document doc
    private func convertLocalArtRelativePathToUrl(localArtRelativePath: String) -> URL? {

        let fileManager = FileManager.default
        do {
            // path to documents directory in the app container
            let documentsDirectory = try fileManager.url(for: localArtsDirectory,
                                                         in: .userDomainMask,
                                                         appropriateFor: nil, create: false)
            // Create the destination file URL
            let destinationURL = documentsDirectory.appending(path: localArtRelativePath)

            return destinationURL
        } catch {
            NSLog("Error in \(#function): \(error.localizedDescription)")
            return nil
        }
    }
}
