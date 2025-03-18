//
//  MovieFavoriteButton.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import SwiftUI

/// A heart button allowing user to mark a movie as favorite.
struct MovieFavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: 20, height: 20)
        }
            .buttonStyle(BorderlessButtonStyle())
    }
}
