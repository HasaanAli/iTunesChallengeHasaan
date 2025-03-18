//
//  iTunesRemoteAPI.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 13/03/2025.
//

import Alamofire


// MARK: - Protocol

/// Protocol for talking to iTunes remote API. Protocol abstracts away the internal implementation like Alamofire vs. other networking libraries.
protocol iTunesRemoteAPIProtocol {
    /// Get movies matching search query.
    /// It returns no results when the search is empty.
    func getMovies(search: String) async throws -> [Movie]

    /// Download art of movie and return the URL of tmp file.
    func downloadMovieArt(movieArtURL: URL) async throws -> URL
}

// MARK: - Protocol implementation

class iTunesRemoteAPI: iTunesRemoteAPIProtocol {

    /// Build API url string from given search query.
    private func buildURLString(search: String) -> String {
        return "https://itunes.apple.com/search?term=" + search + "&country=au&media=movie"
    }

    // Docs are inherted from protocol.
    func getMovies(search: String) async throws -> [Movie] {
        // Trim whitespaces
        let search = search.trimmingCharacters(in: .whitespaces)

        // Check empty search string
        guard !search.isEmpty else {
            return []
        }

        let urlString = buildURLString(search: search)
        URLCache.shared.removeAllCachedResponses() // remove cached responses to see only offline available movies
        let response = try await AF.request(urlString)
            .serializingDecodable(iTunesMoviesResponse.self)
            .value

        return convertResponseToMovies(response: response)
    }

    /// Convert API response to array of domain model `Movie`.
    private func convertResponseToMovies(response: iTunesMoviesResponse) -> [Movie] {
        return response.results.compactMap { apiMovie in
            guard let trackId = apiMovie.trackId,
                  let name = apiMovie.trackName,
                  let remoteArtUrlString = apiMovie.artworkUrl100,
                  let remoteArtUrl = URL(string: remoteArtUrlString),
                  let priceUSD = apiMovie.trackPrice,
                  let genre = apiMovie.primaryGenreName,
                  let longDesc = apiMovie.longDescription else {
                return nil
            }

            return Movie(id: String(trackId), name: name, remoteArtURL: remoteArtUrl,
                         localArtURL: nil, // it will be set once art is downloaded
                         priceUSD: priceUSD, genre: genre, longDescription: longDesc,
                         isFavorite: false) // it is false here, it will be set by caller
        }
    }

    // Docs are inherted from protocol.
    func downloadMovieArt(movieArtURL: URL) async throws -> URL {
        let result =  try await AF.download(movieArtURL)
                        .serializingDownloadedFileURL()
                        .value
        return result
    }
}
