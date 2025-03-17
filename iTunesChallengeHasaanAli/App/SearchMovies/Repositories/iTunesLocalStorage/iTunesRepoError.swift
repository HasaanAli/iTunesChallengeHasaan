//
//  iTunesRepoError.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 15/03/2025.
//

/// Error type thrown by iTunesLocalStorageProtocol implementations.
enum iTunesLocalStorageError: Error {
    case localStorageNotAvailable
    case localStorageWriteFailed
    case localFileMoveError
}
