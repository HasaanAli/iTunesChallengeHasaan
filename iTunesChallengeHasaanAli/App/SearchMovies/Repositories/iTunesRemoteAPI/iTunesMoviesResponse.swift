//
//  iTunesMoviesResponse.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 14/03/2025.
//

import Foundation

/// Model to represent iTunes API response.
struct iTunesMoviesResponse: Codable {
    let resultCount: Int
    let results: [iTunesMoviesResponseResult]
}

/// Model to represent iTunes API response result.
struct iTunesMoviesResponseResult: Codable {
    let wrapperType: String? // "track",
    let kind: String? // "feature-movie",
    let collectionId: UInt? // 982641672,
    let trackId: UInt? // 975080816,
    let artistName: String? // "George Lucas",
    let collectionName: String? // "Star Wars: The Digital Movie Collection",
    let trackName: String? // "Star Wars: The Phantom Menace",
    let collectionCensoredName: String? // "Star Wars: The Digital Movie Collection",
    let trackCensoredName: String? // "Star Wars: The Phantom Menace",
    let collectionArtistId: UInt? // 410641764,
    let collectionArtistViewUrl: String? // "https://itunes.apple.com/au/artist/buena-vista-home-entertainment-inc/410641764?uo=4",
    let collectionViewUrl: String? // "https://itunes.apple.com/au/movie/star-wars-the-phantom-menace/id975080816?uo=4",
    let trackViewUrl: String? // "https://itunes.apple.com/au/movie/star-wars-the-phantom-menace/id975080816?uo=4",
    let previewUrl: String? // "https://video-ssl.itunes.apple.com/itunes-assets/Video113/v4/4c/88/67/4c8867ee-f781-cc02-fd72-972a1d11ac7e/mzvf_4694524656895114499.640x360.h264lc.U.p.m4v",
    let artworkUrl30: String? // "https://is1-ssl.mzstatic.com/image/thumb/Video123/v4/18/98/ce/1898cea4-56a5-0542-c115-f1057ed45fea/pr_source.lsr/30x30bb.jpg",
    let artworkUrl60: String? // "https://is1-ssl.mzstatic.com/image/thumb/Video123/v4/18/98/ce/1898cea4-56a5-0542-c115-f1057ed45fea/pr_source.lsr/60x60bb.jpg",
    let artworkUrl100: String? // "https://is1-ssl.mzstatic.com/image/thumb/Video123/v4/18/98/ce/1898cea4-56a5-0542-c115-f1057ed45fea/pr_source.lsr/100x100bb.jpg",
    let collectionPrice: Double? // 19.99,
    let trackPrice: Double? // 19.99,
    let collectionHdPrice: Double? // 19.99,
    let trackHdPrice: Double? // 19.99,
    let releaseDate: String? // "1999-05-19T07:00:00Z",
    let collectionExplicitness: String? // "notExplicit",
    let trackExplicitness: String? // "notExplicit",
    let discCount: UInt? // 1,
    let discNumber: UInt? // 1,
    let trackCount: UInt? // 6,
    let trackNumber: UInt? // 1,
    let trackTimeMillis: UInt? // 8180628,
    let country: String? // "AUS",
    let currency: String? // "AUD",
    let primaryGenreName: String? // "Action & Adventure",
    let contentAdvisoryRating: String? // "PG",
    let shortDescription: String? // "For the first time ever on digital, experience the heroic action and unforgettable adventures of",
    let longDescription: String? // "Experience the heroic action and unforgettable adventures of Star Wars: Episode I - The Phantom Menace.  See the first fateful steps in the journey of Anakin Skywalker. Stranded on the desert planet Tatooine after rescuing young Queen Amidala from the impending invasion of Naboo, Jedi apprentice Obi-Wan Kenobi and his Jedi Master Qui-Gon Jinn discover nine-year-old Anakin, a young slave unusually strong in the Force. Anakin wins a thrilling Podrace and with it his freedom as he leaves his home to be trained as a Jedi. The heroes return to Naboo where Anakin and the Queen face massive invasion forces while the two Jedi contend with a deadly foe named Darth Maul. Only then do they realize the invasion is merely the first step in a sinister scheme by the re-emergent forces of darkness known as the Sith.",
    let hasITunesExtras: Bool? // true
}
