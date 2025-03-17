//
//  AppCommons.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import Foundation

/// Struct to store app's overall common state.
struct AppCommons {
    /// Constant id because there is only one and unique appCommons instance. If there needs be user profiles features, this will be one instance per profile.
    let id = "constant"
    let lastVisitedDate: Date?
}
