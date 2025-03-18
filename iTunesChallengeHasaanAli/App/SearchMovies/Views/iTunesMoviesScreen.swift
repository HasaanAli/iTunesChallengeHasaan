//
//  iTunesMoviesScreen.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 15/03/2025.
//

import SwiftUI

/// Main screen acting as root view of our app.
struct iTunesMoviesScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                FavoriteMoviesView()
                MoviesSearchList()
            }
        }
    }
}

#Preview {
    iTunesMoviesScreen()
}
