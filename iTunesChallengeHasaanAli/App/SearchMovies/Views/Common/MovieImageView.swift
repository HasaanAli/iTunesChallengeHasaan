//
//  MovieImageView.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import SwiftUI

/// A common view for showing the movie art. If the art is not available, it shows default placeholder icon with purple tint.
struct MovieImageView: View {
    /// URL pointing to an offline-available image.
    let imageUrl: URL?

    var body: some View {
        urlOrResourceImage(imageUrl: imageUrl)
            .resizable()
    }

    func urlOrResourceImage(imageUrl: URL?) -> Image {
        if let imageUrl,
           let data = try? Data.init(contentsOf: imageUrl),
           let uiImage = UIImage.init(data: data) {
            Image(uiImage: uiImage)
        } else {
            Image(systemName: "film")
        }
    }

}
